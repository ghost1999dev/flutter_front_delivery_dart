
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';


import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/api/enviroment.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;


import '../Models/response_api.dart';
import '../Models/user.dart';
import '../Models/category.dart';

class ProductsProvaider {

  String _url = Enviroment.API_DELIVERY;
  String _api = '/api/products';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser){
    this.context=context;
    this.sessionUser= sessionUser;
  }

//GUARDAR REGISTRO CON IMAGEN
  Future<Stream> create(Product product, List<File> images) async {
    try{
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST',url);
      request.headers['Authorization']=sessionUser.sessionToken;
      for(int i = 0; i<images.length; i++){

          request.files.add(http.MultipartFile(
              'image',
              http.ByteStream(images[i].openRead().cast()),
              await images[i].length(),
              filename: basename(images[i].path)
          ));

      }

      request.fields['product'] = json.encode(product);
      final response = await request.send();//ENVIA LA PETICION
      return response.stream.transform(utf8.decoder);


    } catch(e){
      print('Error: $e');
      return null;

    }

  }
  
  Future<List<Product>> getByCategory(String idCategory) async{
    try{
      Uri url = Uri.http(_url,'$_api/findByCategory/$idCategory');
      
      Map<String, String> headers={
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      
      final res = await http.get(url, headers: headers);

      if(res.statusCode==401){
        MySnackbar.show(context,'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data =json.decode(res.body);

      Product product = Product.fromJsonList(data);
      return product.toList;
      
    }catch(e){
      print('Error: $e');

      return [];
      
      
    }
  }
  
  




}