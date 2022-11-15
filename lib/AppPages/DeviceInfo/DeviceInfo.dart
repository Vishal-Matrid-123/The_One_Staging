import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DeviceInformation extends StatefulWidget {
  const DeviceInformation({Key? key}) : super(key: key);

  @override
  _DeviceInformationState createState() => _DeviceInformationState();
}

class _DeviceInformationState extends State<DeviceInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Width of the device :=>' +
                  '${MediaQuery.of(context).size.width}'),
              Text('Height of the device :=>' +
                  '${MediaQuery.of(context).size.height}'),
              Text('Aspect Ratio of the device :=>' +
                  '${MediaQuery.of(context).size.aspectRatio}'),
            ],
          ),
        ),
      ),
    );
  }
}
