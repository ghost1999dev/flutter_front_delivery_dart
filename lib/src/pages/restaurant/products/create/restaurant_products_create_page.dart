import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/Models/category.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';

import '../../../../utils/main_colors.dart';

class RestaurantProductsCreatePage  extends StatefulWidget {
  const RestaurantProductsCreatePage ({Key key}) : super(key: key);

  @override
  _RestaurantProductsCreatePageState createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {

  RestaurantCreateProductsController _con = new RestaurantCreateProductsController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Producto')
      ),

      body: ListView(
        children: [
          SizedBox(height: 30),
          _textFieldNameCategory(),
          _textFieldDescriptionCategory(),
          _textFieldPrice(),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardImage(_con.imageFile1, 1),
                _cardImage(_con.imageFile2, 2),
                _cardImage(_con.imageFile3, 3),
              ],
            ),
          ),
          _dropDownCategories(_con.categories)
        ],
      ),
      bottomNavigationBar: _buttonCreateProduct(),
    );


  }
  Widget _textFieldNameCategory(){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
          controller: _con.nameController,
          maxLines: 1,
          maxLength: 180,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Nombre Producto',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              suffixIcon: Icon(
                  Icons.list_alt,
                  color:MyColors.primaryColors
              )
          )
      ),
    );
  }

  Widget _textFieldDescriptionCategory(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
          controller: _con.descriptionController,
          maxLength: 255,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Descripcion del Producto',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              suffixIcon: Icon(
                  Icons.description,
                  color:MyColors.primaryColors
              )

          )
      ),
    );
  }
  Widget _textFieldPrice(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
          controller: _con.priceController,

          maxLines: 1,
          maxLength: 180,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              hintText: 'Precio',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color:MyColors.primaryColorDark
              ),
              suffixIcon: Icon(
                  Icons.monetization_on,
                  color:MyColors.primaryColors
              )
          )
      ),
    );
  }
  Widget _dropDownCategories(List<Category> categories){
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [

                     Icon(
                      Icons.search,
                      color: MyColors.primaryColors,
                     ),
                  SizedBox(width: 15),
                  Text('CategoriaS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16
                        ))

                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColors,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Seleccionar la categoria',
                  style: TextStyle(
                    color:Colors.grey,
                    fontSize: 16
                  )
                  ),
                  items: _dropDownItems(categories),
                  value: _con.idCategory,
                  onChanged: (option){
                    setState(() {
                      _con.idCategory=option; //ESTAMOS ESTABLECIENDO EL VALOR SELECCIONADO
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list= [];
    categories.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.name),
        value: element.id,
      ));

    });

    return list;
  }

  Widget _cardImage(File imageFile, int numberFile){
    return GestureDetector(
      onTap: (){
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
      ? Card(
        elevation: 3.0,
        child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.26,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      )
      :Card(
        elevation: 3.0,
        child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.26,
          child: Image(
            image: AssetImage('assets/img/add_image.png')
          ),
        ),
      ),
    );

  }

  Widget _buttonCreateProduct(){
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed:_con.createProduct,
        child:Text('Crear Producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColors,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }


  void refresh(){
    setState(() {

    });
  }
}



