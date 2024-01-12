import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/api/enviroment.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

import '../Models/response_api.dart';

class UsersProvider{

  String _url = Enviroment.API_DELIVERY;
  String _api = '/api/users';

  BuildContext context;
  User sesionUser;


  Future init(BuildContext context,{User sessionUser}){
    this.context = context;
    this.sesionUser = sessionUser;
  }

  //CONSUMIR LA API EN FLUTTER

  //GUARDAR REGISTRO CON IMAGEN
  Future<Stream> createWithImage(User user, File image) async {
    try{
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST',url);
      if(image !=null){
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send();//ENVIA LA PETICION
      return response.stream.transform(utf8.decoder);


    } catch(e){
      print('Error: $e');
      return null;

    }

  }

  //ACTUALIZAR INFORMACION DEL USUARIO
  Future<Stream> update(User user, File image) async {
    try{
      Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT',url);
      request.headers['Authorization']=sesionUser.sessionToken;
      if(image !=null){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send();
      //print('status ${response.statusCode}');//ENVIA LA PETICION
      if(response.statusCode == 401){
        MySnackbar.show(context, 'Tu sesion expiro');
        new SharedPref().logout(context,sesionUser.id);
      }


      return response.stream.transform(utf8.decoder);


    } catch(e){
      print('Error: $e');
      return null;

    }

  }

  //METODO PARA TRAER DATOS DEL USUARIO POR ID

  Future<User> getById(String id)async{
    try{
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers={
        'Content-type': 'application/json',
        HttpHeaders.authorizationHeader:sesionUser.sessionToken
        //HttpHeaders.authorizationHeader:"Bearer $token"
      };

      final res = await http.get(url,headers: headers);

      //print('Status ${res.statusCode}');
      if(res.statusCode == 401){ //NO AUTORIZADO

        MySnackbar.show(context, 'Tu sesion expiro');
        new SharedPref().logout(context,sesionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    }catch(error){
        print('Error: $error');
        return null;
    }
  }

Future<ResponseApi> create(User user) async{
    try{
      Uri url= Uri.http(_url, '$_api/create');
      String bodyParams=json.encode(user);
      Map<String, String> headers={
        'Content-type': 'application/json',
      };

      final res = await http.post(url,headers: headers, body:bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi= ResponseApi.fromJson(data);
      return responseApi;

    }catch(error){

      print('Error: $error');
      return null;

    }
}


//CERRAR SESION
  Future<ResponseApi> logout(String idUser) async{
    try{
      Uri url= Uri.http(_url, '$_api/logout');
      String bodyParams=json.encode({
        'id': idUser
      });
      Map<String, String> headers={
        'Content-type': 'application/json',
      };

      final res = await http.post(url,headers: headers, body:bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi= ResponseApi.fromJson(data);
      return responseApi;

    }catch(error){

      print('Error: $error');
      return null;

    }
  }
//API LOGIN

Future<ResponseApi> login(String email,String password) async{
  try{
    Uri url= Uri.http(_url, '$_api/login');
    String bodyParams=json.encode({
      'email': email,
      'password': password
    });
    Map<String, String> headers={
      'Content-type': 'application/json',
    };

    final res = await http.post(url,headers: headers, body:bodyParams);
    final data = json.decode(res.body);
    ResponseApi responseApi= ResponseApi.fromJson(data);
    print('Respuesta object: ${responseApi}');
    print('Respuesta: ${responseApi.toJson()}');
    return responseApi;
  }catch(error){

    print('Error: $error');
    return null;

  }
}






}