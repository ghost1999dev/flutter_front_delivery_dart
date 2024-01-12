import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/login/login_controller.dart';

import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _conn = new LoginController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

      _conn.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:Container(
        width: double.infinity,
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(10),

        child: Stack(
          children: [
            /*Positioned(
                top: -80,
                left: -100,
                child: _circleLogin(),
            ),
            Positioned(
                child: _textLogin(),
                top: 60,
            ),*/

            Column(
              children:[

                //_imageBanner(),
                _lottieAnimation(),
                _textFieldEmail(),
                _textFieldPassword(),
                _buttonLogin(),
                _textDontHaveAccount(),
          ],
        ),
        ],
        ),
      ),
      )

    );
  }
  Widget _lottieAnimation(){
    return Container(
      margin: EdgeInsets.only(
          top: 50,
          bottom: MediaQuery.of(context).size.height * 0.10
      ),
      child: Lottie.asset(
          'assets/json/delivery.json',
          width: 400,
          height: 300,
          fit: BoxFit.fill
      ),
    );
  }

  Widget _textLogin(){
    return Text(
        'LOGIN',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22
        ),
    );
  }
  Widget _circleLogin(){
    return Container(
      width: 240,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColors
      ),
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

        keyboardType: TextInputType.emailAddress ,
        controller: _conn.emailController,
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
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _conn.passwordController,
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
  Widget _buttonLogin(){
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
          onPressed: _conn.login,
          child:Text('Ingresar'),
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

  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes cuenta?',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColors
          ),
        ),
        SizedBox(width: 7,),

        //Widget que redirecciona a otra ruta
        GestureDetector(
          onTap: _conn.gotoRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColors
            ),
          ),
        ),
      ],
    );
  }

}
