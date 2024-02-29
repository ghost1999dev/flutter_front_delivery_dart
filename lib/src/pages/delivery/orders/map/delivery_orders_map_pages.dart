import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:flutter_delivery/src/pages/delivery/list/delivey_orders_list_controller.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/map/delivery_orders_map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/main_colors.dart';

class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({Key key}) : super(key: key);

  @override
  State<DeliveryOrdersMapPage> createState() => _DeliveryOrdersMapPageState();
}

class _DeliveryOrdersMapPageState extends State<DeliveryOrdersMapPage> {
  DeliveryOrdersMapController _conn = new DeliveryOrdersMapController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _conn.init(context, refresh);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _conn.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _googleMaps()),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
            child: _cardAddress(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAcept(),
          ),
          SafeArea(
            child: Column(
              children: [_buttonCenterPosition(), Spacer(), _cardOrderInfo()],
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonAcept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _conn.selectRefPoint,
        child: Text('SELECCIONAR ESTE PUNTO'),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: MyColors.primaryColors),
      ),
    );
  }

  Widget _cardOrderInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: Column(
        children: [
          _lisTileAddress(
              _conn.order?.address?.neighborhood, 'Barrio', Icons.my_location),
          _lisTileAddress(
              _conn.order?.address?.address, 'Direccion', Icons.location_on),
          Divider(
            color: Colors.grey[400],
            endIndent: 30,
            indent: 30,
          ),
          _clientInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: FadeInImage(
              //VALIDAR SI NO TIENE IMAGEN EL PRODUCTO POR CATEGORIA
              image: _conn?.order?.client?.image != null
                  ? NetworkImage(_conn?.order?.client?.image)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              '${_conn.order?.client?.name ?? ''} ${_conn.order?.client?.lastname}',
              style: TextStyle(color: Colors.black, fontSize: 17),
              maxLines: 1,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: Colors.grey[200]),
            child: IconButton(
              onPressed: () {
                _conn.call();
              },
              icon: Icon(
                Icons.phone,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _lisTileAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title ?? '',
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(_conn.addressName ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  //BOTON CENTRAR POSICION
  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _conn.initialPosition,
      onMapCreated: _conn.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_conn.markers.values),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
      child: ElevatedButton(
        onPressed: _conn.updateToDelivery,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColors,
            //EXPANDIR LA ALTURA DEL BOTOM
            padding: EdgeInsets.symmetric(vertical: 5),

            //BORDES REDONDEADOS DEL BOTOM
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'ENTREGAR PRODUCTO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 4),
                height: 30,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
