import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/provider/users_provider.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../Models/user.dart';

class RestaurantOrdersDetailsController {
  BuildContext context;
  Function refresh;
  Product product;
  SharedPref _sharedPref = new SharedPref();
  double total = 0;
  Order order;
  User user;
  String idDelivery;
  UsersProvider _usersProvider = new UsersProvider();
  List<Product> selectedProducts = [];
  List<User> users = [];
  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context,sessionUser: user);
    print('USUARIO REPARTIDOR ${user.toJson()}');
    if (order.products != null) {
      getTotal();
      getUsers();
      refresh();
    } else {
      print('Tiene elementos');
    }
    //sharedPref.remove('order');
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();

    print('USUARIOS REPARTIDORES ${json.encode(users)}');
    refresh();
  }

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });
    refresh();
  }
}
