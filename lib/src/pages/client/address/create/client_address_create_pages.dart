import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/client/address/create/client_address_create_controller.dart';

import '../../../../utils/main_colors.dart';

class ClientAddressCreatePages extends StatefulWidget {
  const ClientAddressCreatePages({Key key}) : super(key: key);

  @override
  State<ClientAddressCreatePages> createState() => _ClientAddressCreatePagesState();
}

class _ClientAddressCreatePagesState extends State<ClientAddressCreatePages> {

  ClientAddressCreateController _conn = new ClientAddressCreateController();
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
        title: Text('Nueva Direccion'),
      ),
      body: Column(
        children: [
          _textSelectAddress(),
          _textFliedAddress(),
          _textFieldNeighborhood(),
          _textFieldRefPoint()
        ],
      ),

      bottomNavigationBar: _buttonAcept(),
    );
  }

  Widget _buttonAcept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(

        onPressed:_conn.createAddress ,
        child: Text(
            'ACEPTAR'
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
  Widget _textSelectAddress(){

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
      child: Text('Completa los siguientes campos ',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),


    );
  }
  Widget _textFliedAddress(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _conn.addressController,
        decoration: InputDecoration(
          labelText: 'Nueva direccion',
          suffixIcon: Icon(
            Icons.location_on,
            color: MyColors.primaryColors,
          )

        ),
      ),
    );
  }
  Widget _textFieldNeighborhood(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _conn.neighborhoodController,
        decoration: InputDecoration(
          labelText: 'Barrio',
          suffixIcon: Icon(
              Icons.location_city,
              color: MyColors.primaryColors,
          ),
        ),
      ),
    );
  }
  Widget _textFieldRefPoint(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 11),
      child: TextField(
        onTap: _conn.openMap,
        controller: _conn.refPointController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
          labelText: 'Punto de referencia',
          suffixIcon: Icon(
            Icons.map,
            color: MyColors.primaryColors,
          )
        ),
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {

  @override
  bool get hasFocus=> false;
}
