import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import 'OTP_Response.dart';

const Color primaryColor = Color(0xFF121212);
const Color accentPurpleColor = Color(0xFF6A53A1);
const Color accentPinkColor = Color(0xFFF99BBD);
const Color accentDarkGreenColor = Color(0xFF115C49);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

class VerificationScreen1 extends StatefulWidget {
  const VerificationScreen1({Key? key}) : super(key: key);

  @override
  _VerificationScreen1State createState() => _VerificationScreen1State();
}

class _VerificationScreen1State extends State<VerificationScreen1> {
  late List<TextStyle?> otpTextStyles;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verification Code",
              style: theme.textTheme.headline4,
            ),
            const SizedBox(height: 16),
            Text(
              "We texted you a code",
              style: theme.textTheme.headline6,
            ),
            Text("Please enter it below", style: theme.textTheme.headline6),
            const Spacer(flex: 2),
            OtpTextField(
              numberOfFields: 5,
              borderColor: const Color(0xFF512DA8),
              focusedBorderColor: primaryColor,

              showFieldAsBox: true,
              textStyle: theme.textTheme.subtitle1,
              onCodeChanged: (String value) {},
              onSubmit: (String verificationCode) {
                //navigate to different screen code goes here
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  },
                );
              }, // end onSubmit
            ),
            const Spacer(),
            Center(
              child: Text(
                "Didn't get code?",
                style: theme.textTheme.subtitle1,
              ),
            ),
            const Spacer(flex: 3),
            // CustomButton(
            //   onPressed: () {},
            //   title: "Confirm",
            //   color: primaryColor,
            //   textStyle: theme.textTheme.subtitle1?.copyWith(
            //     color: Colors.white,
            //   ),
            // ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class VerificationScreen2 extends StatefulWidget {
  String phoneNumber, dialCode;

  String email;

  String password;
  Map<String, dynamic> registerBody;

  VerificationScreen2({
    Key? key,
    required this.phoneNumber,
    required this.dialCode,
    required this.email,
    required this.password,
    required this.registerBody,
  }) : super(key: key);

  @override
  _VerificationScreen2State createState() => _VerificationScreen2State();
}

