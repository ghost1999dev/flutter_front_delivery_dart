import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/pages/delivery/detail/delivery_orders_details_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/details/restaurant_orders_details_page.dart';
import 'package:flutter_delivery/src/provider/orders_provaider.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../Models/user.dart';

class RestaurantOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  List<String> status = ['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrdersProvaider _ordersProvaider = new OrdersProvaider();
  bool isUpdated;
  Function refresh;
  User user;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvaider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvaider.getByStatus(status);
  }

  logout() {
    // Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToCategoryCreate() {
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, 'restaurant/products/create');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void openBottomSheet(Order order) async {
    try {
      isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => RestaurantOrdersDetailsPage(order: order),
      );
    
      if (!isUpdated || isUpdated == null) {
        refresh();
      }
    } catch (e) {
      print('Error ');
    }
  }
}
