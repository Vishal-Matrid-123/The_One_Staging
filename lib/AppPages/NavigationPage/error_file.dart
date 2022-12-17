import 'package:flutter/material.dart';

class errorClass extends StatelessWidget {
  const errorClass({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Text(error),
      ),
    ));
  }
}
