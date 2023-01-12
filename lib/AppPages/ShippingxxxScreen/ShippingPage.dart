import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/ShippingxxMethodxx.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/countries_info_model/countries_info_model.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/new_apis_func/presentation_layer/screens/store_selection_screen/store_selection_screen.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../WebxxViewxx/TopicPagexx.dart';

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

  var editingController = TextEditingController();

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
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);

    _apiProvider.readJson();
    _apiProvider.returnInitialPrefix();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController5 = TextEditingController();
    textController6 = TextEditingController();
  }

  List<Country> _searchList = [];
  Country? _initialVal;

  String _countryId = '';
  String phnDialCode = '';

  List<Country> filterSearchResults(String query) {
    List<Country> _searchedList = [];

    for (int i = 0; i < countries.length; i++) {
      Country name = countries[i];
      if (name.name.toLowerCase().contains(query.toLowerCase())) {
        _searchedList.add(countries[i]);
      }
    }
    return _searchedList;
  }

  NewApisProvider _apiProvider = NewApisProvider();

  bool returnVisibility({required String countryCode}) {
    bool _isAvailable = true;
    for (CountriesDataResponse val in _apiProvider.countriesInfo) {
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
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 70.w,
                alignment: Alignment.centerLeft,
                color: _initialVal != null && _initialVal! == item
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
                          fontSize: 5.w, overflow: TextOverflow.ellipsis),
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

  String initialCountryCode = '';

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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 8.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7.w),
                                    child: Text(
                                      'Phone Number'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 3.w,
                                          color: myFocusNode.hasFocus
                                              ? AppColor.PrimaryAccentColor
                                              : Colors.grey),
                                    ),
                                  ),
                                  Consumer<NewApisProvider>(
                                    builder: (context, value, _) =>
                                        IntlPhoneField(
                                      controller: textController2,
                                      decoration: InputDecoration(
                                          labelText: ''.toUpperCase(),
                                          labelStyle: TextStyle(
                                              fontSize: 1.w,
                                              color: myFocusNode.hasFocus
                                                  ? AppColor.PrimaryAccentColor
                                                  : Colors.grey),
                                          border: InputBorder.none,
                                          counterText: ''),
                                      initialCountryCode: value.initialPrefix,
                                      onChanged: (phone) {
                                        print(phone.completeNumber);

                                        setState(() {
                                          phnDialCode = phone.countryCode
                                              .replaceAll('+', '');
                                        });
                                      },
                                      onCountryChanged: (country) {
                                        print('Country changed to: ' +
                                            country.name);

                                        setState(() {
                                          for (Country val in countries) {
                                            if (val.code.toLowerCase() ==
                                                country.code.toLowerCase()) {
                                              _initialVal = val;
                                              print(country.code);
                                              break;
                                            }
                                          }
                                          phnDialCode = country.dialCode;
                                        });
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ],
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

                          /*Country */

                          addVerticalSpace(14),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  elevation: 10,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: StatefulBuilder(
                                        builder: (BuildContext ctx,
                                                StateSetter setStatee) =>
                                            Padding(
                                          padding: EdgeInsets.all(3.w),
                                          child: SizedBox(
                                            height: 60.h,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 3.w),
                                                  child: Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          new BorderRadius.only(
                                                        topLeft: const Radius
                                                            .circular(30.0),
                                                        topRight: const Radius
                                                            .circular(30.0),
                                                        bottomLeft: const Radius
                                                            .circular(30.0),
                                                        bottomRight:
                                                            const Radius
                                                                .circular(
                                                          30.0,
                                                        ),
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(3.w),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        TextField(
                                                          onChanged: (value) {
                                                            setStatee(() {
                                                              _searchList =
                                                                  filterSearchResults(
                                                                      value);
                                                            });
                                                          },
                                                          controller:
                                                              editingController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Search Your Country",
                                                            hintText:
                                                                "Search Your Country",
                                                            prefixIcon: Icon(
                                                                Icons.search),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                  5.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Expanded(
                                                          child: ListView(
                                                            children: List.generate(
                                                                _searchList
                                                                            .length ==
                                                                        0
                                                                    ? countries
                                                                        .length
                                                                    : _searchList
                                                                        .length,
                                                                (index) => _searchItems(_searchList
                                                                            .length ==
                                                                        0
                                                                    ? countries[
                                                                        index]
                                                                    : _searchList[
                                                                        index])),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 1,
                                                  right: 1.w,
                                                  child: ClipOval(
                                                    child: Container(
                                                      color: Colors.black,
                                                      child: InkWell(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 5.5.w),
                                    child: SizedBox(
                                      width: 90.w,
                                      child: AutoSizeText(
                                        _initialVal == null
                                            ? '🏳️' +
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
                                    visible: _initialVal == null ? true : false,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 1.w),
                                      child: Text(
                                        _initialVal == null
                                            ? 'Please Select your country'
                                            : '',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                ],
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
                            final provider = Provider.of<NewApisProvider>(
                                context,
                                listen: false);

                            provider.readJson();
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              if (kDebugMode) {
                                print('Tap appear on Add Shipping Address');
                              }
                              if (_initialVal == null) {
                                Fluttertoast.showToast(
                                    msg: 'Please Select Your Country',
                                    toastLength: Toast.LENGTH_LONG);
                              } else {
                                log('initial code' + _initialVal!.code);
                                String _firstName = textController1.text;
                                String _lastName = textControllerLast.text;
                                String _email = eController.text;
                                String _city = textController6.text;
                                String _address = controllerAddress.text;
                                String _phNumber = textController2.text;
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
                                Map<String, dynamic> body = {
                                  'FirstName': _firstName.trimRight(),
                                  'LastName': _lastName.trimRight(),
                                  'Email': _email.trimRight(),
                                  'Company': '',
                                  'CountryId': _countryId,
                                  'StateProvinceName': '',
                                  'City': _city.trimRight(),
                                  'Address1': _address.trimRight(),
                                  'Address2': '',
                                  "PhoneNumber":
                                      '$phnDialCode ${_phNumber.trimRight()}'
                                          .trimRight(),
                                  "FaxNumber": '',
                                  "CountryName": '',
                                };
                                print(jsonEncode(body));
                                if (kDebugMode) {}
                                Map<String, dynamic> shipBody = {
                                  "address": body,
                                  "PickUpInStore": false,
                                  "pickupPointId": null
                                };

                                _countryId == ''
                                    ? Fluttertoast.showToast(
                                        msg:
                                            'Cannot ship items to this country. Please Change country')
                                    : await addShippingAddress(
                                            jsonEncode(shipBody))
                                        .then((_value) {
                                        switch (_value) {
                                          case kerrorString:
                                            Fluttertoast.showToast(
                                                msg: kerrorString + "",
                                                toastLength: Toast.LENGTH_LONG);
                                            break;
                                          default:
                                            if (_value
                                                .toLowerCase()
                                                .contains('show popup')) {
                                              _showCustomerPopUp(
                                                  message: _value);
                                            } else {
                                              Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const ShippingMethod(),
                                                ),
                                              );
                                            }
                                        }
                                      });
                              }
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

  _showCustomerPopUp({required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 5, top: 45 + 20, right: 5, bottom: 20),
              margin: const EdgeInsets.only(top: 35),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AutoSizeText(
                      message.replaceAll('nz', '\n\n')
                          .replaceAll('Show Popup', '')
                          .replaceFirst('switch', '')
                          .replaceFirst('call', '')
                      ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String baseUrl = await ApiCalls.getSelectedStore();
                          String _storeId = await secureStorage.read(
                              key: kselectedStoreIdKey) ??
                              "1";
                          message.contains('switch')
                              ? Navigator.maybePop(context)
                              : Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => TopicPage(
                                paymentUrl: baseUrl +
                                    'CreateCustomerOrderForGlobalApp?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${_storeId}',
                                screenName: 'shipping',
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.black,
                          ),
                        ),
                        child: AutoSizeText(
                          message.contains('switch') ? 'Cancel' : 'Okay',
                          style: TextStyle(
                            fontSize: 4.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Visibility(
                        visible: message.contains('switch') ? true : false,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.maybePop(context);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => StoreSelectionScreen(
                                  screenName: 'Shipping Screen',
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                          ),
                          child: AutoSizeText(
                            'Switch Store',
                            style: TextStyle(
                              fontSize: 4.w,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: message.contains('switch') ? true : false,
                    child: AutoSizeText(
                      'It will empty your current cart. Please recreate the order on switching the store.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(45)),
                    child: Image.asset("MyAssets/logo.png")),
              ),
            ),
          ],
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
    String data = encodedResponse;
    CustomProgressDialog _dialog = CustomProgressDialog(context,
        dismissable: true,
        loadingWidget: SpinKitRipple(
          color: ConstantsVar.appColor,
          size: 40,
        ));

    _dialog.show();
    final uri = await ApiCalls.getSelectedStore() +
        'AddSelectNewShippingAddress?customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey)}&ShippingAddressModel=$data';
    log(uri);

    try {
      var response = await Dio().post(
        uri.toString(),
      );
      log(jsonEncode(response.data));
      if (response.statusCode == 200) {
        _dialog.dismiss();
        if (response.data['status'].toString().toLowerCase() != kstatusFailed &&
            response.data['ShowPopUp'].toString() == 'true') {
          return 'Show Popup' +
              '' +
              response.data['ButtonType'] +
              response.data['Message'].toList().join(',');
        } else if (response.data["status"].toString().toLowerCase() ==
            kstatusSuccess) {
          _dialog.dismiss();
          return jsonEncode(response.data);
        } else {
          _dialog.dismiss();
          List<String> _message =
              List<String>.from(response.data["Message"]).toList();
          Fluttertoast.showToast(
            msg: _message.join("\n"),
            toastLength: Toast.LENGTH_LONG,
          );

          return kerrorString;
        }
      } else {
        _dialog.dismiss();
        return kerrorString;
      }
    } on Exception catch (e) {
      _dialog.dismiss();
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
    _dialog.dismiss();
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
