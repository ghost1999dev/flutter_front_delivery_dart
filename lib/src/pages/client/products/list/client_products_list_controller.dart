
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/pages/client/products/details/client_products_detail_page.dart';
import 'package:flutter_delivery/src/provider/categories_provaider.dart';
import 'package:flutter_delivery/src/Models/category.dart';
import 'package:flutter_delivery/src/provider/products_provaiders.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';class ClienteProductsListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  CategoriesProvaider _categoriesProvaider= new CategoriesProvaider();
  List<Category> categories= [];

  ProductsProvaider _productsProvaider = new ProductsProvaider();


  Future init(BuildContext context, Function refresh) async {
    this.context=context;
    this.refresh=refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvaider.init(context, user);
    _productsProvaider.init(context, user);
    getCategories();
    refresh();
  }

  void openBottomSheet(Product product){
    showModalBottomSheet(
        context: context,
        builder:(context)=> ClientProductsDetailsPage(product: product)
    );
  }

  //OBTIENE LA LISTA POR CATEGORIAS DE PRODUCTOS

  Future <List<Product>> getProduct(String idCategory) async{
    return await _productsProvaider.getByCategory(idCategory);

  }



  void getCategories() async{
    categories = await _categoriesProvaider.getAll();
    refresh();
  }


  logout(){
    _sharedPref.logout(context,user.id);

  }

  void openDrawer() {
    key.currentState.openDrawer();

  }
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context, 'client/update');
  }

  void gotToOrderCreatePage(){
    Navigator.pushNamed(context, 'client/orders/create');
  }
}