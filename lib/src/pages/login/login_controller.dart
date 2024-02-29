import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/users_provider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';

class LoginController {
  //CONTROLES DE LAS CAJAS DE TEXTO
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //INSTANCIAR EL USERSPROVIFDER
  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    //CARGA EL MAPA DE VALORES DEL USER AL LOCAL STORAGE
    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    
    if (user?.sessionToken != null) {
      //Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
      if (user?.roles?.length > 1) {
        //Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      } else {
        //Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    }
  }

  void gotoRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  /*
  metodo captura los datos de las cajas de texto
  RepsonseApi devuelve un mensaje de respuesta del proceso
   */
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    ResponseApi responseApi = await usersProvider.login(email, password);
    //print('Respuesta : ${responseApi.toJson()}');
    if (responseApi?.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      print('Usuario logueado: ${user.toJson()}');
      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        //Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false);
      }
    } else {
      MySnackbar.show(context, responseApi.message);
    }
  }
}
