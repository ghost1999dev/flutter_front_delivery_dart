import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';class DeliveryOrdersListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  Future init(BuildContext context, Function refresh) async {
    this.context=context;
    this.refresh=refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  logout(){
    _sharedPref.logout(context,user.id);

  }

  void openDrawer() {
    key.currentState.openDrawer();

  }
}