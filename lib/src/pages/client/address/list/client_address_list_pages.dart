
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:flutter_delivery/src/Models/address.dart';

class ClientAddressListPages extends StatefulWidget {
  const ClientAddressListPages({Key key}) : super(key: key);

  @override
  State<ClientAddressListPages> createState() => _ClientAddressListPagesState();
}

class _ClientAddressListPagesState extends State<ClientAddressListPages> {

  ClientAddressListController _con =new ClientAddressListController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Direcciones'),
        actions: [
          _iconAdd(),

        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: _textSelectAddress()
          ),

          Container(
              margin: EdgeInsets.only(top: 50),
              child: _listAddress())
        ],
      ),
      bottomNavigationBar: _buttonAcept(),
    );
  }

  Widget _listAddress(){
    
    print("Entro a la funcions");
    return FutureBuilder(
        future: _con.getAdress(),
        builder: (context,AsyncSnapshot<List<Adress>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index){
                    return _radioSelectorAddress(snapshot.data[index], index);
                  }
              );
            }else{
              print("No hay data");
              return _noAddress();
            }
          }else{
            print("No hay data");
            return _noAddress();
          }
        }
    );
  }

  Widget _noAddress(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top:30),
          child: NoDataWidget(text: "No tienes niguna direccion"),
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _radioSelectorAddress(Adress adress, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                  value: index,
                  groupValue: _con.radioValue,
                  onChanged:_con.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      adress?.address ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  Text(
                    adress?.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              )
            ],
          ),
          Divider(color: Colors.grey)
        ],
      ),
    );

  }

  Widget _textSelectAddress(){

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
      child: Text('Elige donde quieres tus compras',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                  ),
      ),


    );
  }
  
  Widget _iconAdd(){
    
    return IconButton(
        onPressed: _con.goToAdress,
        icon: Icon(Icons.add, color: Colors.white)
    );
  }

  Widget _buttonAcept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(

        onPressed:_con.createOrder ,
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

  Widget _buttonNewAddress(){

    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 40),
      child: ElevatedButton(
        onPressed: (){

        },
        child: Text('Nueva direccion'),

      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
