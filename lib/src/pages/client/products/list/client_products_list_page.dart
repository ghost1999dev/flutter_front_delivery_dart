import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/Models/category.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';

class ClientProductsListPage  extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  State<ClientProductsListPage> createState() => _State();
}

class _State extends State<ClientProductsListPage> {
  ClienteProductsListController _con= new ClienteProductsListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,

            actions:[
              _shopingBag()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 60),
                  _menuDrawer(),
                SizedBox(height: 20),
                  _textFieldSearch()
              ],

            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColors,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index){
                return Tab(
                  child: Text(_con.categories[index].name ?? ''),
                );
              }),

            ),
          ),
        ),



        //TABBAR VIEW DE LAS TARJETAS DE LAS CATEGORIAS
        drawer: _drawer(),
        body: TabBarView(
          children: _con.categories.map((Category category ){
            return FutureBuilder(
              future: _con.getProduct(category.id),
                builder: (context, AsyncSnapshot<List<Product>> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.length>0){
                    return GridView.builder(
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                          //numero de columnas
                            crossAxisCount:2,

                            //elevation
                            childAspectRatio:0.6
                        ),
                        itemCount: snapshot.data?.length ??0,
                        itemBuilder:(_, index){
                          return _cardProduct(snapshot.data[index]);

                        }
                    );

                  }else{
                    return NoDataWidget(text: 'No hay productos');
                  }
                }
                else{
                  return NoDataWidget(text: 'No hay productos');

                }


                }
            );
          }).toList(),
        )
      ),
    );
  }



  Widget _cardProduct(Product product){
    //CREAR TARJETA DE PRODUCTOS
    //CONTAINER

    return GestureDetector(

      onTap: (){
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250,
        child: Card(
          
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                top: -1.0,
                  right: -1.0,
                  child: Container(

                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MyColors.primaryColors,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  )
                ),
                    child: Icon(Icons.add, color: Colors.white),
              )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 150,
                  width: MediaQuery.of(context).size.width*0.45,
                  padding: EdgeInsets.all(20),
                  child: FadeInImage(

                    //VALIDAR SI NO TIENE IMAGEN EL PRODUCTO POR CATEGORIA
                    image:product.image1 !=null
                      ? NetworkImage(product.image1)
                      :AssetImage('assets/img/pizza2.png'),
                    fit:BoxFit.contain ,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 33,
                  child: Text(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'NimbusSans'
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,
                    vertical: 40),
                  child: Text(
                      '${product.price ?? ''}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold, fontFamily: 'NimbusSans'
                      )
                  ),
                )
              ],
              )
            ],
          ),
        ),
      ),
    );
  }



  Widget _shopingBag(){
    return GestureDetector(
      onTap: _con.gotToOrderCreatePage,
      child: Stack(
        children: [
          Container(
            margin:EdgeInsets.only(right: 15,top: 15),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
          Positioned(
              right: 16,
              top: 16,
              child: Container(

              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(30))
              )
            )
          )
        ],
      ),
    );
  }

  Widget _textFieldSearch(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
              Icons.search,
              color: Colors.grey[400]
          ),
            hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500]
        ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey[300]
            )
          ),
          focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Colors.grey[300]
              )
          ),
          contentPadding: EdgeInsets.all(15)
        ),
      ),
    );
  }
  Widget _menuDrawer(){

    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png',width: 20, height: 20),
      ),
    );

  }

  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          //CABECERA
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColors
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                    maxLines: 1,
                ),
                  Text('${_con.user?.email ?? ''}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text('${_con.user?.phone ?? ''}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),

                  Container(

                    height: 60,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _con.user?.image !=null
                          ? NetworkImage(_con.user?.image)
                          :  AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ],
              )
          ),
          ListTile(
            onTap: _con.goToUpdatePage,
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit_outlined)
          ),
          ListTile(
              title: Text('Mis pedidos'),
              trailing: Icon(Icons.shopping_cart_outlined)
          ),
          _con.user !=null ?
          _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
              title: Text('Seleccionar rol'),
              trailing: Icon(Icons.person_outline)
          ): Container() : Container(),
          ListTile(
            onTap: _con.logout,
              title: Text('Cerrar sesion'),
              trailing: Icon(Icons.power_settings_new)
          ),
        ],
      ),
    );
  }
  void refresh() {
    setState(() {});
  }
}
