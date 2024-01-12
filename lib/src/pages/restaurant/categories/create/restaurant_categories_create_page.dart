import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';

import '../../../../utils/main_colors.dart';

class RestaurantCategoriesCreatePage  extends StatefulWidget {
  const RestaurantCategoriesCreatePage ({Key key}) : super(key: key);

  @override
  _RestaurantCategoriesCreatePageState createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {

  RestaurantCategoriesController _con = new RestaurantCategoriesController();

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
        title: Text('Nueva categoria'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          _textFieldNameCategory(),
          _textFieldDescriptionCategory()
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );


  }
  Widget _textFieldNameCategory(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Nombre Categoria',
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
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
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
              hintText: 'Descripcion de la categoria',
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

  Widget _buttonCreate(){
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed:_con.createCategory,
        child:Text('Crear Categoria'),
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



