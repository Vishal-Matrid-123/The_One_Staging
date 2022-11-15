import 'package:flutter/material.dart';
import 'package:untitled2/PojoClass/itemGridModel.dart';

// ignore: non_constant_identifier_names
Widget GridWidget(List<GridPojo> mList) {
  return Expanded(
    child: GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(mList.length, (index) => itemBuild(index, mList)),
    ),
  );
}

itemBuild(int index, List<GridPojo> mList) {
  return Container(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          mList[index].image,
          height: 150,
          width: 180,
          scale: 1.0,
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
  ));
}
