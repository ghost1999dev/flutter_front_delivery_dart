import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';

import '../../../../utils/main_colors.dart';

class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({Key key}) : super(key: key);

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPage();
}

class _RestaurantOrdersListPage extends State<RestaurantOrdersListPage> {

  RestaurantOrdersListController _con = new RestaurantOrdersListController();

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
            preferredSize: Size.fromHeight(120),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 60),
                  _menuDrawer(),


                ],

              ),
              bottom: TabBar(
                indicatorColor: MyColors.primaryColors,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.categories.length, (index){
                  return Tab(
                    child: Text(_con.categories[index] ?? ''),
                  );
                }),

              ),
            ),
          ),



          //TABBAR VIEW DE LAS TARJETAS DE LAS CATEGORIAS
          drawer: _drawer(),
          body: TabBarView(
            children: _con.categories.map((String category ){
              return Container();
             /* return FutureBuilder(
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
              );*/
            }).toList(),
          )
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
                  Text('${_con.user?.name ?? ''} ${_con.user?.lastname ??''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                  Text(_con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text(_con.user?.phone ?? '',
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
                      image: _con.user?.image != null
                          ? NetworkImage(_con.user?.image)
                          : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ],
              )
          ),
          ListTile(
              onTap: _con.goToCategoryCreate,
              title: Text('Crear Categoria'),
              trailing: Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear Producto'),
            trailing: Icon(Icons.local_pizza),
          ),
          ListTile(
              title: Text('Editar perfil'),
              trailing: Icon(Icons.edit_outlined)
          ),
          ListTile(
              title: Text('Mis pedidos'),
              trailing: Icon(Icons.shopping_cart_outlined)
          ),
          ListTile(
              title: Text('Seleccionar rol'),
              trailing: Icon(Icons.person_outline)
          ),
          ListTile(
              onTap: _con.logout,
              title: Text('Cerrar sesion'),
              trailing: Icon(Icons.power_settings_new)
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
