import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';

class ClientAddressMapController{

  BuildContext context;
  Function refresh;
  Position _position;
  static const LatLng sourceLocation = LatLng(13.477891, -88.164898);
  String addressName;
  LatLng addressLatLng;

  CameraPosition initialPosition=CameraPosition(
      target: sourceLocation,
      zoom: 14
  );

  Completer<GoogleMapController> _mapController = Completer();
  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh= refresh;
    checkGPS();
  }

  void selectRefPoint(){
    Map<String, dynamic> data ={
      'address':addressName,
      'lat': addressLatLng.latitude,
      'lng':addressLatLng.longitude
    };
    
    Navigator.pop(context,data);
  }

  Future<Null>setLocationDraggableInfo() async {
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      if(address != null){
        if(address.length >0){
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department= address[0].administrativeArea;
          String country = address[0].country;

          addressName = '$direction #$street, $city, $department';
          addressLatLng=LatLng(lat, lng);
          print('LAT: ${addressLatLng.latitude}');
          print('LONG ${addressLatLng.longitude}');
          refresh();
        }
      }
    }
  }



 void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }
  
  void updateLocation() async{
    try{
      _position = await Geolocator.getLastKnownPosition();
      animatedCamera(_position.latitude,_position.longitude);
    }catch(e){
      print('Error '+ e);
    }
  }

  //FIJAR CAMARA EN LA DIRECCION DEL MAPA
  Future animatedCamera(double lat, double lng) async{
    GoogleMapController controller = await _mapController.future;

    if(controller != null){
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat,lng),
          zoom: 15
      )));
    }
  }

  void checkGPS()async{
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled){
      updateLocation();
    }else{
      bool locationGPS= await location.Location().requestService();

      if(locationGPS){
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


}