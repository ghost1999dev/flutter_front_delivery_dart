
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/users_provider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

//Mi primer porcion de codigo que hice para aprender Flutter
//FernandoDev

class RegisterController{
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController  confirmPasswordController = new TextEditingController();
  UsersProvider usersProvider = new UsersProvider();
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable=true;
  Future init(BuildContext context,Function refresh){
    this.context=context;
    usersProvider.init(context);
    this.refresh=refresh;
    _progressDialog = ProgressDialog(context: context);
  }
  /*
  Metodo capturar datos
   */
  void register() async {

    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String pass = passwordController.text.trim();
    String confirm = confirmPasswordController.text.trim();
    //VALIDACIONES CAMPOS DE REGISTROS
    if(email.isEmpty || name.isEmpty || lastName.isEmpty || phone.isEmpty ||
         pass.isEmpty || confirm.isEmpty ){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }
    if(confirm != pass){
      MySnackbar.show(context, 'Las contraseñas no coinciden');
      return;
    }
    if(pass.length < 6){
      MySnackbar.show(context, 'Las contraseñas debe tener al menos 6 caracteres');
      return;
    }
    if(imageFile == null){
      MySnackbar.show(context, 'Selecciona una imagen');
      return;
    }
    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable=false;
    User user = new User(
      email: email,
      name: name,
      lastname: lastName,
      phone: phone,
      password: pass
    );
    Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) {
      _progressDialog.close();
      //ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);
      if(responseApi.success){
        Future.delayed(Duration(seconds: 3),(){
          Navigator.pushReplacementNamed(context, 'login');
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