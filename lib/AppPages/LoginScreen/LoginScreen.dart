// import 'package:connectivity/connectivity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/ForgotPass/ForgotPassword.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class LoginScreen extends StatefulWidget {
  final String screenKey;

  @override
  _LoginScreenState createState() => _LoginScreenState();

  const LoginScreen({Key? key, required this.screenKey}) : super(key: key);
}

class _LoginScreenState extends State<LoginScreen>
    with InputValidationMixin, WidgetsBindingObserver {
  var passController = TextEditingController();
  var emailController = TextEditingController();
  var otpController = TextEditingController();
  bool emailError = false;
  bool passError = true;

  bool connectionStatus = true;

  DateTime currentBackPressTime = DateTime.now();

  var isSuffix = true;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  double _opacity = 1.0;

  void initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initilaize();
    WidgetsBinding.instance?.addObserver(this);

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          _opacity = 0.0;
        });
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _opacity = 1.0;
        });
        break;
      case AppLifecycleState.paused:
        setState(() {
          _opacity = 0.0;
        });
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      // maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FlutterSizer(
            builder: (
              context,
              ori,
              screenType,
            ) {
              return Opacity(
                opacity: _opacity,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white10,
                  child: Form(
                    key: _loginKey,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 4.h,
                        ),
                        Center(
                          child: SizedBox(
                            height: 25.h,
                            width: 25.h,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                "MyAssets/logo.png",
                                width: 23.h,
                                height: 23.h,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Center(
                            child: AutoSizeText(
                              loginString,
                              // maxLines: 3,
                              wrapWords: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.w,
                            right: 8.w,
                          ),
                          child: SizedBox(
                            width: 100.w,
                            child: Center(
                              child: AutoSizeText(
                                "CUSTOMER LOGIN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26.dp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        addVerticalSpace(
                          3.h,
                        ),
                        AutofillGroup(
                          onDisposeAction: AutofillContextAction.commit,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 8.w,
                              right: 8.w,
                            ),
                            child: SizedBox(
                              height: 50.h,
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12.0,
                                      ),
                                    ),
                                    elevation: 8.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      width: 90.w,
                                      child: TextFormField(
                                        autofillHints: const <String>[
                                          AutofillHints.email,
                                          AutofillHints.username
                                        ],
                                        autofocus: true,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (val) {
                                          if (isEmailValid(val!)) {
                                            return null;
                                          }
                                          return 'Please enter a valid email address!';
                                        },
                                        cursorColor: ConstantsVar.appColor,
                                        controller: emailController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                        ),
                                        decoration: editBoxDecoration(
                                            'E-mail Address',
                                            const Icon(
                                              Icons.email,
                                              color:
                                                  AppColor.PrimaryAccentColor,
                                            ),
                                            false),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12.0,
                                      ),
                                    ),
                                    elevation: 8.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      width: 90.w,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              autofocus: true,

                                              autofillHints: const <String>[
                                                AutofillHints.password
                                              ],
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText: passError,

                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              // validator: (inputz) =>
                                              //     input!.isValidPass() ? null : "Check your Password",
                                              controller: passController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor:
                                                  ConstantsVar.appColor,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                              ),
                                              decoration: const InputDecoration(
                                                // suffix: ,
                                                prefixIcon: Icon(
                                                  Icons.password_rounded,
                                                  color: ConstantsVar.appColor,
                                                ),
                                                labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                labelText: 'Password',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: ClipOval(
                                              child: RoundCheckBox(
                                                borderColor: Colors.white,
                                                uncheckedColor: Colors.white,
                                                checkedColor: Colors.white,
                                                size: 20,
                                                onTap: (selected) {
                                                  setState(() {
                                                    passError
                                                        ? passError = selected!
                                                        : passError = selected!;
                                                  });
                                                },
                                                isChecked: passError,
                                                checkedWidget: const Center(
                                                  child: Icon(
                                                    Icons.visibility,
                                                    size: 20,
                                                  ),
                                                ),
                                                uncheckedWidget: const Center(
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    color:
                                                        ConstantsVar.appColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 3.h,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: IgnorePointer(
                                            ignoring: connectionStatus == true
                                                ? false
                                                : true,
                                            child: Container(
                                              height: 12.w,
                                              width: 30.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10.0,
                                                ),
                                                color: ConstantsVar.appColor,
                                                border: const Border(
                                                  top: BorderSide(
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                  bottom: BorderSide(
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                  left: BorderSide(
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                  right: BorderSide(
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: LoadingButton(
                                                  color: ConstantsVar.appColor,
                                                  loadingWidget:
                                                      const SpinKitCircle(
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  height: 12.w,
                                                  onPressed: () async {
                                                    if (_loginKey.currentState!
                                                        .validate()) {
                                                      _loginKey.currentState!
                                                          .save();
                                                      await ApiCalls.login(
                                                        context: context,
                                                        email: emailController
                                                            .text
                                                            .toString()
                                                            .trim(),
                                                        password:
                                                            passController.text,
                                                        screenName:
                                                            widget.screenKey,
                                                      ).then(
                                                        (val) {},
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter Correct Details',
                                                      );
                                                    }
                                                  },
                                                  defaultWidget:
                                                      const AutoSizeText(
                                                    "LOGIN",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 12.w,
                                            width: 30.w,
                                            margin: const EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: IgnorePointer(
                                              ignoring: connectionStatus == true
                                                  ? false
                                                  : true,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    ConstantsVar.appColor,
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: const BorderSide(
                                                        color: ConstantsVar
                                                            .appColor,
                                                      ),
                                                    ),
                                                  ),
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                onPressed: () async {
                                                  Future.delayed(
                                                    const Duration(
                                                      milliseconds: 90,
                                                    ),
                                                    () => Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegstrationPage(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const AutoSizeText(
                                                  "REGISTER",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassScreen(),
                                          ),
                                        );
                                      },
                                      child: const AutoSizeText(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        buildText(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildText(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 2.5.w);
    TextStyle linkStyle = const TextStyle(color: ConstantsVar.appColor);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(
              text: 'THEOne.com',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ApiCalls.launchUrl('https://www.theone.com');
                }),
          const TextSpan(text: ' - Our '),
          TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TopicPage(
                                paymentUrl:
                                    'https://www.theone.com/terms-conditions-3',
                              screenName:  ConstantsVar.prefs.getString('guestGUID')??''
                              )));
                }),
          const TextSpan(text: ' and  '),
          TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ApiCalls.launchUrl(
                      'https://www.theone.com/privacy-policy-uae');
                }),
          const TextSpan(
            text: '\nCOPYRIGHT © 2023 THE ONE UAE. ALL RIGHTS RESERVED.  ',
          ),
        ],
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, bool isSuffix) {
    return InputDecoration(
        suffix: isSuffix == false
            ? null
            : ClipOval(
                child: RoundCheckBox(
                  border: Border.all(width: 0),
                  size: 24,
                  onTap: (selected) {},
                  checkedWidget: const Icon(Icons.mood, color: Colors.white),
                  uncheckedWidget: const Icon(Icons.mood_bad),
                  animationDuration: const Duration(
                    seconds: 1,
                  ),
                ),
              ),
        prefixIcon: icon,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        labelText: name,
        border: InputBorder.none);
  }

  // Future getCartBagdge(int val) async {
  //   ApiCalls.readCounter(
  //           customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
  //       .then((value) {
  //     if (mounted)
  //       setState(() {
  //         val = int.parse(value);
  //         context.read<cartCounter>().changeCounter(val);
  //       });
  //   });
  // }

}

const String loginString =
    'Login or register to access our affordable home fashion furniture & accessories in THE One Shopping app or on our website.';
