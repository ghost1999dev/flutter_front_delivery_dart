import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery/src/Models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/details/client_products_detail_controller.dart';
import 'package:flutter_delivery/src/utils/main_colors.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductsDetailsPage extends StatefulWidget {
  Product product;
  ClientProductsDetailsPage({Key key, @required this.product})
      : super(key: key);

  @override
  State<ClientProductsDetailsPage> createState() =>
      _ClientProductsDetailsPageState();
}

class _ClientProductsDetailsPageState extends State<ClientProductsDetailsPage> {
  ClientProductsDetailController _con = ClientProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 12,
        child: Column(
          children: [
            _imageSlideshow(),
            _textName(),
            _textDescription(),
            SizedBox(
              height: 20,
            ),
            _addOrRemoveItem(),
            _standartDelivery(),
            _buttonShopingBag()
          ],
        ));
  }

  //TEXTO QUE SALE EN EL SLIDER
  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product?.name ?? '',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  //RETORNAR UNA FILA CON LOS BOTONES + Y -
  Widget _addOrRemoveItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.grey,
                size: 30,
              )),
          Text(
            '${_con.counter}',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 30,
              )),
          Spacer(),
          Container(
            child: Text(
              '${_con.productPrice ?? 0}\$',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _standartDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Image.asset(
            'assets/img/delivery.png',
            height: 17,
          ),
          SizedBox(width: 7),
          Text(
            'Envio standar',
            style: TextStyle(fontSize: 12, color: Colors.green),
          )
        ],
      ),
    );
  }

  //DESCRIPCION QUE SALE EN EL SLIDER
  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product?.description ?? '',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  Widget _buttonShopingBag() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
      child: ElevatedButton(
        onPressed: _con.addToBag,
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
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Agregar a la bolsa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageSlideshow() {
    return Stack(children: [
      ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        initialPage: 0,
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
        children: [
          FadeInImage(
            image: _con.product?.image1 != null
                ? NetworkImage(_con.product.image1)
                : AssetImage('assets/img/pizza2.png'),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 10),
            placeholder: AssetImage('assets/img/no-image.png'),
          ),
          FadeInImage(
            image: _con.product?.image2 != null
                ? NetworkImage(_con.product.image2)
                : AssetImage('assets/img/pizza2.png'),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 10),
            placeholder: AssetImage('assets/img/no-image.png'),
          ),
          FadeInImage(
            image: _con.product?.image2 != null
                ? NetworkImage(_con.product.image2)
                : AssetImage('assets/img/no-image.png'),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 10),
            placeholder: AssetImage('assets/img/no-image.png'),
          ),
        ],
        onPageChanged: (value) {},
        autoPlayInterval: 10000,
      ),
      Positioned(
          left: 10,
          top: 5,
          child: IconButton(
            onPressed: _con.close,
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColors,
            ),
          ))
    ]);
  }

  void refresh() {
    setState(() {});
  }
}
