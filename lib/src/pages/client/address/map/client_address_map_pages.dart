import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/main_colors.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key key}) : super(key: key);

  @override
  State<ClientAddressMapPage> createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  ClientAddressMapController _conn = new ClientAddressMapController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _conn.init(context, refresh);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona Direccion'),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.center,
            child: _iconMyLocation() ,
          ),
          Container(
            alignment: Alignment.topCenter,
            margin:EdgeInsets.only(top: 30),
            child: _cardAddress(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAcept(),
          )
        ],
      ),
    );
  }
  Widget _buttonAcept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(

        onPressed:_conn.selectRefPoint ,
        child: Text(
            'SELECCIONAR ESTE PUNTO'
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            primary:MyColors.primaryColors
        ),
      ),
    );
  }

  Widget _cardAddress(){
    return Container(
      child: Card(
        color:Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
              _conn.addressName ?? '',
                style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                    fontWeight:FontWeight.bold
              )
          ),
        ),
      ),
    );

  }

  Widget _iconMyLocation(){
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
    );
  }
  Widget _googleMaps(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _conn.initialPosition,
      onMapCreated: _conn.onMapCreated,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onCameraMove: (position){
        _conn.initialPosition=position;
      },
      onCameraIdle: () async{
        await _conn.setLocationDraggableInfo();
      },
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
