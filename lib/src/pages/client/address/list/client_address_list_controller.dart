import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/address.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/address_provaider.dart';
import 'package:flutter_delivery/src/provider/orders_provaider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;
  List<Adress> address = [];
  List<Product> selectedProducts = [];
  AddressProvaider _addressProvaider = new AddressProvaider();
  Adress a;
  User user;
  SharedPref _sharedPref = new SharedPref();
  int radioValue = 0;
  bool isCreated = false;
  OrdersProvaider _ordersProvaider = new OrdersProvaider();
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    a = Adress.fromJson(await _sharedPref.read('address'));

    print('Address init ${json.encode(a.toJson())}');
   
    _addressProvaider.init(context, user);
    _ordersProvaider.init(context, user);
    refresh();
  }

  void createOrder() async {
    try {
      Adress a = Adress.fromJson(await _sharedPref.read('address') ?? {});

      selectedProducts =
          Product.fromJsonList(await _sharedPref.read('order')).toList;

      Order order = new Order(
          idClient: user.id, idAddress: a.id, products: selectedProducts);
      ResponseApi responseApi = await _ordersProvaider.create(order);
     
      if (responseApi.success) {
        MySnackbar.show(context, responseApi.message);
      }
    } catch (e) {
      print('Ha ocurrido un error $e');
    }
  }

  Future<List<Adress>> getAdress() async {
    if (user == null) {
      return [];
    }
  
    address = await _addressProvaider.getByUser(user?.id);
    Adress _adress =
        new Adress.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == _adress.id);

    if (index != -1) {
      radioValue = index;
    }
    address = await _addressProvaider.getByUser(user.id);
    return address;
  }

  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPref.save('address', address[value]);
    refresh();
  }

  void goToAdress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');
    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }
}
