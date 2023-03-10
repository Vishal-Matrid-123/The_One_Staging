import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/OtP/NewxxOTPxxScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/countries_info_model/countries_info_model.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class RegstrationPage extends StatefulWidget {
  const RegstrationPage({Key? key}) : super(key: key);

  @override
  _RegstrationPageState createState() => _RegstrationPageState();
}

class _RegstrationPageState extends State<RegstrationPage>
    with
        AutomaticKeepAliveClientMixin,
        InputValidationMixin,
        WidgetsBindingObserver {
  TextEditingController fController = TextEditingController();
  TextEditingController lController = TextEditingController();
  TextEditingController eController = TextEditingController();
  TextEditingController mController = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  var first_name;
  var last_name;
  var email;
  var mobile_number;
  var passWord;
  var confPassword;
  var fErrorMsg = '';
  var lErrorMsg = '';
  var eErrorMsg = '';
  var mErrorMsg = '';
  var pErrorMsg = '';
  var cpErrorMsg = '';

  var reason;
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  String phnCode = "91";

  int phnMaxLength = 10;

  var cityController = TextEditingController();

  var _countryId = '';

  var textEditingController = TextEditingController();

  var selectedValue;
  List<Country> _searchList = [];

  var editingController = TextEditingController();

  String phnDialCode = '';

  String _initialPrefix = '';

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Registration failed',
            text: 'Okay',
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
            descriptions: 'Registration and Login Successfully Completed.',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: ConstantsVar.appColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  double _opacity = 1.0;

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
    }
  }

  Country? _initialVal;
  NewApisProvider provider = NewApisProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _debounce = Timer(Duration.zero, () {});
    editingController.addListener(() {
      filterSearchResults(editingController.text);
    });
    provider = Provider.of<NewApisProvider>(context, listen: false);

    provider.readJson();
    provider.returnInitialPrefix();

    initSharedPrefs();

    super.initState();
  }

  bool passError = true, cpError = true;

  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 18.w,
            centerTitle: true,
            title: InkWell(
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                AppBarLogo('REGISTRATION', context),
                Opacity(
                  opacity: _opacity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key: formGlobalKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextFormField(
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  maxLength: 100,
                                  textInputAction: TextInputAction.next,
                                  controller: fController,
                                  validator: (firstName) {
                                    if (isFirstName(firstName!)) {
                                      return null;
                                    } else {
                                      return 'Enter a valid First Name';
                                    }
                                  },
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: editBoxDecoration(
                                      'First Name'.toUpperCase(),
                                      const Icon(
                                        Icons.account_circle_outlined,
                                        color:
                                        AppColor.PrimaryAccentColor,
                                      ),
                                      ''),
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextFormField(
                                  maxLength: 100,
                                  validator: (lastName) {
                                    if (isLastName(lastName!)) {
                                      return null;
                                    } else {
                                      return 'Enter your Last Name';
                                    }
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller: lController,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: editBoxDecoration(
                                      'Last Name'.toUpperCase(),
                                      const Icon(
                                        Icons.account_circle_outlined,
                                        color:
                                        AppColor.PrimaryAccentColor,
                                      ),
                                      ''),
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextFormField(
                                  validator: (email) {
                                    if (isEmailValid(email!)) {
                                      return null;
                                    } else {
                                      return 'Enter a valid email address';
                                    }
                                  },
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  controller: eController,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: editBoxDecoration(
                                      'Email Address'.toUpperCase(),
                                      const Icon(
                                        Icons.email_outlined,
                                        color:
                                        AppColor.PrimaryAccentColor,
                                      ),
                                      ''),
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7.w),
                                      child: Text(
                                        'Phone Number'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 3.w,
                                            color: myFocusNode.hasFocus
                                                ? AppColor
                                                .PrimaryAccentColor
                                                : Colors.grey),
                                      ),
                                    ),
                                    Consumer<NewApisProvider>(
                                        builder: (context, value, child) {
                                          return IntlPhoneField(
                                            controller: mController,

                                            decoration: InputDecoration(
                                                labelText: ''.toUpperCase(),
                                                labelStyle: TextStyle(
                                                    fontSize: 1.w,
                                                    color: myFocusNode
                                                        .hasFocus
                                                        ? AppColor
                                                        .PrimaryAccentColor
                                                        : Colors.grey),
                                                border: InputBorder.none,
                                                counterText: ''),
                                            initialCountryCode:
                                            value.initialPrefix,
                                            onChanged: (phone) {
                                              print(phone.completeNumber);

                                              setState(() {
                                                phnDialCode = phone
                                                    .countryCode
                                                    .replaceAll('+', '');
                                              });
                                            },
                                            onCountryChanged: (country) {
                                              print('Country changed to: ' +
                                                  country.name);

                                              setState(() {
                                                for (Country val
                                                in countries) {
                                                  if (val.code
                                                      .toLowerCase() ==
                                                      country.code
                                                          .toLowerCase()) {
                                                    _initialVal = val;
                                                    print(country.code);
                                                    break;
                                                  }
                                                }
                                                phnDialCode =
                                                    country.dialCode;
                                              });
                                            },
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction: TextInputAction.next,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextFormField(
                                    validator: (val) {
                                      if (isAddress(val!.trim())) {
                                        return null;
                                      } else {
                                        return 'Enter your address';
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                    maxLines: 3,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    controller: addressController,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14),
                                    decoration: InputDecoration(
                                        counterText: '',
                                        prefixIcon: const Icon(Icons.home,
                                            color: AppColor
                                                .PrimaryAccentColor),
                                        labelStyle: TextStyle(
                                            fontSize: 5.w,
                                            color: Colors.grey),
                                        labelText:
                                        'Address'.toUpperCase(),
                                        border: InputBorder.none)),
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => setState(() {}),
                                  controller: cityController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.location_city_outlined,
                                      color: AppColor.PrimaryAccentColor,
                                    ),
                                    labelText: 'CITY'.toUpperCase(),
                                    labelStyle: TextStyle(
                                        fontSize: 5.w,
                                        color: Colors.grey),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
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
                            addVerticalSpace(14),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor:
                                        Colors.transparent,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: StatefulBuilder(
                                            builder: (BuildContext ctx,
                                                StateSetter
                                                setStatee) =>
                                                Padding(
                                                  padding:
                                                  EdgeInsets.all(3.w),
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 3.w),
                                                        child: Container(
                                                          color: Colors.white,
                                                          padding:
                                                          EdgeInsets.all(
                                                              3.w),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  setStatee(
                                                                          () {
                                                                        _searchList =
                                                                            filterSearchResults(
                                                                                value);
                                                                      });
                                                                },
                                                                controller:
                                                                editingController,
                                                                decoration: InputDecoration(
                                                                    labelText:
                                                                    "Search Your Country",
                                                                    hintText:
                                                                    "Search Your Country",
                                                                    prefixIcon:
                                                                    Icon(Icons
                                                                        .search),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                        BorderRadius.all(Radius.circular(5.0)))),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                ListView(
                                                                  children: List.generate(
                                                                      _searchList.length ==
                                                                          0
                                                                          ? countries
                                                                          .length
                                                                          : _searchList
                                                                          .length,
                                                                          (index) => _searchItems(_searchList.length ==
                                                                          0
                                                                          ? countries[index]
                                                                          : _searchList[index])),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: ClipOval(
                                                          child: Container(
                                                            color:
                                                            Colors.black,
                                                            child: InkWell(
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 5.5.w),
                                      child: SizedBox(
                                        width: 90.w,
                                        child: AutoSizeText(
                                          _initialVal == null
                                              ? '???????' +
                                              ' Select your country'
                                                  .toUpperCase()
                                              : _initialVal!.flag +
                                              ' ' +
                                              _initialVal!.name,
                                          style: TextStyle(
                                            fontSize: 5.w,
                                            color: _initialVal == null
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _initialVal == null
                                          ? true
                                          : false,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 1.w),
                                        child: Text(
                                          _initialVal == null
                                              ? 'Please Select your country'
                                              : '',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  validator: (password) {
                                    if (isPasswordValid(password!)) {
                                      return 'Minimum 6 letters required ';
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
                                              passError
                                                  ? passError = selected!
                                                  : passError = selected!;
                                            });
                                          },
                                          isChecked: passError,
                                          borderColor: Colors.white,
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
                                      prefixIcon: const Icon(
                                        Icons.password_rounded,
                                        color:
                                        AppColor.PrimaryAccentColor,
                                      ),
                                      labelStyle: TextStyle(
                                          fontSize: 5.w,
                                          color: Colors.grey),
                                      labelText: 'Password'.toUpperCase(),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            addVerticalSpace(14),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0)),
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
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
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14),
                                    decoration: InputDecoration(
                                        suffix: ClipOval(
                                          child: RoundCheckBox(
                                            borderColor: Colors.white,
                                            checkedColor: Colors.white,
                                            uncheckedColor: Colors.white,
                                            size: 20,
                                            onTap: (selected) {
                                              setState(() {
                                                cpError
                                                    ? cpError = selected!
                                                    : cpError = selected!;
                                              });
                                            },
                                            isChecked: cpError,
                                            checkedWidget: const Center(
                                              child: Icon(
                                                Icons.visibility,
                                                size: 20,
                                              ),
                                            ),
                                            uncheckedWidget: const Center(
                                              child: Icon(
                                                Icons.visibility_off,
                                                color: AppColor
                                                    .PrimaryAccentColor,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.password_rounded,
                                          color:
                                          AppColor.PrimaryAccentColor,
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize: 5.w,
                                            color: Colors.grey),
                                        labelText: 'Confirm Password'
                                            .toUpperCase(),
                                        border: InputBorder.none)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildText(context),
                )
               ,
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
                              style: raisedButtonStyle,
                              onPressed: () async {
                                if (_initialVal == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Please select your country');
                                }

                                if (formGlobalKey.currentState!.validate() &&
                                    _initialVal != null) {
                                  // use the information provided
                                  formGlobalKey.currentState!.save();

                                  String phnNumbe = mController.text.toString();
                                  var phnNumber;
                                  setState(() {
                                    phnNumber = phnNumbe;
                                  });
                                  log('initial code' + _initialVal!.code);
                                  for (CountriesDataResponse val
                                      in provider.countriesInfo) {
                                    if (val.twoLetterIsoCode.toLowerCase() ==
                                        _initialVal!.code.toLowerCase()) {
                                      setState(() {
                                        _countryId = val.id.toString();
                                      });
                                      break;
                                    } else {
                                      _countryId = '';
                                    }
                                  }

                                  // List<>

                                  log('Country Id' + _countryId);
                                  log('Country Id' + mController.text);
                                  Map<String, dynamic> regBody = {
                                    'Email': eController.text,
                                    'Username': '',
                                    'Password': pController.text,
                                    'ConfirmPassword': cpController.text,
                                    'Gender': "M",
                                    'FirstName': fController.text,
                                    'LastName': lController.text,
                                    'DayofBirthDay': null,
                                    'DayofBirthMonth': null,
                                    'DayofBirthYear': null,
                                    'StreetAddress': addressController.text,
                                    'StreetAddress2': 'xzx',
                                    'City': cityController.text,
                                    'CountryId': _countryId,
                                    'AvailableCountries': null,
                                    'StateProvinceId': '0',
                                    'AvailableStates': null,
                                    'Phone':
                                        phnDialCode + ' ' + mController.text,
                                    'Newsletter': false,
                                  };

                                  _countryId != ''
                                      ? Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                VerificationScreen2(
                                              phoneNumber: phnDialCode +
                                                  mController.text,
                                              email: eController.text,
                                              password: cpController.text,
                                              registerBody: regBody,
                                              dialCode: phnDialCode,
                                            )
                                            // OTP_Screen(
                                            // title: 'OTP SCREEN',
                                            // mainBtnTitle:
                                            //     'Verify otp'.toUpperCase(),
                                            // phoneNumber: phnNumbe,
                                            // email:
                                            //     eController.text.toString(),
                                            // password: cpController.text)
                                            ,
                                          ),
                                        )
                                      : Fluttertoast.showToast(
                                          msg:
                                              'Cannot use this country. Please change your country');
                                }
                              },
                              // color: ConstantsVar.appColor,
                              // shape: const RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "REGISTER",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // setInitialPrefix() async {
  //    returnInitialPrefix()
  //       .then((value) => setState(() => _initialPrefix = value));
  //   print(_initialPrefix);
  // }

  bool returnVisibility({required String countryCode}) {
    bool _isAvailable = true;
    for (CountriesDataResponse val in provider.countriesInfo) {
      if (val.twoLetterIsoCode.toLowerCase() == countryCode.toLowerCase()) {
        _isAvailable = true;

        break;
      } else {
        _isAvailable = false;
      }
    }

    return _isAvailable;
  }

  Widget _searchItems(Country item) {
    print("Visibility>>>" +
        returnVisibility(countryCode: item.code).toString() +
        "  " +
        item.name);
    return Visibility(
      visible: returnVisibility(countryCode: item.code),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _initialVal = item;
            });
            Navigator.maybePop(context);
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: _initialVal != null && _initialVal == item
                ? ConstantsVar.appColor
                : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 70.w,
                alignment: Alignment.centerLeft,
                color: _initialVal != null && _initialVal == item
                    ? ConstantsVar.appColor
                    : Colors.white,
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                child: Row(children: [
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    item.flag,
                    style: TextStyle(
                      fontSize: 5.w,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      item.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 5.w,
                        overflow: TextOverflow.ellipsis,
                        color: _initialVal != null && _initialVal == item
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late Timer _debounce;
  int _debouncetime = 500;

  List<Country> filterSearchResults(String query) {
    List<Country> _searchedList = [];

    for (int i = 0; i < countries.length; i++) {
      Country name = countries[i];
      if (name.name.toLowerCase().startsWith(query.toLowerCase()) ) {
        _searchedList.add(countries[i]);
      }
    }
    return _searchedList;
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

  InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
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

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildText(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 2.5.w);
    TextStyle linkStyle = const TextStyle(color: ConstantsVar.appColor);
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          const TextSpan(text: 'By clicking Register, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TopicPage(
                      paymentUrl: 'https://www.theone.com/terms-conditions-3',
                      screenName: '',
                    ),
                  ),
                );
              },
          ),
          const TextSpan(text: ' and that you have read our '),
          TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ApiCalls.launchUrl(
                      'https://www.theone.com/privacy-policy-uae');
                }),
        ],
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isDiscountCoupont(String coupon, String) =>
      coupon.trim() != '' || coupon.trim().length != 0;

  bool isGiftCoupont(String coupon, String) =>
      coupon.trim() != '' || coupon.trim().length != 0;

  bool isPasswordValid(String password) =>
      password.length < 6 || password.length == 0;

  bool isPasswordMatch(String password, String confirmPass) =>
      password == confirmPass;

  bool isFirstName(String firstName) => firstName.trim().length != 0;

  bool isLastName(String lastName) => lastName.trim().length != 0;

  bool isPhoneNumber(String phnNumber, int phnMaxLength) =>
      phnNumber.trim().length != phnMaxLength;

  bool isAddress(String addressString) => addressString.trim().length >= 5;

  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool oldPassword(String pass) => pass.trim().length != 0;
}
