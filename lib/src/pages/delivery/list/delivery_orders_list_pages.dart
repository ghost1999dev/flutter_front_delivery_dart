import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/Models/order.dart';
import 'package:flutter_delivery/src/pages/delivery/list/delivey_orders_list_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';



class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({Key key}) : super(key: key);

  @override
  State<DeliveryOrderListPage> createState() => _DeliveryOrderListPage();
}

class _DeliveryOrderListPage extends State<DeliveryOrderListPage> {
  DeliveryOrderListController _con = new DeliveryOrderListController();

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
    return DefaultTabController(
      length: _con.status?.length,
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
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                    child: Text(_con.status[index] ?? ''),
                  );
                }),
              ),
            ),
          ),

          //TABBAR VIEW DE LAS TARJETAS DE LAS CATEGORIAS
          drawer: _drawer(),
          body: TabBarView(
            children: _con.status.map((String status) {
              return FutureBuilder(
                  future: _con?.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOrder(snapshot.data[index]);
                            });
                      } else {
                        return NoDataWidget(text: 'No hay ordenes');
                      }
                    } else {
                      return NoDataWidget(text: 'No hay ordenes');
                    }
                  });
            }).toList(),
          )),
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order);
      },
      child: Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 30,
                decoration: BoxDecoration(
                    color: MyColors.primaryColors,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Orden #${order.id}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'NimbusSans'),
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Pedido: 2024-05-23',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Entregar en : ${order?.address.address}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //CABECERA
          DrawerHeader(
              decoration: BoxDecoration(color: MyColors.primaryColors),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.phone ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontStyle: FontStyle.italic),
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
              )),
         
          
          ListTile(
              title: Text('Editar perfil'),
              trailing: Icon(Icons.edit_outlined)),
          ListTile(
              title: Text('Mis pedidos'),
              trailing: Icon(Icons.shopping_cart_outlined)),
         
          ListTile(
              onTap: _con.logout,
              title: Text('Cerrar sesion'),
              trailing: Icon(Icons.power_settings_new)),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

