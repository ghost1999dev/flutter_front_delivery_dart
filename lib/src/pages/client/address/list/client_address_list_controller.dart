import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/address.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/address_provaider.dart';
import 'package:flutter_delivery/src/provider/orders_provaider.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';

class ClientAddressListController{

  BuildContext context;
  Function refresh; 
  List<Adress> address=[];
  List<Product> selectedProducts=[];
  AddressProvaider _addressProvaider = new AddressProvaider();
  User user;
  SharedPref _sharedPref=new SharedPref();
  int radioValue=0;
  bool isCreated =false;
  OrdersProvaider _ordersProvaider = new OrdersProvaider();
  Future init(BuildContext context,Function refresh)async{
    this.context=context;
    this.refresh=refresh;
    user=User.fromJson(await _sharedPref.read('user'));
    print('Usuarios ${user.toJson()}');
    _addressProvaider.init(context, user);
    _ordersProvaider.init(context, user);
    refresh();
  }

  void createOrder()async{
    Adress a = Adress.fromJson(await _sharedPref.read('address')??{});
    selectedProducts=Product.fromJsonList(await _sharedPref.read('order')).toList;
    print('UserID ${user.id}');
    Order order = new Order(
      idClient: user.id,
      idAddress: a.id,
      products: selectedProducts
    );
    ResponseApi responseApi=await _ordersProvaider.create(order);
    print('Respuesta orden ${responseApi.message}');
  }

  Future<List<Adress>> getAdress() async{
    address = await _addressProvaider.getByUser(user.id);
    Adress _adress = new Adress.fromJson(await _sharedPref.read('address')?? {});
    int index=address.indexWhere((ad) => ad.id == _adress.id);
    print('index $index');
    if(index !=-1){
      radioValue=index;
    }
    address=await _addressProvaider.getByUser(user.id);
    return address;
  }

  void handleRadioValueChange(int value) async{
    radioValue=value;
    _sharedPref.save('address', address[value]);
    refresh();
  }
  void goToAdress() async{
   var  result = await Navigator.pushNamed(context, 'client/address/create');
   if(result != null){
     if(result){
       refresh();
     }

   }
  }
}