class _VerificationScreen2State extends State<VerificationScreen2>
    with WidgetsBindingObserver {
  late List<TextStyle?> otpTextStyles;

  // CustomProgressDialog? _progressDialog;

  String? apiToken;

  String? guid;

  double _opacity = 1.0;
  String? databody;

  String? otpRefs;
  String statusSus = 'Sucess';
  String failed = 'Failed';
  var reason;

  String otpString = '';

  String myOtp = '';

  String phnCode = "";
  int phnMaxLength = 1;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    initSharedPrefs().whenComplete(() => getOtp());

    setState(() {});
    // TODO: implement initState
    super.initState();

    setState(() {
      apiToken = ConstantsVar.prefs.getString('apiTokken');
      guid = ConstantsVar.prefs.getString('guestGUID');
      databody = jsonEncode(widget.registerBody);
    });
    super.initState();
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

  checkCountryCode(String storeId) {
    switch (storeId) {
      case '1':
        setState(() {
          phnCode = '971';
        });

        break;
      case '3':
        setState(() {
          phnCode = '965';
        });
        break;
      case '4':
        setState(() {
          phnCode = '973';
        });
        break;
      case '5':
        setState(() {
          phnCode = '974';
        });
        break;
    }
  }



  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: ConstantsVar.appColor,
    primary: ConstantsVar.appColor,
    minimumSize: Size(50.w, 50),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
          toolbarHeight: 18.w,
          centerTitle: true,
          title: Image.asset(
            'MyAssets/logo.png',
            width: 15.w,
            height: 15.w,
          )),
      body: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    "Verification Code".toUpperCase(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 6.5.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.w),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: AutoSizeText(
                "We texted you a code",
                style: theme.textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText("Please enter it below",
                  style: theme.textTheme.headline6),
            ),
            const Spacer(flex: 2),
            Opacity(
              opacity: _opacity,
              child: OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                focusedBorderColor: primaryColor,
                obscureText: true,
                showFieldAsBox: true,
                textStyle: theme.textTheme.subtitle1,
                onCodeChanged: (String value) {},
                onSubmit: (String verificationCode) async {
                  //navigate to different screen code goes here
                  setState(() => myOtp = verificationCode);

                  await verifyOTP(verificationCode.startsWith("0")
                          ? "0${verificationCode.replaceFirst("0", "")}"
                          : verificationCode)
                      .then(
                    (otp) {
                      // register();
                    },
                  );
                }, // end onSubmit
              ),
            ),
            const Spacer(),
            Opacity(
              opacity: _opacity,
              child: InkWell(
                onTap: () {
                  getOtp();
                },
                child: Center(
                  child: AutoSizeText(
                    "Didn't get code? Resend OTP",
                    style: theme.textTheme.subtitle1,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 3),
            const Spacer(flex: 2),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: raisedButtonStyle,
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: AutoSizeText(
                                  "CANCEL",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {});
                            //
                            var string = myOtp;

                            setState(() {
                              otpString = string;
                            });
                            log(otpString);
                            if (myOtp.isEmpty ||
                                myOtp.length < 6 ||
                                myOtp.length > 6) {
                              Fluttertoast.showToast(
                                  msg: 'Please provide OTP',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR);
                            } else {
                              await verifyOTP(otpString).then((otp) {
                                context.loaderOverlay.hide();
                                // register();
                              });
                            }
                          },
                          style: raisedButtonStyle,
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: AutoSizeText(
                                  "VERIFY OTP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String otpAPIVal = '';

  Future<void> getOtp() async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      context,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
      dismissable: false,
    );
    _progressDialog.show();
    log(jsonEncode(widget.registerBody));
    // await SmsAutoFill().listenForCode;
    // final uri = Uri.parse(
    //    PhoneNumber=${BuildConfig.countryCode}${widget.phoneNumber}');
    var _phnNumber = widget.phoneNumber;
    String _baseUrl = await ApiCalls.getSelectedStore();

    final uri = Uri.parse(_baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/SendOTP');
    String _customerId = ConstantsVar.prefs.getString('guestCustomerID') ?? '';
    log(_customerId);
    final _body = {
      'CustId': _customerId,
      'PhoneNumber': _phnNumber,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1'
    };

    try {
      var response = await post(uri, body: _body);

      log(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() !=
            kstatusFailed) {
          _progressDialog.dismiss();

          OtpResponse _otpResponse =
              OtpResponse.fromJson(jsonDecode(response.body));
          if (_otpResponse.status.contains('Success')) {
            setState(() {
              otpRefs = _otpResponse.responseData.otpReference;
            });
            Fluttertoast.showToast(msg: otpMessage);
          }
        } else {
          Fluttertoast.showToast(
            msg: otpWrongMessage +
                '\n' +
                jsonDecode(response.body)['Message'].toString(),
            toastLength: Toast.LENGTH_LONG,
          );
          _progressDialog.dismiss();
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code: ${response.statusCode}');
      }
      _progressDialog.dismiss();
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progressDialog.dismiss();
    }
  }

  void showErrorDialog(String reason) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Registration Failed!',
            text: 'Okay'.toUpperCase(),
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
            descriptions: registrationCompleteMessage,
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  Future verifyOTP(String otp) async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      context,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
      dismissable: true,
    );
    _progressDialog.show();

    final body = {
      'PhoneNumber': phnCode + widget.phoneNumber,
      'otp': myOtp,
      'otpReference': otpRefs,
      'CustId': ConstantsVar.prefs.getString('guestCustomerID'),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    };

    String _baseUrl = await ApiCalls.getSelectedStore();
    String url2 = _baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/VerifyOTP';

    final url = Uri.parse(url2);

    try {
      var response = await post(
        url,
        body: body,
      );

      // final result = jsonDecode(response.body);
      _progressDialog.dismiss();

      if (jsonDecode(response.body)['Status'].toString() == 'Failed') {

        Fluttertoast.showToast(
            msg: otpVerificationFailedMessage +
                '\n' +
                jsonDecode(response.body)['ResponseData']['procResponse'],
            toastLength: Toast.LENGTH_LONG,
            fontSize: 12);
        _progressDialog.dismiss();
      } else {
        log(response.body);
        Fluttertoast.showToast(msg: 'OTP Verified');
        register();
      }
      _progressDialog.dismiss();
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progressDialog.dismiss();
    }
    _progressDialog.dismiss();
  }

  Future<void> initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    String storeId = await secureStorage.read(key: kselectedStoreIdKey) ?? "1";
    checkCountryCode(storeId);
    // await SMS
  }

  Future register() async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      context,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
      dismissable: false,
    );
    _progressDialog.show();

    String _baseUrl = await ApiCalls.getSelectedStore();

    String urL = _baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/CustomerRegister';
    log(urL);

    final body = {
      'apiToken': apiToken,
      'CustomerGuid': guid,
      'data': jsonEncode(widget.registerBody),
      'CustId': ConstantsVar.prefs.getString('guestCustomerID'),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey)
    };
    final url = Uri.parse(urL);

    try {
      var response = await post(url, body: body);
      var result = jsonDecode(response.body);
      log(response.body);

      if (jsonDecode(response.body)['status'].toString() == statusSus) {
        Fluttertoast.showToast(
            msg: 'Registration Complete', toastLength: Toast.LENGTH_LONG);
        ApiCalls.login(
                context: context,
                email: widget.email,
                password: widget.password,
                screenName: 'OTP Screen')
            .then((value) {
          _progressDialog.dismiss();
        });
      } else if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
          kstatusFailed.toLowerCase()) {
        _progressDialog.dismiss();

        setState(() => reason = jsonDecode(response.body)['Message']);
        showErrorDialog(reason);
        log(result);
      }
    } on Exception catch (e) {
      _progressDialog.dismiss();

      ConstantsVar.excecptionMessage(e);
      log(e.toString());
    }
  }

  TextStyle? createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3?.copyWith(color: color);
  }
}
