import 'package:flutter/material.dart';
import 'package:untitled2/main.dart';

import '../../Constants/ConstantVariables.dart';

class ErrorClass extends StatelessWidget {
  const ErrorClass({Key? key, required String data})
      : _data = data,
        super(key: key);
  final String _data;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
          toolbarHeight: _width * 0.18,
          centerTitle: true,
          title: Image.asset(
            'MyAssets/logo.png',
            width: _width * 0.15,
            height: _width * 0.15,
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: _width * 0.05,
                ),
                const CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage(
                    'MyAssets/cry_emoji.gif',
                  ),
                ),
                SizedBox(
                  height: _width * 0.05,
                ),
                Text(_data +
                    "\nMay be operation is complete.\nTry to restart the app."),
                SizedBox(
                  height: _width * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ConstantsVar.appColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () => RestartWidget.restartApp(context),
                    child: const Text(
                      "Restart App",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // AppButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
