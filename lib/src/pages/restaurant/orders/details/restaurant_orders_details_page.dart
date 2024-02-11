import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/details/restaurant_orders_details_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:flutter_delivery/src/utils/relative_time_util.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';

import '../../../../Models/order.dart';

class RestaurantOrdersDetailsPage extends StatefulWidget {
  Order order;
  RestaurantOrdersDetailsPage({Key key, @required this.order})
      : super(key: key);

  @override
  State<RestaurantOrdersDetailsPage> createState() =>
      _RestaurantOrdersDetailsPageState();
}

class _RestaurantOrdersDetailsPageState
    extends State<RestaurantOrdersDetailsPage> {
  /*
  *
  * CREAR INSTANCIA DEL CONTROLADOR
  * */

  RestaurantOrdersDetailsController _con =
      new RestaurantOrdersDetailsController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ORDEN ${_con.order?.id ?? ''}'),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 15, right: 15),
              child: Text(
                'Total: ${_con.total}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30, //MARGEN EN LA PARTE DERECHA
                  indent: 30, //MARGEN EN LA PARTE IZQUIERDA
                ),
                _textDescription(),
                _dropDown(_con.users),

                _textData('Cliente',
                    '${_con.order?.client?.name ?? ''} ${_con.order?.client?.lastname}'),

                _textData(
                    'Entregar en', '${_con.order?.address?.address ?? ''}'),

                _textData('Fecha de pedido',
                    '${RelativeTimeUtil.getRelativeTime(_con?.order?.timestamp ?? 0)}'),

                //_textTotalPrice(),
                _buttonNext(),
              ],
            ),
          ),
        ),
        body: _con.order?.products?.isNotEmpty == true
            ? ListView(
                children: _con.order.products.map((Product product) {
                  return _cardProduct(product);
                }).toList(),
              )
            : NoDataWidget(
                text: 'No hay ningun producto agregado',
              ));
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Asignar repartidor',
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: MyColors.primaryColors,
            fontSize: 16),
      ),
    );
  }

  Widget _textData(String title, String content) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            content,
            maxLines: 2,
          ),
        ));
  }

  Widget _dropDown(List<User> users) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
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
                  hint: Text('Repartidores',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  items: _dropDownItems(users),
                  value: _con.idDelivery,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor seleccionado ${option}');
                      _con.idDelivery =
                          option; //ESTAMOS ESTABLECIENDO EL VALOR SELECCIONADO
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

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users?.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 40,
              width: 40,
              child: FadeInImage(
                //VALIDAR SI NO TIENE IMAGEN EL PRODUCTO POR CATEGORIA
                image: user.image != null
                    ? NetworkImage(user.image)
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 5),
            Text(user.name)
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          /*IMAGE PRODUCT */
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product?.description ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Cantidad: ${product.quantity}',
                  style: TextStyle(fontSize: 13)),
              SizedBox(height: 10),

              /*AGREGAR O REMOVER EL PRODUCTO*/
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.5)),
            color: Colors.grey),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.contain,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ));
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Text(
            'Total:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(),
          Text(
            '${_con.total}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColors,
            //EXPANDIR LA ALTURA DEL BOTOM
            padding: EdgeInsets.symmetric(vertical: 5),

            //BORDES REDONDEADOS DEL BOTOM
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'DESPACHAR ORDEN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 4),
                height: 30,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
