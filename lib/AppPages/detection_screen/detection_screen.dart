import 'package:flutter/material.dart';

class DetectionClass extends StatelessWidget {
  const DetectionClass({Key? key, required this.detectedMessage})
      : super(key: key);
  final String detectedMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(detectedMessage),
        ),
      ),
    );
  }
}
