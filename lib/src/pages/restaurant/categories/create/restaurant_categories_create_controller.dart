
import 'package:flutter/material.dart';

import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/categories_provaider.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';

import '../../../../Models/category.dart';
import '../../../../utils/my_snackbar.dart';

class RestaurantCategoriesController{

  BuildContext context;
  Function refresh;


  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController= new TextEditingController();
  CategoriesProvaider _categoriesProvaider = new CategoriesProvaider();
  User user;
  SharedPref sharedPref = new SharedPref();
  List<Category> categories = [];


  Future init(BuildContext context, Function refresh) async{
    this.context= context;
    this.refresh= refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvaider.init(context, user);


  }



  void createCategory() async{
    String name= nameController.text;
    String description = descriptionController.text;

    if(name.isEmpty || description.isEmpty){
      MySnackbar.show(context,'Debe ingresar los campos');
      return;
    }
    Category category = new Category(
      name: name,
      description: description
    );
    ResponseApi responseApi = await _categoriesProvaider.create(category);
    print('Datos enviados ${responseApi.toJson()}');
    MySnackbar.show(context, responseApi.message);
    if(responseApi.success){
      nameController.text='';
      descriptionController.text='';
    }

  }
}