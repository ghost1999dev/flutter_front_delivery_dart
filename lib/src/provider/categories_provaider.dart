
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/api/enviroment.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;


import '../Models/response_api.dart';
import '../Models/user.dart';
import '../Models/category.dart';

class CategoriesProvaider {

  String _url = Enviroment.API_DELIVERY;
  String _api = '/api/categories';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser){
    this.context=context;
    this.sessionUser= sessionUser;
  }

  Future<List<Category>> getAll() async {
    try{

      Uri url = Uri.http(_url, '$_api/getAll');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res= await http.get( url,headers: headers);
      if(res.statusCode == 401){
        MySnackbar.show(context, 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Category category = Category.fromJsonList(data);
      return category.toList;
      
    }catch(e){
      print('Error: $e ');
      return [];
      
    }
        
  }
  Future<ResponseApi> create(Category category) async{
    try{
      Uri url= Uri.http(_url, '$_api/create');
      String bodyParams= json.encode(category);
      Map<String, String> headers={
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      
      final res = await http.post(url, headers: headers, body: bodyParams);

      if(res.statusCode==401){
        MySnackbar.show(context, 'La sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);

      ResponseApi responseApi= ResponseApi.fromJson(data);
      return responseApi;
    }catch(error){

      print('Error $error');

    }
  }

}