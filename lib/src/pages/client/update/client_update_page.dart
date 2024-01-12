import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/client/update/client_update_controller.dart';

import '../../../utils/main_colors.dart';


class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key key}) : super(key: key);

  @override
  State<ClientUpdatePage> createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {
  /*
  Metodo donde recibe el contexto del objeto del controlador
   */

  ClientUpdateController _con = new ClientUpdateController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                _imageUser(),
                SizedBox(height: 30),

                _textFieldUser(),
                _textFieldLastName(),
                _textFieldPhone(),


              ],
            ),
          ),
        ),
      bottomNavigationBar: _buttonLogin() ,
    );
  }


    Widget _textFieldUser(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)
        ),
        child: TextField(
            controller: _con.nameController,

            decoration: InputDecoration(
                hintText: 'Nombre',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color:MyColors.primaryColorDark
                ),
                prefixIcon: Icon(
                    Icons.person,
                    color:MyColors.primaryColors
                )
            )
        ),
      );
    }
    Widget _textFieldLastName(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)
        ),
        child: TextField(
            controller: _con.lastNameController,
            decoration: InputDecoration(
                hintText: 'Apellido',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color:MyColors.primaryColorDark
                ),
                prefixIcon: Icon(
                    Icons.person_outline,
                    color:MyColors.primaryColors
                )
            )
        ),
      );
    }
    Widget _textFieldPhone(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)
        ),
        child: TextField(
            controller: _con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: 'Telefono',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color:MyColors.primaryColorDark
                ),
                prefixIcon: Icon(
                    Icons.phone,
                    color:MyColors.primaryColors
                )
            )
        ),
      );
    }


    Widget _iconBack(){
      return IconButton(
        onPressed: _con.back,
        icon: Icon(Icons.arrow_back_ios,color: Colors.white),


      );
    }

    Widget _imageUser(){
      return GestureDetector(
        onTap: _con.showAlertDialog,
        child: CircleAvatar(
          backgroundImage: _con.imageFile != null
              ? FileImage(_con.imageFile)
              : _con.user?.image != null
                ? NetworkImage(_con.user?.image)
                : AssetImage('assets/img/user_profile_2.png'),
          radius: 60,
          backgroundColor: Colors.grey[100],
        ),
      );
    }

    Widget _textRegister(){
      return Text(
        'LOGIN',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      );
    }

    Widget _buttonLogin(){
      return  Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: ElevatedButton(
          onPressed:_con.isEnable ? _con.update: null,
          child:Text('Actualizar perfil'),
          style: ElevatedButton.styleFrom(
              primary: MyColors.primaryColors,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
        ),
      );
    }



    void refresh(){
      setState(() {

      });
    }
}


