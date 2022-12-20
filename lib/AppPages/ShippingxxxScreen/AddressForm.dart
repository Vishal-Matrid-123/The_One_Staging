import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// / import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/countries_info_model/countries_info_model.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

// import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({
    Key? key,
    required this.btnTitle,
    required this.title,
    required this.uri,
    required this.isShippingAddress,
    required this.isEditAddress,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address1,
    required this.countryName,
    required this.city,
    required this.phoneNumber,
    required this.id,
    required this.company,
    required this.faxNumber,
    // VoidCallback? refreshCallback
  }) : super(key: key);
  String uri;
  String btnTitle;
  bool isShippingAddress;
  bool isEditAddress;

  //data of address
  String firstName;
  String lastName;
  String email;
  String address1;
  String countryName;
  String city;
  String phoneNumber;
  int id;
  String company;
  String faxNumber;
  String title;

  // VoidCallback  _refreshCallback;
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with InputValidationMixin {
  var emailController = TextEditingController();

  // var apiToken;
  var firstNameController = TextEditingController(); //for first name
  var numberController = TextEditingController();
  var cityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkBoxVal = false;
  FocusNode myFocusNode = FocusNode();

  var countryController = TextEditingController();
  var companyController = TextEditingController();
  var faxController = TextEditingController();
  var address2Controller = TextEditingController();

  var textControllerLast = TextEditingController();

  var controllerAddress = TextEditingController();

  // var guestId;
  var buttonText = 'ADD ADDRESS';
  bool countryVisible = false;
  bool faxNumberVisible = false;
  bool companyVisible = false;
  bool address2Visible = false;
  bool showTitle = true;
  NewApisProvider _apiProvider = NewApisProvider();
  bool _willGo = false;
  var phnCode = '';
  var phnMaxLength = 10;

  Country? _initialVal;

  var editingController = TextEditingController();
  List<Country> _searchList = [];

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

  Widget _searchItems(Country item) {
    return Padding(
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
          color: item == _initialVal ? ConstantsVar.appColor : Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 70.w,
              alignment: Alignment.centerLeft,
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
    );
  }

  String initialCountryCode = '';

  String returnMobileNumber() {
    if (widget.isEditAddress == true) {
      if (widget.phoneNumber.contains(' ')) {
        String mobileNumber = widget.phoneNumber.split(' ')[1];
        print('Initial  phn number >>> ' + mobileNumber);

        return mobileNumber;
      } else {
        return widget.phoneNumber;
      }
    }else{
      return '';
    }
  }

  void returnCountryCode() {
    if (widget.isEditAddress == true) {
      if (widget.phoneNumber.contains(' ')) {
        String initialDialCode = widget.phoneNumber.split(' ')[0];
        print('Initial Dial Code of the phn number >>> ' + initialDialCode);

        for (Country element in countries) {
          if (element.dialCode == initialDialCode) {
            setState(() {
              initialCountryCode = element.code;
              phnDialCode = initialDialCode;
            });
            break;
          }
        }
      } else {
        setState(() {
          initialCountryCode = '';
          phnDialCode = '';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    textControllerLast = TextEditingController();
    numberController = TextEditingController();
    countryController = TextEditingController();
    controllerAddress = TextEditingController();
    cityController = TextEditingController();
    emailController = TextEditingController();
    returnCountryCode();
    //changes for add new address and edit address both 19 sept
    if (widget.isEditAddress == true) {
      setState(() {
        firstNameController.text = widget.firstName;
        textControllerLast.text = widget.lastName;
        emailController.text = widget.email;
        numberController.text = returnMobileNumber();
        countryController.text = widget.countryName;
        controllerAddress.text = widget.address1;
        cityController.text = widget.city;
        companyController.text = widget.company;
        faxController.text = widget.faxNumber;
        buttonText = 'SAVE';
        countryVisible = true;
        faxNumberVisible = true;
        companyVisible = true;
        address2Visible = true;
        showTitle = false;
      });
    }
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getYourAddresses();
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => MyHomePage(
                              pageIndex: 0,
                            )),
                    (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              )),
          // resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: showTitle,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEEEEE),
                    ),
                    child: Align(
                      alignment: const Alignment(0.05, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AutoSizeText(
                          widget.title.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 6.w,
                            fontWeight: FontWeight.w800,
                          ),
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
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            controller: firstNameController,
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
                              fontSize: 16.dp,
                            ),
                            maxLines: 1,
                            validator: (val) {
                              if (isFirstName(firstNameController.text)) {
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
                          padding: const EdgeInsets.all(8.0),
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
                              '',
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.dp,
                            ),
                            maxLines: 1,
                            validator: (val) {
                              if (isLastName(val!)) {
                                return null;
                              } else {
                                return 'Please Provide Your Last Name';
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
                            padding: const EdgeInsets.all(8.0),
                            child: IntlPhoneField(
                              controller: numberController,
                              decoration: InputDecoration(
                                  labelText: 'Phone Number'.toUpperCase(),
                                  labelStyle: TextStyle(
                                      fontSize: 5.w,
                                      color: myFocusNode.hasFocus
                                          ? AppColor.PrimaryAccentColor
                                          : Colors.grey),
                                  border: InputBorder.none,
                                  counterText: ''),
                              initialCountryCode: initialCountryCode,
                              onChanged: (phone) {
                                print(phone.countryCode);
                                setState(() {
                                  phnDialCode = phone.countryCode.replaceAll('+', '');
                                });
                              },
                              onCountryChanged: (country) {
                                print('Country changed to: ' + country.dialCode);
                                setState(() {
                                  phnDialCode = country.dialCode;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
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
                        elevation: 8.0,
                        child: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (val) {
                                if (isEmailValid(val!)) {
                                  return null;
                                } else {
                                  return 'Enter Your Email Address';
                                }
                              },
                              cursorColor: Colors.black,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              decoration: editBoxDecoration(
                                  'Email Address'.toUpperCase(),
                                  const Icon(
                                    Icons.email_outlined,
                                    color: AppColor.PrimaryAccentColor,
                                  ),
                                  ''),
                            ),
                          ),
                        ),
                      ),

                      /* Company */
                      Visibility(
                        visible: companyVisible,
                        child: Card(
                          margin: const EdgeInsets.only(top: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: companyController,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: editBoxDecoration(
                                    'Company',
                                    const Icon(
                                      Icons.home_outlined,
                                      color: AppColor.PrimaryAccentColor,
                                    ),
                                    ''),
                              ),
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
                        elevation: 8.0,
                        child: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: controllerAddress,
                              validator: (val) {
                                if (isAddress(val!)) {
                                  return null;
                                }
                                return 'Please Provide Your Address';
                              },
                              cursorColor: Colors.black,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
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
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
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
                                return StatefulBuilder(
                                  builder: (BuildContext ctx,
                                          StateSetter setStatee) =>
                                      Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: SizedBox(
                                      // padding:
                                      //     new EdgeInsets.fromLTRB(
                                      //         10.0,
                                      //         0.0,
                                      //         10.0,
                                      //         10.0),
                                      height: 70.h,

                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 3.w),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius
                                                          .only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              30.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              30.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              30.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              30.0))),
                                              padding: EdgeInsets.all(3.w),
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
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Search Your Country",
                                                        hintText:
                                                            "Search Your Country",
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5.0)))),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      children: List.generate(
                                                          _searchList.length ==
                                                                  0
                                                              ? countries.length
                                                              : _searchList
                                                                  .length,
                                                          (index) => _searchItems(
                                                              _searchList.length ==
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
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
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
                                            ' Select your country'.toUpperCase()
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
                      /* Fax number */
                      Visibility(
                        visible: faxNumberVisible,
                        child: Card(
                          margin: const EdgeInsets.only(top: 10),
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
                              controller: faxController,
                              obscureText: false,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_city_outlined,
                                  color: AppColor.PrimaryAccentColor,
                                ),
                                labelText: 'Fax Number',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.dp,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        width: 50.w,
                        color: ConstantsVar.appColor,
                        child: const Center(
                          child: AutoSizeText(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (widget.isEditAddress == false) {
                            if (widget.uri.contains('MyAccountAddAddress')) {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const MyAddresses(),
                                ),
                              );
                            } else {
                              Navigator.pop(
                                context,
                              );
                            }
                          } else {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const MyAddresses(),
                              ),
                            );
                          }
                        },
                      ),
                      AppButton(
                        width: 50.w,
                        color: ConstantsVar.appColor,
                        onTap: () async {
                          if (_initialVal == null) {
                            Fluttertoast.showToast(
                                msg: 'Please Select Your Country',
                                toastLength: Toast.LENGTH_LONG);
                          } else if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            final provider = Provider.of<NewApisProvider>(
                                context,
                                listen: false);

                            provider.readJson();
                            log('initial code' + _initialVal!.code);
                            for (CountriesDataResponse val
                                in provider.countriesInfo) {
                              if (val.twoLetterIsoCode.toLowerCase() ==
                                  _initialVal!.code.toLowerCase()) {
                                setState(() {
                                  _countryId = val.id.toString();
                                });
                              }
                            }

                            var body = {
                              'FirstName': firstNameController.text,
                              'LastName': textControllerLast.text,
                              'Email': emailController.text,
                              'Company': companyController.text,
                              'CountryId': _countryId,
                              // ApiCalls.getCountryId(baseUrl: _baseUrl),
                              'StateProvinceId': '0',
                              'City': cityController.text,
                              'Address1': controllerAddress.text,
                              'Address2': '',
                              'ZipPostalCode': '',
                              'PhoneNumber': phnDialCode +
                                  ' ' +
                                  numberController.text,
                              'FaxNumber': faxController.text,
                              'Country': _initialVal!.name,
                              // ApiCalls.getCountryName(baseUrl: _baseUrl),
                            };

                            // String Transformer.urlEncodeMap(Map<String, dynamic>)

                            // String myAddress = Transformer.urlEncodeMap(body);
                            //
                            // log("My Address>>"+myAddress);
                            if (widget.isEditAddress == false) {
                              //add new address

                              log(body.toString());
                              ConstantsVar.prefs.setString(
                                  'addressJsonString', jsonEncode(body));
                              if (widget.uri.contains('MyAccountAddAddress')) {
                                _apiProvider
                                    .addNewAddress(
                                        context: context,
                                        snippingModel: jsonEncode(body))
                                    .whenComplete(() {
                                  setState(() => _willGo = true);
                                });
                              } else {
                                ApiCalls.addAndSelectBillingAddress(
                                  context,
                                  widget.uri.toString(),
                                  jsonEncode(body),
                                );
                              }
                            } else {
                              _apiProvider
                                  .editAddress(
                                      context: context,
                                      addressId: widget.id.toString(),
                                      data: jsonEncode(body),
                                      isEditAddress: widget.isEditAddress)
                                  .whenComplete(() {
                                setState(() => _willGo = true);
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please Provide correct details');
                          }
                        },
                        child: Center(
                          child: AutoSizeText(
                            widget.btnTitle.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
    return InputDecoration(
      prefixText: prefixText,
      counterText: '',
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
}
