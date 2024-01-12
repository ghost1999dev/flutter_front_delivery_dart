import 'package:flutter/material.dart';


class NoDataWidget extends StatelessWidget {
   NoDataWidget({Key key,this.text}) : super(key: key);
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('assets/img/no_items.png'),
          Text(text)

        ],
      ),
    );
  }
}
