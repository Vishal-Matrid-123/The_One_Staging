import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
// import 'package:custom_dialog_flutter_demo/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../../../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../../../utils/utils/ApiParams.dart';

class ContactUS extends StatefulWidget {
  final id;
  final name;
  final desc;
  final bool boolValue;

  // final Route route;

  const ContactUS({
    Key? key,
    required this.id,
    required this.name,
    required this.desc,
    required this.boolValue,
  }) : super(key: key);

  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> with InputValidationMixin {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emailBody = TextEditingController();
  var _userName;
  var _email;
  var apiToken;

  bool selected = true;
  var _subject;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    widget.boolValue == true
        ? setState(() => _subject == 'THE One UAE Product Enquiry')
        : setState(() => _subject == 'THE One UAE Contact us');
    getUserCreds().then((value) => setState(() {
          name.text = _userName;
          email.text = _email;
          if (widget.name.toString().trim().length == 0 ||
              widget.id.toString().trim().length == 0) {
            emailBody.text = '';
            setState(() {});
          } else {
            String body = 'Name: ' +
                widget.name +
                '\n' '\n' +
                'SKU: ' +
                widget.id.toString() +
                '\n' '\n' +
                'Short Descritption: ' +
                widget.desc +
                '\n' +
                '\n';
            emailBody.text = body;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        if (currentFocus.hasFocus) {
          setState(() {
            currentFocus.unfocus();
          });
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: new AppBar(
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            centerTitle: true,
            title: InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyApp(),
                  ),
                  (route) => false),
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              width: 100.w,
              height: 100.h,
              // padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8,
                            ),
                            child: Container(
                              width: 100.w,
                              child: Center(
                                child: AutoSizeText(
                                  'Contact Us'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 6.w,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            // padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: AutoSizeText(
                                  'YOUR NAME:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 4.w,
                                  ),
                                ),
                                subtitle: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (firstName) {
                                    if (isFirstName(firstName!))
                                      return null;
                                    else
                                      return 'Enter your Name.';
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                  ),
                                  maxLines: 1,
                                  controller: name,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              addVerticalSpace(10),
                              ListTile(
                                title: AutoSizeText(
                                  'YOUR EMAIL:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 4.w,
                                  ),
                                ),
                                subtitle: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) {
                                    if (isEmailValid(email!))
                                      return null;
                                    else
                                      return 'Enter a valid email address';
                                  },

                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 1,
                                  // maxLength: 20,
                                  controller: email,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              addVerticalSpace(10),
                              ListTile(
                                title: AutoSizeText(
                                  'ENQUIRY:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 4.w,
                                  ),
                                ),
                                subtitle: TextFormField(
                                  textInputAction: TextInputAction.newline,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) {
                                    if (emailBody.text.length < 5) {
                                      return 'Please enter proper information ';
                                    }
                                    return null;
                                  },
                                  controller: emailBody,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Container(height: 2,child: Divider(color: Colors.black,))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100.w,
                    color: ConstantsVar.appColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: LoadingButton(
                        loadingWidget: SpinKitCircle(
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          if (currentFocus.hasFocus) {
                            if (mounted)
                              setState(() {
                                currentFocus.unfocus();
                              });
                          }
                          if (mounted) if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await sendEnquiry();
                            setState(() {});
                          } else {}
                        },
                        defaultWidget: Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: ConstantsVar.appColor,
                        type: LoadingButtonType.Flat,
                        borderRadius: 0,
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

  String checkSubject(String storeId) {
    if (storeId == '1') {
      return (widget.boolValue == true)
          ? 'THE One UAE Product Enquiry'
          : 'THE One UAE Contact us';
    } else if (storeId == '3') {
      return (widget.boolValue == true)
          ? 'THE One Kuwait Product Enquiry'
          : 'THE One Kuwait Contact us';
    } else if (storeId == '4') {
      return (widget.boolValue == true)
          ? 'THE One Bahrain Product Enquiry'
          : 'THE One Bahrain Contact us';
    } else if (storeId == '5') {
      return (widget.boolValue == true)
          ? 'THE One Qatar Product Enquiry'
          : 'THE One Qatar Contact us';
    } else {
      return '';
    }
  }

  Future sendEnquiry() async {
    String baseUrl = await ApiCalls.getSelectedStore();

    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(const SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));

    Map<String, dynamic> contactUsBody = {};
    contactUsBody = {
      'Email': email.text.toString(),
      'Subject': checkSubject(
          await secureStorage.read(key: kselectedStoreIdKey) ?? '1'),
      'SubjectEnabled': true,
      'Enquiry': emailBody.text.toString(),
      'FullName': name.text.toString(),
      'SuccessfullySent': false,
      'Result': null,
      'DisplayCaptcha': false,
      'CustomProperties': {}
    };
    log('>>>${json.encode(contactUsBody)}');

    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      'contactUsModel': json.encode(contactUsBody),
      kCustomerIdVar: ConstantsVar.prefs.getString(kcustomerIdKey),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1'
    };

    final uri = Uri.parse(baseUrl.replaceAll('/apisSecondVer', '') +
        BuildConfig.send_contact_us_enquiry);
    log('>>>>$uri');

    try {
      var response = await post(uri, body: body, headers: ApiCalls.header);
      Map<String, dynamic> map = jsonDecode(response.body);

      log('>>>>>${jsonDecode(response.body)}');
      showSucessDialog(map['Message']);
    } on Exception catch (e) {
      log(e.toString());
      ConstantsVar.excecptionMessage(e);

    }
  }

  Future init() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  Future getUserCreds() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    _userName = ConstantsVar.prefs.getString('userName') != null
        ? ConstantsVar.prefs.getString('userName')
        : '';
    _email = ConstantsVar.prefs.getString('email') != null
        ? ConstantsVar.prefs.getString('email')
        : '';
    apiToken = ConstantsVar.apiTokken;
  }

  void showSucessDialog(String _message) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox(
            descriptions: _message,
            text: 'Not Go',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }
}
