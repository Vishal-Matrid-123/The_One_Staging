import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/ShippingxxMethodxx.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({
    Key? key,
  }) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails>
    with InputValidationMixin {
  String phnCode = "";
  int phnMaxLength = 10;

  String checkCountryCode(String storeId) {
    switch (storeId) {
      case '1':
        phnCode = '971';
        break;
      case '3':
        phnCode = '965';
        break;
      case '4':
        phnCode = '973';
        break;
      case '5':
        phnCode = '974';
        break;
    }
    return phnCode;
  }

  int checkMaxLength(String storeId) {
    switch (storeId) {
      case '1':
        phnMaxLength = 9;
        break;
      case '3':
        phnMaxLength = 8;
        break;
      case '4':
        phnMaxLength = 8;
        break;
      case '5':
        phnMaxLength = 8;
        break;
    }
    return phnMaxLength;
  }

  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;
  late TextEditingController textController5;
  late TextEditingController textController6;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode myFocusNode = FocusNode();

  var countryController = TextEditingController();

  var textControllerLast = TextEditingController();

  var controllerAddress = TextEditingController();

  var eController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController5 = TextEditingController();
    textController6 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => MyApp()),
                    (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              )),
          resizeToAvoidBottomInset: true,
          key: scaffoldKey,
          body: WillPopScope(
            onWillPop: _willGoBack,
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: Align(
                        alignment: const Alignment(0.05, 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AutoSizeText(
                            'shipping ADDRESS'.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 6.5.w,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        scrollDirection: Axis.vertical,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                controller: textController1,
                                obscureText: false,
                                decoration: editBoxDecoration(
                                    'FIRST NAME'.toUpperCase(),
                                    const Icon(
                                      Icons.person_outline,
                                      color: AppColor.PrimaryAccentColor,
                                    ),
                                    ''),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                maxLines: 1,
                                validator: (val) {
                                  if (isFirstName(val!)) {
                                    return null;
                                  } else {
                                    return 'Please Enter Your First Name';
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                controller: textControllerLast,
                                obscureText: false,
                                decoration: editBoxDecoration(
                                    'last Name'.toUpperCase(),
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.red,
                                    ),
                                    ''),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                maxLines: 1,
                                validator: (val) {
                                  if (isLastName(val!)) {
                                    return null;
                                  } else {
                                    return 'Please Enter Your Last Name';
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  onTap: () async {
                                    phnCode = checkCountryCode(
                                        await secureStorage.read(
                                                key: kselectedStoreIdKey) ??
                                            "1");
                                    phnMaxLength = checkMaxLength(
                                        await secureStorage.read(
                                                key: kselectedStoreIdKey) ??
                                            "1");
                                  },
                                  textInputAction: TextInputAction.next,
                                  maxLength: phnMaxLength,
                                  onChanged: (_) => setState(() {}),
                                  controller: textController2,
                                  obscureText: false,
                                  decoration: editBoxDecoration(
                                      'phone number'.toUpperCase(),
                                      const Icon(Icons.phone,
                                          color: AppColor.PrimaryAccentColor),
                                      phnCode),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 4.w,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please Enter Your Phone Number';
                                    }
                                    if (val.length < 9) {
                                      return 'Please Enter Your Number Correctly';
                                    }
                                    if (val.length > 9) {
                                      return 'Please Enter Your Number Correctly';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 4.0,
                            child: Container(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: eController,
                                    validator: (val) {
                                      if (isEmailValid(val!)) {
                                        return null;
                                      }

                                      return 'Enter your email address';
                                    },
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 4.w),
                                    decoration: editBoxDecoration(
                                        'Email Address'.toUpperCase(),
                                        const Icon(
                                          Icons.email_outlined,
                                          color: AppColor.PrimaryAccentColor,
                                        ),
                                        '')),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 4.0,
                            child: Container(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controllerAddress,
                                  validator: (val) {
                                    if (isAddress(val!)) {
                                      return null;
                                    } else {
                                      return 'Enter your Address';
                                    }
                                  },
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 4.w),
                                  maxLines: 3,
                                  decoration: editBoxDecoration(
                                      'Address'.toUpperCase(),
                                      const Icon(
                                        Icons.home_outlined,
                                        color: AppColor.PrimaryAccentColor,
                                      ),
                                      ''),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                controller: textController6,
                                obscureText: false,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.location_city_outlined,
                                    color: AppColor.PrimaryAccentColor,
                                  ),
                                  labelText: 'CITY'.toUpperCase(),
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                maxLines: 1,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please Provide Your City';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          color: ConstantsVar.appColor,
                          width: 50.w,
                          onTap: () => Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ShippingAddress(),
                            ),
                          ),
                          child: const AutoSizeText(
                            'CANCEL',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        AppButton(
                          color: ConstantsVar.appColor,
                          width: 50.w,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              if (kDebugMode) {
                                print('Tap appear on Add Shipping Address');
                              }

                              String _baseUrl =
                                  await ApiCalls.getSelectedStore();

                              Map<String, dynamic> body = {
                                'FirstName': textController1.text,
                                'LastName': textControllerLast.text,
                                'Email': eController.text,
                                'Company': '',
                                'CountryId':
                                    ApiCalls.getCountryId(baseUrl: _baseUrl),
                                'StateProvinceId': '0',
                                'City': textController6.text,
                                'Address1': controllerAddress.text,
                                'Address2': '',
                                'ZipPostalCode': '',
                                'PhoneNumber':
                                    '$phnCode${textController2.text}',
                                'FaxNumber': '',
                                'Country':
                                    ApiCalls.getCountryName(baseUrl: _baseUrl),
                              };
                              if (kDebugMode) {}
                              Map<String, dynamic> shipBody = {
                                'address': body,
                                'PickUpInStore': false,
                                'pickupPointId': null
                              };

                              await addShippingAddress(jsonEncode(shipBody))
                                  .then((value) {
                                switch (value) {
                                  case kerrorString:
                                    Fluttertoast.showToast(
                                        msg: kerrorString +
                                            "\nPlease try again.",
                                        toastLength: Toast.LENGTH_LONG);
                                    break;
                                  default:
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const ShippingMethod(),
                                      ),
                                    );
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please provide correct details');
                            }
                          },
                          child: const Center(
                            child: AutoSizeText(
                              'CONTINUE',
                              style: TextStyle(
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
    return InputDecoration(
      counterText: '',
      prefixText: prefixText,
      prefixIcon: icon,
      // alignLabelWithHint: true,
      labelStyle: TextStyle(
          fontSize: myFocusNode.hasFocus ? 20 : 16.0,
          //I believe the size difference here is 6.0 to account padding
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,

      border: InputBorder.none,
    );
  }

  Future<String> addShippingAddress(String encodedResponse) async {
    final uri = Uri.parse(
        await ApiCalls.getSelectedStore() + 'AddSelectNewShippingAddress?');
    log(uri.toString());

    final body = {
      "apiToken": ConstantsVar.prefs.getString(kapiTokenKey),
      "customerid": ConstantsVar.prefs.getString(kcustomerIdKey),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey),
      "ShippingAddressModel": encodedResponse,
    };

    try {
      var response = await http.post(
        uri,
        body: body,
        headers: {
          'Cookie': '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey)}'
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)["status"].toString().toLowerCase() ==
            kstatusSuccess) {
          return response.body;
        } else {
          List<String> _message =
              List<String>.from(jsonDecode(response.body)["Message"]).toList();
          Fluttertoast.showToast(
            msg: _message.join("\n"),
            toastLength: Toast.LENGTH_LONG,
          );
          return kerrorString;
        }
      } else {
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  Future<bool> _willGoBack() async {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const ShippingAddress(),
      ),
    );
    return true;
  }
}
