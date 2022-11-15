
// import 'package:custom_dialog_flutter_demo/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class CustomDialogBox extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final bool isOkay;

  // final Route route;

  const CustomDialogBox({
    Key? key,
    required this.isOkay,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:
          contentBox(context, widget.descriptions, widget.text, widget.isOkay),
    );
  }

   contentBox(BuildContext context, String descriptions, String text, bool isOkay) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 6,
              ),
              AutoSizeText(
                text.contains('Not Go') ? '' : text,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: isOkay,
                  child: TextButton(
                      style: flatButtonStyle(context: context),
                      onPressed: () {
                        text == 'Not Go' ? Navigator.pop(context) : null;
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        height: 50,
                        color: Colors.black,
                        child: Center(
                          child: const AutoSizeText(
                            'OKAY',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );

  }
   ButtonStyle flatButtonStyle({required BuildContext  context}) => TextButton.styleFrom(
    primary: ConstantsVar.appColor,
    minimumSize: Size(MediaQuery.of(context).size.width/2, 0),
    padding: EdgeInsets.symmetric(vertical: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );
}

class CustomDialogBox1 extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final String reason;

  // final Route route;

  const CustomDialogBox1({
    Key? key,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    required this.reason,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState1 createState() => _CustomDialogBoxState1();
}

class _CustomDialogBoxState1 extends State<CustomDialogBox1> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black,
                    offset: const Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                widget.reason.length == 0
                    ? widget.descriptions
                    : widget.descriptions +
                        '!' +
                        '\n' +
                        '${widget.reason + '.'}',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () async {
                      ConstantsVar.prefs =
                          await SharedPreferences.getInstance();
                      ConstantsVar.prefs.setString('regBody', '');
                      Navigator.of(context).pop();
                    },
                    child: const AutoSizeText(
                      'Okay',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );
  }
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: ConstantsVar.appColor,
    minimumSize: Size(30.w, 0),
    padding: EdgeInsets.symmetric(vertical: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );
}
