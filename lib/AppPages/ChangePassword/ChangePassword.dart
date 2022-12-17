import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
// import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with InputValidationMixin {
  FocusNode myFocusNode = FocusNode();

  GlobalKey<FormState> myGlobalKey = GlobalKey<FormState>();

  TextEditingController pController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController oldpController = TextEditingController();

  bool passError = true;

  bool cpError = true;

  bool oldpassError = true;

  dynamic _apiToken;

  dynamic _customerId;

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();

    setState(() {
      _customerId = ConstantsVar.prefs.getString('userId');
      _apiToken = ConstantsVar.prefs.getString('apiTokken');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        // backgroundColor: Page.background,
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(
                    pageIndex: 0,
                  ),
                ),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 18.w,
        ),

        body: GestureDetector(
          // close keyboard on outside input tap
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },

          child: Builder(
            builder: (context) => Form(
              key: myGlobalKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: <Widget>[
                        // header text
                        Center(
                          child: AutoSizeText(
                            'Reset Password'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 6.5.w,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //Old password input
                        Padding(
                          padding: const EdgeInsets.only(top: 48.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                validator: (password) {
                                  if (oldPassword(password!)) {
                                    return null;
                                  } else {
                                    return 'Please enter your password';
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: oldpassError,
                                controller: oldpController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: InputDecoration(
                                    suffix: ClipOval(
                                      child: RoundCheckBox(
                                        uncheckedColor: Colors.white,
                                        checkedColor: Colors.white,
                                        size: 20,
                                        onTap: (selected) {
                                          setState(() {
                                            log('Tera kaam  bngya');
                                            oldpassError
                                                ? oldpassError = selected!
                                                : oldpassError = selected!;
                                          });
                                        },
                                        isChecked: oldpassError,
                                        checkedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16,
                                          ),
                                        ),
                                        uncheckedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: ConstantsVar.appColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.password_rounded,
                                      color: ConstantsVar.appColor,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'Old Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),

                        //New password input
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                validator: (password) {
                                  if (isPasswordValid(password!)) {
                                    return 'Minimum 6 Characters. ';
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: passError,
                                controller: pController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: InputDecoration(
                                    suffix: ClipOval(
                                      child: RoundCheckBox(
                                        uncheckedColor: Colors.white,
                                        checkedColor: Colors.white,
                                        size: 20,
                                        onTap: (selected) {
                                          setState(() {
                                            log('Tera kaam  bngya');
                                            passError
                                                ? passError = selected!
                                                : passError = selected!;
                                          });
                                        },
                                        isChecked: passError,
                                        checkedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16,
                                          ),
                                        ),
                                        uncheckedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: ConstantsVar.appColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.password_rounded,
                                      color: ConstantsVar.appColor,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'New Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        //Confirm password input

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                  enableInteractiveSelection: false,
                                  validator: (password) {
                                    if (isPasswordMatch(
                                      pController.text.toString(),
                                      cpController.text.toString(),
                                    )) {
                                      return null;
                                    } else {
                                      return 'Password Mismatch!';
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  obscureText: cpError,
                                  controller: cpController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: InputDecoration(
                                      suffix: ClipOval(
                                        child: RoundCheckBox(
                                          checkedColor: Colors.white,
                                          uncheckedColor: Colors.white,
                                          size: 20,
                                          onTap: (selected) {
                                            setState(() {
                                              log('Tera kaam  bngya');
                                              cpError
                                                  ? cpError = selected!
                                                  : cpError = selected!;
                                            });
                                          },
                                          isChecked: cpError,
                                          checkedWidget: const Center(
                                            child: Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 16,
                                            ),
                                          ),
                                          uncheckedWidget: const Center(
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: ConstantsVar.appColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.password_rounded,
                                        color: ConstantsVar.appColor,
                                      ),
                                      labelStyle: TextStyle(
                                          fontSize: 5.w, color: Colors.grey),
                                      labelText: 'Confirm Password',
                                      border: InputBorder.none)),
                            ),
                          ),
                        ),
                        // submit button

                        // sign up button
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: ConstantsVar.appColor,
                      width: 100.w,
                      height: 50,
                      child: LoadingButton(
                        color: ConstantsVar.appColor,
                        defaultWidget: SizedBox(
                          width: 100.w,
                          child: Center(
                            child: AutoSizeText(
                              'Reset Password'.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        loadingWidget: const SpinKitCircle(
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          if (myGlobalKey.currentState!.validate()) {
                            myGlobalKey.currentState!.save();
                            await changePassword();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter correct password.'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    final dynamic body = {
      'apiToken': _apiToken,
      'CustomerId': _customerId,
      'data': jsonEncode(
        {
          'OldPassword': oldpController.text,
          'NewPassword': pController.text,
          'ConfirmNewPassword': cpController.text,
          'Result': null,
        },
      ),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey),
    };

    String _baseUrl = await ApiCalls.getSelectedStore();

    final uri = Uri.parse(_baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/ChangeCustomerPassword?');
    var response = await http.post(uri, body: body, headers: ApiCalls.header);

    try {
      var result = jsonDecode(response.body);
      log(response.body);

      dynamic status;
      dynamic message;
      dynamic errorMessage;
      if (response.statusCode == 200) {
        setState(() {
          status = result['Status'];
          message = result['Message'][0].toString();
        });
        if (status == kstatusFailed) {
          setState(() {
            errorMessage = result['Message'][0].toString();
          });
          showErrorDialog(errorMessage);
        } else {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: 100.w,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'MyAssets/imagebackground.jpeg',
                        ))),
                height: 25.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 4.w,
                          color: Colors.white),
                    ),
                    AppButton(
                      color: Colors.black,
                      child: SizedBox(
                        width: 30.w,
                        child: const Center(
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => clearUserDetails()
                          .whenComplete(() => Phoenix.rebirth(context)),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  InputDecoration editBoxDecoration(
      {required String name, required Icon icon, required String prefixText}) {
    return InputDecoration(
      prefixText: prefixText,
      prefixIcon: icon,
      labelStyle: TextStyle(
          fontSize: 5.w,
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,
      border: InputBorder.none,
      counterText: '',
    );
  }

  void showErrorDialog(String reason) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Changing password failed',
            text: 'Not Go'.toUpperCase(),
            img: 'MyAssets/logo.png',
            reason: reason,
          );
        });
  }

  void showSucessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const CustomDialogBox(
            descriptions: 'Registration Successfully Complete',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
  }
}
