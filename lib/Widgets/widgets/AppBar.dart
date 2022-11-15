import 'package:flutter/material.dart';

Widget AppBarLogo(String title, BuildContext context) {
  return Card(
    child: Container(
      color: Colors.white60,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
