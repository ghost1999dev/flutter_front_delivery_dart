import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/list/delivey_orders_list_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';

class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({Key key}) : super(key: key);

  @override
  State<DeliveryOrdersListPage> createState() => _DeliveryOrdersListPageState();
}



class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {
  DeliveryOrdersListController _con = new DeliveryOrdersListController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
          child: ElevatedButton(
            onPressed: _con.logout,
            child: Text('Cerrar Sesion'),
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
                  Text('Delivery:${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
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
                      image: _con.user?.image !=null ?
                      NetworkImage(_con.user?.image):
                      AssetImage('assets/img/terminator.jpg'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/terminator.jpg'),
                    ),
                  )
                ],
              )
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
  void refresh() {
    setState(() {});
  }
}

