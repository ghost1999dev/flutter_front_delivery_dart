
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/product.dart';

import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/provider/categories_provaider.dart';
import 'package:flutter_delivery/src/provider/products_provaiders.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../../../../Models/category.dart';
import '../../../../utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RestaurantCreateProductsController{

  BuildContext context;
  Function refresh;


  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController= new TextEditingController();
  //TextEditingController priceController = new TextEditingController();
  MoneyMaskedTextController priceController = new MoneyMaskedTextController();
  CategoriesProvaider _categoriesProvaider = new CategoriesProvaider();
  ProductsProvaider _productsProvaider = new ProductsProvaider();

  User user;
  List<Category> categories=[];
  String idCategory; //ALMACENAR EL ID DE LA CATEGORIA SELECCIONADA
  SharedPref sharedPref = new SharedPref();
  //CategoriesProvaider _categoriesProvaider = new CategoriesProvaider();

  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;
  ProgressDialog _progressDialog;


  Future init(BuildContext context, Function refresh) async{
    this.context= context;
    this.refresh= refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvaider.init(context, user);
    _productsProvaider.init(context, user);
    _progressDialog= new ProgressDialog(context: context);
    getCategories();

  }
  void getCategories() async {
    categories = await _categoriesProvaider.getAll();
    refresh();
  }

  void createProduct() async{
    String name= nameController.text;
    String description = descriptionController.text;
    double price = priceController.numberValue;

    if(name.isEmpty || description.isEmpty || price ==0){
      MySnackbar.show(context,'Debe ingresar los campos');
      return;
    }

    if(imageFile1 == null || imageFile2 == null || imageFile3 == null){
      MySnackbar.show(context,'Selecciona las tres imagenes');
      return;
    }

    if(idCategory == null){
      MySnackbar.show(context,'Debe seleccionar la categoria del producto');
      return;
    }
    Product product = new Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.parse(idCategory)
    );

    List<File> images=[];
    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);
    Stream stream = await _productsProvaider.create(product, images);
    stream.listen((res) {
      _progressDialog.close();
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);
      if(responseApi.success){
        resetValues();
      }

    });

    print('Formularios Producto ${product.toJson()}');


  }

  void resetValues(){
    nameController.text='';
    descriptionController.text='';
    priceController.text='0.0';
    imageFile1=null;
    imageFile2=null;
    imageFile3=null;
    idCategory=null;
    refresh();

  }


  Future selectImage(ImageSource imageSource, int numberFile)async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile !=null){
      if(numberFile==1){
      imageFile1=File(pickedFile.path);
      }else if(numberFile==2){
        imageFile2= File(pickedFile.path);


      }else if(numberFile == 3){
        imageFile3 = File(pickedFile.path);
      }

    }

    //CIERRA EL ALERT DIALOG
    //REFRESCA LA PANTALLA
    Navigator.pop(context);
    refresh();


  }

  void showAlertDialog(int numberFile){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('Galeria')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('Camara')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }
}