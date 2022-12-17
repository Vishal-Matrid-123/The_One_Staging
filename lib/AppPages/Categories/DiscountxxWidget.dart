import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget discountWidget(
    {required String actualPrice,
    required bool isSpace,
    required double fontSize,
    required double width}) {
  return Container(
    child: Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        !isSpace ? actualPrice : '',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
