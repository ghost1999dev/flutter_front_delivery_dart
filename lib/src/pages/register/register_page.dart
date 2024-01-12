import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/register/registerController.dart';


import '../../utils/main_colors.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = new RegisterController();

  /*
  Metodo donde recibe el contexto del objeto del controlador
   */
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
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -100,
              child: _circleRegister(),
            ),
            Positioned(
              child: _textRegister(),
              top: 65,
              left: 27,
            ),
            Positioned(
              child: _iconBack(),
              top: 50,
              left: -5,
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _imageUser(),
                    SizedBox(height: 30),
                    _textFieldEmail(),
                    _textFieldUser(),
                    _textFieldLastName(),
                    _textFieldPhone(),
                    _textFieldPassword(),
                    _textFieldConfirmPassword(),
                    _buttonLogin()
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Correo Electronico',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              prefixIcon: Icon(
                  Icons.email,
                  color:MyColors.primaryColors
              )
          )
      ),
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
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.passwordController,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              prefixIcon: Icon(
                  Icons.lock,
                  color:MyColors.primaryColors
              )
          )
      ),
    );
  }
  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Confirmar Contraseña',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              prefixIcon: Icon(
                  Icons.lock_outline,
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
        backgroundImage: _con.imageFile !=null ?
        FileImage(_con.imageFile):
        AssetImage('assets/img/user_profile_2.png'),
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
        onPressed:_con.isEnable ? _con.register: null,
        child:Text('Registrarse'),
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

  Widget _circleRegister(){
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColors
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }

}

