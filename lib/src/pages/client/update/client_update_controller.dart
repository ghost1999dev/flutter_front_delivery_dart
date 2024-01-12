
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/users_provider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class ClientUpdateController{
  BuildContext context;


  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;

  bool isEnable=true;
  User user;
  SharedPref _sharedPref = new SharedPref();


  Future init(BuildContext context,Function refresh)async{
    this.context=context;

    this.refresh=refresh;


    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    print('TOKEN ENVIADO: ${user.sessionToken}');
    usersProvider.init(context, sessionUser: user);

    nameController.text=user.name;
    lastNameController.text=user.lastname;
    phoneController.text=user.phone;
    refresh();
  }


  /*
  Metodo capturar datos
   */

  void update() async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    //VALIDACIONES CAMPOS DE REGISTROS

    if( name.isEmpty || lastName.isEmpty || phone.isEmpty){

      MySnackbar.show(context, 'Debes ingresar todos los campos');

      return;
    }

    /*if(imageFile == null){
      MySnackbar.show(context, 'Selecciona una imagen');
      return;
    }*/

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable=false;


    User myUser = new User(
        id:user.id,
        name: name,
        lastname: lastName,
        phone: phone,
        image: user.image
    );

    Stream stream = await usersProvider.update(myUser, imageFile);

    stream.listen((res) async {
      _progressDialog.close();
      //print('OBJETO RECIBIDO: ${res.toString()}');
      //ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      //print('RESPUESTA: ${responseApi.toJson()}');

      MySnackbar.show(context, responseApi.message);

      if(responseApi.success){
        user = await usersProvider.getById(myUser.id); //OBTENER USUARIO POR ID DE LA BASE DE DATOS
        print('Usuario obtenido: ${user.toJson()}');
        _sharedPref.save('user', user.toJson());
        Future.delayed(Duration(seconds: 3),(){
          Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
        });
      }else{
        isEnable=true;
      }


    });
  }

  Future selectImage(ImageSource imageSource)async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile !=null){
      imageFile = File(pickedFile.path);
    }
    //CIERRA EL ALERT DIALOG
    //REFRESCA LA PANTALLA
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery);
        },
        child: Text('Galeria')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera);
        },
        child: Text('Camara')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }

  void back(){
    Navigator.pop(context);
  }

}