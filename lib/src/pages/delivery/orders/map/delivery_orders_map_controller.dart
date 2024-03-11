import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/orders_provaider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrdersMapController {
  BuildContext context;
  Function refresh;
  Position _position;
  StreamSubscription _positionStream;
  static const LatLng sourceLocation = LatLng(13.477891, -88.164898);
  String addressName;
  LatLng addressLatLng;
  BitmapDescriptor deliveryMarquet;
  BitmapDescriptor tooMarker;
  CameraPosition initialPosition =
      CameraPosition(target: sourceLocation, zoom: 14);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _mapController = Completer();
  Order order;
  OrdersProvaider _ordersProvaider = OrdersProvaider();
  User user;
  SharedPref _sharedPref = new SharedPref();
  double _distanceBetween;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>);

        
    deliveryMarquet = await createMarkerFromAsset('assets/img/delivery2.png');
    tooMarker = await createMarkerFromAsset('assets/img/home.png');
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvaider.init(context, user);
    checkGPS();
    refresh();
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(
        _position?.latitude, _position?.longitude, order?.lat, order?.lng);

    print('--------DISTANCIA ${_distanceBetween} -----');
  }

  void updateToDelivery() async {
    ResponseApi responseApi = await _ordersProvaider.updateToDelivery(order);
    if (responseApi.success) {
      MySnackbar.show(context, responseApi.message);
      Navigator.pushNamedAndRemoveUntil(context, 'delivery/orders/list', (route) => false);
    }
  }

  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void addMarket(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));

    markers[id] = marker;
    refresh();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'lng': addressLatLng.longitude
    };

    Navigator.pop(context, data);
  }

  Future<Null> setLocationDraggableInfo() async {
    try {
      if (initialPosition != null) {
        double lat = initialPosition.target.latitude;
        double lng = initialPosition.target.longitude;

        List<Placemark> address = await placemarkFromCoordinates(lat, lng);
        if (address != null) {
          if (address.length > 0) {
            String direction = address[0].thoroughfare;
            String street = address[0].subThoroughfare;
            String city = address[0].locality;
            String department = address[0].administrativeArea;
            String country = address[0].country;

            addressName = '$direction #$street, $city, $department';
            addressLatLng = LatLng(lat, lng);
            print('LAT: ${addressLatLng.latitude}');
            print('LONG ${addressLatLng.longitude}');
            refresh();
          }
        }
      }
    } catch (e) {}
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void dispose() {
    _positionStream?.cancel();
  }

  void updateLocation() async {
    try {
      _position = await Geolocator.getLastKnownPosition();
      animatedCamera(_position.latitude, _position.longitude);

      addMarket('delivery', _position.latitude, _position.longitude,
          'Tu posicion', '', deliveryMarquet);
      addMarket('home', order.address.lat, order.address.lng,
          'Orden de entrega', '', tooMarker);
      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        print(position);
        _position = position;
        addMarket('delivery', _position?.latitude, _position?.longitude,
            'Tu posicion', '', deliveryMarquet);

        animatedCamera(_position?.latitude, position?.longitude);
        isCloseToDeliveryPosition();
        refresh();
      });
    } catch (e) {
      print(e);
    }
  }

  //FIJAR CAMARA EN LA DIRECCION DEL MAPA
  Future animatedCamera(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;

    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15)));
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();

      if (locationGPS) {
        updateLocation();
      }
    }
  }

  //DETERMINA LA POSICION ACTUAL
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  //FUNCION LLAMADA
  void call() {
    launch("tel://${order.client.phone}");
  }
}
