import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientProductsDetailController{

  BuildContext context;
  Function refresh;

Product product;
int counter=1;
double productPrice;
SharedPref sharedPref= new SharedPref();

List<Product>selectedProducts=[];
  Future init(BuildContext context, Function refresh,Product product)async{
     this.context=context;
     this.refresh=refresh;
     this.product=product;
     productPrice=product.price;
     selectedProducts=Product.fromJsonList( await sharedPref.read('order')).toList;
     
     selectedProducts.forEach((element) { 
       print('Producto seleccionado: ${element.toJson()}');
     });

     //sharedPref.remove('order');
     refresh();
  }


  //AUMENTANDO ORDEN DE COMPRA A LOS BOTONES

  void addItem(){
    counter=counter+1;
    productPrice=product.price * counter;
    product.quantity= counter;
    refresh();
  }

  //RESTANDO ORDEN DE COMPRA A LOS BOTON

  void removeItem(){
      if(counter >1){
        counter=counter-1;
        productPrice=product.price * counter;
        product.quantity= counter;
        refresh();

      }
  }

  void addToBag(){
    int index = selectedProducts.indexWhere((element) => element.id == product.id);

    if(index == -1){
      if(product.quantity == null){
        product.quantity=1;
      }

      selectedProducts.add(product);
    }else{
      //ABRIMOS EL ARREGLO Y LO MUTAMOS
      //SOLO AUMENTARA EL QUANTITY
      selectedProducts[index].quantity=counter;
    }
    sharedPref.save('order', selectedProducts);
    Fluttertoast.showToast(msg: 'Producto agregado con exito');


  }


  //METODO PARA CERRAR LA PANTALLA

 void close(){
    Navigator.pop(context);
 }
}