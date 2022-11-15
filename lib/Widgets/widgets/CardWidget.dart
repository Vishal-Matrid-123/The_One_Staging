import 'package:flutter/material.dart';
// import 'package:the_one/PojoClass/itemGridModel.dart';
import 'package:untitled2/PojoClass/itemGridModel.dart';

// ignore: non_constant_identifier_names
Widget CardWidget(List<GridPojo> mList, int index) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Image.network(
            mList[index].image,
            scale: 1.0,
          ),
        ),
        Text(
          mList[index].name,
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        Text(
          mList[index].priceRang,
          style: TextStyle(
            fontSize: 8.0,
            color: Colors.greenAccent,
          ),
        ),
      ],
    ),
  );
}
