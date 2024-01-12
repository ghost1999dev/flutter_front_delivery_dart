import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/api/enviroment.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import '../Models/address.dart';
import 'package:http/http.dart' as http;
class OrdersProvaider{
  String _url= Enviroment.API_DELIVERY;
  String _api= '/api/orders';
  BuildContext context;
  User sessionUser;
  SharedPref sharedPref;
  Future init(BuildContext context,User sessionUser){
    this.context = context;
    this.sessionUser=sessionUser;
  }

  /*
  * CREAR UN NUEVA DIRECCION
  * */
  Future<ResponseApi> create(Order order) async{
    try{
      Uri url=Uri.http(_url, '$_api/create');
      String bodyParams=json.encode(order);
      Map<String,String> headers={
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken
      };
      final res=await http.post(
        url,
        headers:headers,
        body:bodyParams
      );

      if(res.statusCode==401){
        MySnackbar.show(context, "Session expirada");
        new SharedPref().logout(context, sessionUser.id);
      }

      final data= json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }catch(e){
      print('Error: $e');
      return null;

    }
  }


}