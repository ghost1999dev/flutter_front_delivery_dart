import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';

import '../../../../Models/user.dart';class RestaurantOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  List<String> categories =['PAGADO','DESPACHADO','EN CAMINO','ENTREGADO'];
  Function refresh;
  User user;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  logout() {
   // Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    _sharedPref.logout(context,user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToCategoryCreate(){
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }
  void goToProductCreate(){
    Navigator.pushNamed(context, 'restaurant/products/create');
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}