import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientOrdersCreateController {
  BuildContext context;
  Function refresh;

  Product product;

  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducto = [];
  double total = 0;

  List<Product> selectedProducts = [];
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    //sharedPref.remove('order');
    getTotal();
    refresh();
  }

  void getTotal() {
    total = 0;
    selectedProducts.forEach((element) {
      total = total + (element.quantity * element.price);
    });
    refresh();
  }

  void addItem(Product product) {
    /*SELECCIONA EL PRODUCTO QUE SELECCIONE
    *
    * IGUAL A LO QUE CONTIENE EL OBJETO PRODUCTO
    * LUEGO SELECTEDPRODUCTS LE MANDAMOS EL INDEX Y SU QUANTITY SERA
    * IGUAL AL MISMO QUANTITY SUMANDOLE UNO PARA AGREGARLE EL NUEVO
    * */
    int index =
        selectedProducts.indexWhere((element) => element.id == product.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity + 1;

    getTotal();
  }

  void removeItem(Product product) {
    if (product.quantity > 1) {
      int index =
          selectedProducts.indexWhere((element) => element.id == product.id);
      selectedProducts[index].quantity = selectedProducts[index].quantity - 1;

      getTotal();
    }
  }

  void deleteItem(Product product) {
    print(product.id);
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void goToAddress() {
    Navigator.pushNamed(context, 'client/address/list');
  }
}
