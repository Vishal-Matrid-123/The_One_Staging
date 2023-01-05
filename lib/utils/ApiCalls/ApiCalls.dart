import 'dart:convert';
import 'dart:developer';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/AppWishlist/WishlistResponse.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginxResponse.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart'; // import 'package:untitled2/AppPages/SearchPage/SearchCategoryResponse/SearchCategoryResponse.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/utils/ApiCalls/CategoryModel.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/utils/ApiParams.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AppPages/WebxxViewxx/PaymentWebView.dart';
import '../../new_apis_func/data_layer/constant_data/constant_data.dart';

class ApiCalls {
  static String customerGuid = ConstantsVar.prefs.getString(kguidKey) ?? '';

  static final String cookie =
      '.Nop.Customer=' + ConstantsVar.prefs.getString(kguidKey)! ?? '';
  static final header = {
    'Cookie': '.Nop.Customer=' + ConstantsVar.prefs.getString(kguidKey)! ?? ''
  };

  /*Product List*/
  static Future<String> getCategoryById({
    required String catId,
    required int pageIndex,
    required String storeId,
    required String baseUrl,
  }) async {
    log('Testing Api');

    final _url = Uri.parse(baseUrl +
        'GetSortedProductsByCategoryId?categoryid=$catId&pageindex=$pageIndex&pagesize=16&$kcustomerIdVar${ConstantsVar.prefs.getString('guestCustomerID')}$kstoreIdVar$storeId');

    log('Product List Api>>>>' + _url.toString());

    try {
      var response = await http.get(_url,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString + jsonDecode(response.body)['Message'].toString();
        } else {
          log(response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Get Api Token*/
  static Future getApiTokken(BuildContext context) async {
    log('I am being beaten');
    final body = {'email': 'apitest@gmail.com', 'password': '12345'};

    final uri = Uri.parse(BuildConfig.base_url + 'token/GetToken?');
    try {
      var response = await http
          .post(
        uri,
        body: body,
      )
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(
              msg:
                  "Connection Timeout.\nPlease try again. Not able to get Required Data./nRestart your app again");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var apiTokken = responseData['tokenId'];
        log('Response Data>>>>>' + apiTokken);
        ConstantsVar.prefs = await SharedPreferences.getInstance();
        ConstantsVar.prefs.setString(kapiTokenKey, apiTokken);
        // ConstantsVar.prefs.setString(key, value)

        return response.body;
      } else {
        Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again or reinstall the app',
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Login*/
  static Future login({
    required BuildContext context,
    required String email,
    required String password,
    required String screenName,
  }) async {
    log('Login');
    CustomProgressDialog _dialog = CustomProgressDialog(
      context,
      dismissable: false,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 40,
      ),
    );
    _dialog.show();
    log(email);
    log('CustomerId:>>>' + ConstantsVar.prefs.getString('guestCustomerID')!);
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var guestUId = ConstantsVar.prefs.getString('guestGUID');
    ConstantsVar.prefs.setString('sepGuid', guestUId!);
    ConstantsVar.isVisible = true;
    String baseUrl = await ApiCalls.getSelectedStore();
    final uri = Uri.parse(baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/LogIn');
    log(uri.toString());
    log(guestUId);
    final body = {
      'apiToken': ConstantsVar.apiTokken,
      'EMail': email,
      'UserName': '',
      "CustId": ConstantsVar.prefs.getString('guestCustomerID'),
      'Password': password,
      'Guid': guestUId,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    };

    log(jsonEncode(body));
    try {
      var response = await http.post(
        uri,
        body: body,
        headers: {'Cookie': '.Nop.Customer=$customerGuid'},
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        _dialog.dismiss();
        var responseData = jsonDecode(response.body);
        log('Login Headers>>>>> ' + jsonEncode(response.headers));

        if (responseData['status'].toString().toLowerCase() == kstatusFailed) {
          Fluttertoast.showToast(
              msg: responseData['Message'].toString(),
              toastLength: Toast.LENGTH_LONG);

          return false;
        } else {
          Fluttertoast.showToast(
            msg: successfullyLoginMessage,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );
          LoginResponse myResponse = LoginResponse.fromJson(
              jsonDecode(jsonEncode(responseData['ResponseData'])));
          var userName = myResponse.data.userName.toString();
          var email = myResponse.data.email.toString();
          var userId = myResponse.data.id.toString();
          var gUId = myResponse.data.guid.toString();
          var phnNumber = myResponse.data.phone;
          log('$userName $userId $email $gUId');
          // final _analytics =
          //     Provider.of<FirebaseAnalytics>(context, listen: false);
          // await _analytics.logLogin(loginMethod: 'THE One Account.');

          FirebaseEvents.initialize(context: context).sendLoginData();
          ConstantsVar.prefs.setString('userName', userName);
          ConstantsVar.prefs.setString('userId', userId);
          ConstantsVar.prefs.setString('email', email);
          ConstantsVar.prefs.setString('guestCustomerID', userId);
          ConstantsVar.prefs.setString('userId', userId);
          ConstantsVar.prefs.setString('guestGUID', gUId);
          ConstantsVar.prefs.setString('phone', phnNumber);

          log(ConstantsVar.prefs.getString('guestCustomerID')!);

          log('Success ');

          switch (screenName) {
            case 'Cart Screen':
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyHomePage(
                            pageIndex: 3,
                          )),
                  (route) => false);
              break;

            case 'Menu Page':
              RestartWidget.restartApp(context);
              break;
            case 'My Account':
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const MyAccount(),
                ),
              );
              break;
            case 'Product Screen':
              Navigator.pop(context, true);

              break;
            case 'Product List':
              Navigator.pop(context, true);

              break;
            case 'Cart Screen2':
              Navigator.pop(context, true);
              break;
            case 'Wishlist':
              Navigator.pop(context, true);
              break;
            default:

              if(screenName.toLowerCase().contains('topic screen')){
                Navigator.pop(context,true);
              }

              else{
                RestartWidget.restartApp(context);
              }
              break;
          }

          return true;
        }

        // Fluttertoast.showToast(msg: responseData.toString().substring(0, 20));
        // _dialog.dismiss();
      } else {
        _dialog.dismiss();
        ConstantsVar.showSnackbar(context, 'Unable to login', 5);
        return false;
      }
    } on Exception catch (e) {
      _dialog.dismiss();
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  /*Get Categories*/
  static Future<String> getCategory(
    BuildContext context, {
    required String customerId,
    required String baseUrl,
    required String storeId,
  }) async {
    log('Category Customer Id:- $customerId');

    final uri = Uri.parse(baseUrl +
        'GetCategoryPage?$kcustomerIdVar$customerId$kstoreIdVar$storeId');

    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log(response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Show Product Details*/
  static Future<String> getProductData(
      String productId, String baseUrl, String storeId,
      [String? customerid]) async {
    final url =
        '${baseUrl}GetProductModelById?Id=$productId&customerid=${ConstantsVar.prefs.getString('guestCustomerID')}&$kstoreIdVar$storeId';
    log(url);

    try {
      var response = await http.get(Uri.parse(url),
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log(response.body);
          return jsonEncode(jsonDecode(response.body)['ResponseData']);
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Add To Cart*/
  static Future<String> addToCart({
    required String productId,
    required String baseUrl,
    required String storeId,
    required String quantity,
    required BuildContext context,
    String? attributeId,
    String? name,
    String? recipName,
    String? email,
    String? recipEmail,
    String? message,
  }) async {
    final uri = Uri.parse(
        '${baseUrl}AddToCart?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&productid=$productId&itemquantity=$quantity&$kstoreIdVar$storeId&'
        'selectedAttributeId=$attributeId&recipientName=$recipName&recipientEmail=$recipEmail&senderName=$name&senderEmail=$email&giftCardMessage=$message');
    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          Fluttertoast.showToast(msg: jsonDecode(response.body)['Message']);
          await readCounter(context: context);
          log(response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Show Cart*/
  static Future<String> showCart(
      {required String baseUrl, required String storeId}) async {
    //
    final uri = Uri.parse(
        '${baseUrl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/Cart?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}$kstoreIdVar$storeId');
    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log('Cart Response>>>>>>>>>>>>>>>' + response.body);
          return jsonEncode(jsonDecode(response.body)['ResponseData']);
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /// Delete cart item id */
  static Future deleteCartItem(
      {required String baseUrl,
      required String storeId,
      required int itemID,
      required BuildContext ctx}) async {
    CustomProgressDialog progressDialog = CustomProgressDialog(ctx,
        loadingWidget: const SpinKitRipple(
          color: Colors.red,
          size: 40,
        ),
        dismissable: false);
    progressDialog.show();

    final _url = Uri.parse(
        '${baseUrl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/RemoveCartItems?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&shoppingCartItemId=$itemID&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&StoreId=$storeId');

    log('remove_cart_url>>>> $_url');
    try {
      var response = await http.get(_url,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        progressDialog.dismiss();
        log('Remove Cart Item' + response.body);
        return result;
      } else {
        progressDialog.dismiss();
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /// Apply coupon code on the cart //
  static Future<String> applyCoupon(
      {required String baseUrl,
      required String storeId,
      required String coupon,
      required RefreshController refresh}) async {
    ConstantsVar.prefs.setString('discount', coupon);
    String success = '';
    final uri = Uri.parse(baseUrl + BuildConfig.apply_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
      kStoreIdVar: storeId
    };

    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        log('coupon result>>>> $result');

        if (result['Status'].toString().toLowerCase() == kstatusSuccess) {
          Fluttertoast.showToast(
              msg: 'Coupon Applied.', toastLength: Toast.LENGTH_LONG);
          refresh.requestRefresh(needMove: true);
        } else {
          Fluttertoast.showToast(
            msg: result['Message'].toString(),
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  /// Remove coupon code on the cart //
  static Future<String> removeCoupon(
      {required String baseUrl,
      required String storeId,
      required String coupon,
      required RefreshController refresh}) async {
    String success = '';
    final uri = Uri.parse(baseUrl + BuildConfig.remove_coupon_url);
    log(coupon);
    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
      kStoreIdVar: storeId,
    };
    log(jsonEncode(body));
    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        log('coupon result>>>> $result');

        String couponStats = result['status'];
        String data = result["Message"];

        if (couponStats.toLowerCase().contains(kstatusFailed)) {
          Fluttertoast.showToast(msg: data, toastLength: Toast.LENGTH_LONG);
          log(couponStats);
        } else {
          ConstantsVar.prefs.setString('discount', '');
          refresh.requestRefresh(needMove: true);
          success = 'true';
        }
      } else {
        log(uri.toString());

        Fluttertoast.showToast(
            msg: '$kerrorString\nStatus Code ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  ///Get all addresses api
  static Future allAddresses(
      String apiToken, String customerId, BuildContext ctx) async {
    getYourAddresses();
    // bool apiresult = false;

    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetCustomerAddressList?apiToken=$apiToken&customerid=$customerId');

    log('address url>>> $uri');
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);
        Map<String, dynamic> result = json.decode(response.body);
        // apiresult = true;
        log('addresses>>> $result');
        return result;
      } else {
        // apiresult = false;
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);

      ctx.loaderOverlay.hide();
    }
  }

  ///Update cart url
  static Future updateCart(
      {required String baseUrl,
      required String quantity,
      required int itemId,
      required String storeId}) async {
    final uri = Uri.parse(
        '${baseUrl}UpdateCart?ShoppingCartItemIds=$itemId&Qty=$quantity&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=$storeId');
    // String success = 'false';
    log('Update Cart Url - ${baseUrl}UpdateCart?ShoppingCartItemIds=$itemId&Qty=$quantity&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=$storeId');
    try {
      var response = await http.post(uri,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      var result = jsonDecode(response.body);
      log('update cart result>>>> $result');
      if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
          kstatusFailed) {
        log(jsonDecode(response.body)['ResponseData']['$itemId'][0]);
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['ResponseData']['$itemId'][0]
                .toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER);
      } else {}
      // Fluttertoast.showToast(msg: result);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future<bool> onWillPop() {
    DateTime currentBackPressTime = DateTime.now();
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  static launchUrl(String myUrl) async {
    if (await canLaunch(myUrl)) {
      await launch(
        myUrl, forceWebView: false,
        forceSafariVC: false,
        // forceWebView: true,
      );
      await launch(
        myUrl,
        // forceSafariVC: true,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      Fluttertoast.showToast(msg: 'Cannot launch this $myUrl');
    }
  }

  /*Add and select new billing address*/
  static Future<void> addAndSelectBillingAddress(
      BuildContext context, String uriName, String snippingModel) async {
    CustomProgressDialog progressDialog = CustomProgressDialog(context,
        loadingWidget: const SpinKitRipple(
          color: Colors.red,
          size: 40,
        ),
        dismissable: false);
    progressDialog.show();
    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_SHIPPING: snippingModel,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? "1"
    };

    final uri = Uri.parse(
        await getSelectedStore() + 'AddSelectNewBillingAddress?'
        // "customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}&" +
        // "BillingAddressModel=${'\{"address":$snippingModel}'}"
        );
    log(uri.toString());
    log(jsonEncode(body));
    try {
      var response = await http
          .post(uri,
              headers: {
                'Cookie': '.Nop.Customer=$customerGuid',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body)
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          progressDialog.dismiss();
          // return kerrorString;
        } else {
          progressDialog.dismiss();
          if (uriName == 'MyAccountAddAddress') {
            //It means adding address is from my account screen
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const MyAddresses(),
              ),
            );
          } else {
            // Add adding from billing screen
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const ShippingAddress(),
              ),
            );
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        progressDialog.dismiss();
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
    }
  }

  /*Add and select new shipping address*/

  /*For Badge Count*/
  static Future<void> readCounter({required BuildContext context}) async {
    String count = '';
    // log(header);
    final uri = Uri.parse(await getSelectedStore() +
        'CartCount?cutomerGuid=${ConstantsVar.prefs.getString(kguidKey)}&CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}$kstoreIdVar${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');

    log('Read Count header>>>>>>>>>>>>>>>>>>>>' +
        jsonEncode({'Cookie': '.Nop.Customer=$customerGuid'}));

    log('Read Count Api>>>>>>>>>>>>>>>>>>>>>>>' + uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      // log(cookie);
      var result = jsonDecode(response.body);
      log('Auto Generated Read Count header>>>>>>>>>>>>>>>>>>>>' +
          jsonEncode(response.body));

      if (result['ResponseData'] != null &&
          result['status'].contains('success')) {
        count = result['ResponseData'].toString();
        log(count);
        // if(context.)
        // if(co)
        final _provider = Provider.of<CartCounter>(context, listen: false);
        _provider.changeCounter(count ?? "0");
      } else {
        count = '';
      }
    } on Exception catch (e) {
      count = '';
      ConstantsVar.excecptionMessage(e);
    }
    // return count;
  }

  /*Subscribe Product*/
  static Future subscribeProdcut(
      {required String productId,
      required String customerId,
      required String apiToken}) async {
    final uri = Uri.parse(
        await getSelectedStore() + 'SubscribeBackInStockNotification?');
    var response = await http.post(uri, body: {
      'apiToken': ConstantsVar.prefs.getString(kapiTokenKey),
      'customerid': ConstantsVar.prefs.getString(kcustomerIdKey),
      'productId': productId,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey)
    }).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    try {
      var jsonResult = jsonDecode(response.body);
      String _status = jsonResult['Status'].toString();
      String _message = jsonResult['Message'].toString();
      log(response.body);
      if (_status.contains('Failed')) {
        if (_message.contains('No Customer Found with Id: $customerId')) {
          Fluttertoast.showToast(
            msg: 'Customer Id does not exist.',
            toastLength: Toast.LENGTH_LONG,
          );
          _message = 'Notify Me!';
          return _message;
        } else if (_message
            .contains('No product found with the specified id')) {
          Fluttertoast.showToast(
              msg: 'No product available with this product id: $productId',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me!';
          return _message;
        } else if (_message.contains('Invalid API token: $apiToken')) {
          Fluttertoast.showToast(
              msg:
                  'Api Token has been expired. Please log out or reinstall the app.',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me!';
          return _message;
        } else if (_message
            .contains('Only registered customers can use this feature')) {
          Fluttertoast.showToast(
              msg: 'Only registered customers can use this feature.',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me!';
          return _message;
        }
        _message = 'Notify Me!';
        return _message;
      } else {
        if (_message.contains('Subscribed')) {
          Fluttertoast.showToast(
                  msg: subscribeMessage, toastLength: Toast.LENGTH_LONG)
              .then((value) async => await FacebookAppEvents().logSubscribe(
                    orderId: productId,
                    currency: CurrencyCode.AED.name,
                    price: 0.0,
                  ));

          _message = 'Unsubscribe';
          return _message;
        } else {
          Fluttertoast.showToast(
              msg: notifyMessage, toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me!';
          return _message;
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Search Categories*/
  static Future<String> getSearchCategory() async {
    // List<SearchCategories> _searchCategoryList = [];
    final uri = Uri.parse(await getSelectedStore() +
        'GetSearchScreenCategories?CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');
    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'],
              toastLength: Toast.LENGTH_LONG);
          return kerrorString;
        } else {
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);

        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Add To Wishlist*/
  static Future<bool> addToWishlist(
      {required String productId,
      required String baseUrl,
      required String storeId,
      required BuildContext context,
      required String senderName,
      required String receiverName,
      required String senderEmail,
      required String receiverEmail,
      required String msg,
      required String attributeId,
      required String itemQuantity}) async {
    final url = Uri.parse(
      '${baseUrl}AddToWishlist?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&productid=$productId&itemquantity=$itemQuantity&recipientName=$receiverName&recipientEmail=$receiverEmail&senderName=$senderName&senderEmail=$senderEmail&giftCardMessage=$msg&selectedAttributeId=$attributeId,$kstoreIdVar$storeId',
    );
    log('Url>>>>>>>>${url.toString()}');

    try {
      var response = await http
          .get(url, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      log('Add to Wishlist>>>>>>>>>>>>>>>>>' + response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains(kstatusFailed)) {
          Fluttertoast.showToast(
            msg: jsonDecode(response.body)['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );

          return false;
        } else {
          Fluttertoast.showToast(
            msg: 'Product Wishlisted.',
            toastLength: Toast.LENGTH_LONG,
          );

          return true;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  /*Show Wishlist*/
  static Future<List<WishlistItem>> getWishlist(
      {required String baseUrl, required String storeId}) async {
    List<WishlistItem> items = [];

    final url = Uri.parse(
        '${baseUrl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/Wishlist?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}$kstoreIdVar$storeId');

    log(url.toString());

    late WishlistResponse response;
    try {
      var jsonResponse = await http
          .get(url, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      log(jsonResponse.body);
      if (jsonResponse.statusCode == 200) {
        if (jsonDecode(jsonResponse.body)['status'].toString().toLowerCase() ==
            kstatusSuccess) {
          response = WishlistResponse.fromJson(
            jsonDecode(jsonResponse.body),
          );

          items = response.responseData!.items;
          return items;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(jsonResponse.body)['Message'].toString());
          return [];
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${jsonResponse.statusCode}');
        return [];
      }
    } on Exception catch (e) {
      items = [];
      ConstantsVar.excecptionMessage(e);
      return items;
    }
  }

  /*Remove Product from Wishlist*/
  static Future<bool> removeFromWishlist(
      {required String productId,
      required String baseurl,
      required String storeId,
      required BuildContext context}) async {
    final url = Uri.parse(
        '${baseurl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/RemoveItemWishlist?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&productid=$productId$kstoreIdVar$storeId');
    try {
      var jsonResponse = await http
          .get(url, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      log(url.toString());
      if ((jsonResponse.statusCode == 200)) {
        if (jsonDecode(jsonResponse.body)['status'].toString().toLowerCase() ==
            kstatusSuccess) {
          Fluttertoast.showToast(
            msg: 'Product Removed from Wishlist successfully.',
            toastLength: Toast.LENGTH_LONG,
          );

          return false;
        } else {
          Fluttertoast.showToast(
            msg: jsonDecode(jsonResponse.body)['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );

          return true;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${jsonResponse.statusCode}');

        return false;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return true;
    }
  }

  /*Save Recently View Product */
  static void saveRecentProduct({required String productId}) async {
    List<String> productIDs =
        ConstantsVar.prefs.getStringList('RecentProducts') ?? [];

    log('ProductIDS>>>>>>>>>>>>>>>>>' + productIDs.join(','));
    if ((productIDs.isEmpty)) {
      productIDs.add(productId);
      ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
    } else if (!productIDs.contains(productId)) {
      if (productIDs.length <= 10 && !productIDs.contains(productId)) {
        if (productIDs.length == 10 && !productIDs.contains(productId)) {
          justRotate(productId: productId, someArray: productIDs);
        } else {
          productIDs.insert(0, productId);
          ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
          log('New Joined Id>>>>' + productId);
          log('New Joined Id>>>>' + productIDs.join(','));
          log(productIDs.length.toString());
        }
      }

      log(productIDs.length.toString());
    } else {
      productIDs.remove(productId);
      productIDs.insert(0, productId);
      ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
    }
  }

  /*Logic for rotating recently viewed products*/
  static void justRotate({
    required List<String> someArray,
    required String productId,
  }) {
    for (int i = (someArray.length - 1); i > 0; i--) {
      someArray[i] = someArray[i - 1];
    }

    someArray[0] = productId;
    for (String element in someArray) {
      log('PrODUCTID>>>>>>' + element);
    }
    ConstantsVar.prefs.setStringList('RecentProducts', someArray);
  }

  /*Share Wishlist*/
  static Future<String> shareWishlist({
    required String customerEmail,
    required String friendEmail,
    required String message,
    required String baseUrl,
    required String storeId,
  }) async {
    String result = '';
    final url = Uri.parse(
        '${baseUrl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/ShareWishlist?');
    try {
      var response = await http.post(url, body: {
        'apiToken': ConstantsVar.prefs.getString(kapiTokenKey),
        'customerid': ConstantsVar.prefs.getString(kcustomerIdKey),
        'personalMessage': message,
        'customerEmail': customerEmail,
        'friendsEmail': friendEmail,
        kStoreIdVar: storeId,
      }, headers: {
        'Cookie': '.Nop.Customer=$customerGuid'
      }).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      log(response.body);

      result = response.body;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      result = 'Nothing Here';
    }
    return result;
  }

  /*Delete Wishlist*/
  static Future<String> deleteWishlist({
    required String baseUrl,
    required String storeId,
  }) async {
    String result = '';
    final url = Uri.parse(
        '${baseUrl.replaceAll('/apisSecondVer', '')}AppCustomerSecondVer/DeleteWishlist');
    log(url.toString());
    try {
      var response = await http.post(url, body: {
        'apiToken': ConstantsVar.prefs.getString(kapiTokenKey),
        'customerid': ConstantsVar.prefs.getString(kcustomerIdKey),
        kStoreIdVar: storeId
      }, headers: {
        'Cookie': '.Nop.Customer=$customerGuid'
      }).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      result = response.body;
      log(result);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      result = 'Nothing Here';
    }
    return result;
  }

  static Future sendAnalytics(
      {required Map<String, dynamic> map, required String eventName}) async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    await analytics
        .logEvent(
          name: eventName,
          parameters: map,
        )
        .whenComplete(() => log('Log has been send'));
  }

  static Future<String> getSubCategories(
      {required String catId,
      required String baseUrl,
      required String storeId}) async {
    // await FirebaseAnalytics.instance.logEvent(name: 'screen_view_',parameters: {'screen_name':'Subcategory Screen'});

    final uri = Uri.parse(
        '${baseUrl}GetSubCategories?categoryid=$catId&$kcustomerIdVar${ConstantsVar.prefs.getString('guestCustomerID')}&$kstoreIdVar$storeId');
    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log(response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Multi Store Api*/
  static Future<String> getStores() async {
    final uri = Uri.parse(
        'http://dev.theone.com/apisSecondVer/GetAllStores?CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}');
    log(uri.toString());
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'});

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log(response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static void saveSelectedStore({required String value}) async {
    // ConstantsVar.prefs = await SharedPreferences.getInstance();
    // ConstantsVar.prefs.setString(kselectedStoreIdKey, value);
    secureStorage.write(key: kselectedStoreIdKey, value: value);
  }

  static Future<String> getSelectedStore() async {
    String _id = await secureStorage.read(key: kselectedStoreIdKey) ?? '1';
    String baseUrl = '';
    switch (_id) {
      case kkStoreId:
        baseUrl = kkBaseUrl;
        log(baseUrl);
        break;
      case kuStoreId:
        baseUrl = kuBaseUrl;
        break;
      case kqStoreId:
        baseUrl = kqBaseUrl;
        break;
      case kbStoreId:
        baseUrl = kbBaseUrl;
        break;
      default:
        baseUrl = kuBaseUrl;
        break;
    }
    return baseUrl;
  }

  static Future<String> checkCart({required BuildContext context}) async {
    String _baseUrl = await ApiCalls.getSelectedStore();
    CustomProgressDialog _progressDialog = CustomProgressDialog(context,
        loadingWidget: const SpinKitRipple(
          color: ConstantsVar.appColor,
          size: 40,
        ),
        dismissable: false);
    _progressDialog.show();
    final url = Uri.parse(_baseUrl +
        'Checkout?CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}$kstoreIdVar${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');

    final response = await http.get(url).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    try {
      log(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'],
              toastLength: Toast.LENGTH_LONG);
          _progressDialog.dismiss();
          return kerrorString;
        } else {
          _progressDialog.dismiss();
          return 'Okay';
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);
        _progressDialog.dismiss();

        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progressDialog.dismiss();
      return kerrorString;
    }
  }

  /* Your Addresses here*/

  static Future<String> getYourAddresses() async {
    final uri = Uri.parse(await getSelectedStore() +
        'GetCustomerAddressList?customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');
    log(uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {'Cookie': '.Nop.Customer=$customerGuid'},
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log("New Address Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /* Delete address from my account */

  static Future<String> deleteAddress(
      {required BuildContext context, required String addressId}) async {
    String baseUrl = await getSelectedStore();
    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_ADDRESS_ID2: addressId,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1'
    };
    CustomProgressDialog progressDialog = CustomProgressDialog(context,
        loadingWidget: const SpinKitRipple(
          color: Colors.red,
          size: 40,
        ),
        dismissable: false);
    progressDialog.show();
    final uri = Uri.parse(
        baseUrl.replaceAll('/apisSecondVer', '') + BuildConfig.delete_address);
    log(uri.toString());
    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          progressDialog.dismiss();
          return kerrorString;
        } else {
          log("New Address Api " + response.body);
          progressDialog.dismiss();
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        progressDialog.dismiss();
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
      return kerrorString;
    }
  }

  /* Add New Address */

  static Future<String> addNewAddress(
      {required BuildContext context, required String snippingModel}) async {
    log("Address Model>>>>>>>>>>>>"
        " $snippingModel");
    String baseUrl = await getSelectedStore();
    CustomProgressDialog _progressDialog = CustomProgressDialog(context,
        loadingWidget: SpinKitRipple(
          color: ConstantsVar.appColor,
          size: 40,
        ),
        dismissable: true);
    _progressDialog.show();
    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
      "data": snippingModel
    };

    final uri = Uri.parse(
        baseUrl.replaceAll('/apisSecondVer', '') + BuildConfig.add_address);
    log(uri.toString());
    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': ' .Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
    _progressDialog.dismiss();
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log("New Address Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progressDialog.dismiss();
      return kerrorString;
    }
    _progressDialog.dismiss();
  }

  /* Edit and save address */

  static Future<String> editAndSaveAddress(
      {required BuildContext context,
      required String addressId,
      required String data,
      required bool isEditAddress}) async {
    log(">>>>>>>>>>>>"
        " $data");
    CustomProgressDialog _progressDialog = CustomProgressDialog(context,
        loadingWidget: SpinKitRipple(
          color: ConstantsVar.appColor,
          size: 40,
        ),
        dismissable: true);
    _progressDialog.show();
    String baseUrl = await getSelectedStore();
    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID2:
          ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_ADDRESS_ID: addressId,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
      ApiParams.PARAM_DATA: data
    };

    final uri = Uri.parse(
        baseUrl.replaceAll('/apisSecondVer', '') + BuildConfig.edit_address);
    log(uri.toString());
    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
 _progressDialog.dismiss();
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());

          return kerrorString;
        } else {
          log("New Address Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progressDialog.dismiss();
      return kerrorString;
    }
    _progressDialog.dismiss();
  }

  /* Show Order Summary */

  static Future<String> showOrderSummary() async {
    final uri = Uri.parse(await getSelectedStore() +
        show_order_summary_url +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}");
    log('Order Summary>>> $uri');
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("New Order Summary Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /* Apply Gift Card */

  static Future<String> applyGiftCard(
      {required String giftcardcouponcode}) async {
    String success = '';
    String baseUrl = await getSelectedStore();

    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_GIFT_COUPON: giftcardcouponcode,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    };

    final uri = Uri.parse(baseUrl + BuildConfig.gift_card_url);

    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      log('gift card result>>>> ${response.body}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        Map<String, dynamic> map = json.decode(response.body);
        Fluttertoast.showToast(
          msg: map['Message'],
          toastLength: Toast.LENGTH_LONG,
        );
        if (map['status'] == 'Failed') {
          return 'false';
        } else {
          return 'true';
        }
      } else {
        return "false";
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
    // return success;
  }

  /* Remove Gift Card */

  static Future<String> removeGiftCard(
      {required String giftcardcouponcode}) async {
    String success = '';
    String baseUrl = await getSelectedStore();

    final body = {
      ApiParams.PARAM_API_TOKEN: ConstantsVar.prefs.getString(kapiTokenKey),
      ApiParams.PARAM_CUSTOMER_ID: ConstantsVar.prefs.getString(kcustomerIdKey),
      ApiParams.PARAM_GIFT_COUPON: giftcardcouponcode,
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    };

    final uri = Uri.parse(baseUrl + BuildConfig.remove_gift_card_url);

    try {
      var response = await http.post(uri,
          body: body,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        log('remove gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
        }

        Fluttertoast.showToast(
          msg: map['Message'],
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

/*Show Billing Address*/
  static Future<String> getBillingAddress() async {
    // final queryParameters = {
    //   ApiParams.PARAM_API_TOKEN: apiToken,
    //   ApiParams.PARAM_CUSTOMER_ID: customerId,
    // };

    final uri = Uri.parse(await getSelectedStore() +
        kbillingAddress +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}");
    log('address url>>> $uri');
    try {
      var response = await http
          .get(uri, headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("New Billing Address Screen Summary Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<String> selectBillingAddress(
      {required String addressId}) async {
    final uri = Uri.parse(await getSelectedStore() +
        BuildConfig.select_billing_address +
        "?" +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}&addressId=$addressId");

    log('select address url>>> $uri');
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("New Billing Address Screen Summary Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Get My Orders Here*/
  static Future<String> getOrder() async {
    final uri = Uri.parse(await getSelectedStore() +
        'GetCustomerOrderList?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey)}');
    log(
      uri.toString(),
    );

    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("My Orders List Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<String> getShippingAddresses() async {
    String _baseUrl = await ApiCalls.getSelectedStore();
    final uri = Uri.parse(_baseUrl +
        kget_shipping_address_url +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey)}");
    log(uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("My Shipping Address List Api " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future addAndSelectShippingAddress(String id2) async {
    final uri = Uri.parse(
        await getSelectedStore() + BuildConfig.add_select_shipping_address_url);
    final snippingModel = jsonEncode({
      'address': {},
      'PickUpInStore': true,
      'pickupPointId': id2,
    });
    final body = {
      "apiToken": ConstantsVar.prefs.getString(kapiTokenKey),
      'ShippingAddressModel': snippingModel,
      "customerid": ConstantsVar.prefs.getString(kcustomerIdKey),
      kStoreIdVar: await secureStorage.read(key: kselectedStoreIdKey)
    };
    try {
      var response = await http.post(
        uri,
        body: body,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("My PickupPoint  Api>> " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  /*Shipping Method Apis */
  static Future<String> getShippingMethods() async {
    final uri = Uri.parse(await getSelectedStore() +
        'GetShippingMethod?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');
    try {
      log('Shipping method Apis >>>>>> $uri');
      var response = await http.get(uri, headers: {
        'Cookie':
            '.Nop.Customer=' + ConstantsVar.prefs.getString(kguidKey)! ?? ''
      }).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("My Shipping Method  Api>> " + response.body);
          return response.body;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }

      // print(jsonDecode(response.body));
      // ShippingMethodResponse methodResponse =
      // ShippingMethodResponse.fromJson(jsonDecode(response.body));
      // setState(() {
      //   shippingMethods.addAll(methodResponse.shippingmethods.shippingMethods);
      // });
      //
      // context.loaderOverlay.hide();
      // if (shippingMethods.isEmpty) {
      //   Navigator.push(
      //       context,
      //       CupertinoPageRoute(
      //           builder: (context) =>
      //               PaymentPage(paymentUrl: widget.paymentUrl)));
      // }
    } on Exception catch (e) {
      // context.loaderOverlay.hide();

      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<String> selectShippingMethod(
      {required String selectionValue, required BuildContext context}) async {
    final uri = Uri.parse(await getSelectedStore() +
        'SelectShippingMethodForApp?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}&shippingoption=$selectionValue');
    log(uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else {
          log("Shipping method List  Api " + response.body);
          String baseUrl = await ApiCalls.getSelectedStore();
          String customerId =
              ConstantsVar.prefs.getString(kcustomerIdKey) ?? "";
          String apiToken = ConstantsVar.prefs.getString(kapiTokenKey) ?? "";
          String storeId =
              await secureStorage.read(key: kselectedStoreIdKey) ?? '1';

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PaymentPage(
                baseUrl: baseUrl.replaceAll('/apisSecondVer', '') +
                    'appcustomerSecondVer/CreateCustomerOrderCheckout?',
                storeId: storeId,
                customerId: customerId,
                apiToken: apiToken,
              ),
            ),
          );
          return "Success";
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  ///Select shipping address
  static Future<String> selectShippingAddress(String addressId) async {
    final uri = Uri.parse(await getSelectedStore() +
        BuildConfig.select_shipping_address_url +
        "?" +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}&addressId=$addressId");
    log('Shipping Response>>>>' + uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          return kerrorString;
        } else if (jsonDecode(response.body)['status']
                    .toString()
                    .toLowerCase() !=
                kstatusFailed &&
            jsonDecode(response.body)['ShowPopUp'].toString() == 'true') {
          return 'Show Popup' +
              '' +
              jsonDecode(response.body)['ButtonType'] +
              jsonDecode(response.body)['Message'];
        } else {
          log("Shipping method selection  Api " + response.body);
          return "Success";
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static String getCountryId({required String baseUrl}) {
    // String _baseUrl = await ApiCalls.getSelectedStore();
    String _countryId = "";
    if (baseUrl.contains("theonekuwait")) {
      _countryId = "51";
    } else if (baseUrl.contains("theoneqatar")) {
      _countryId = "64";
    } else if (baseUrl.contains("theonebahrain")) {
      _countryId = "95";
    } else if (baseUrl.contains("theone.com")) {
      _countryId = "79";
    }
    return _countryId;
  }

  static String getCountryName({required String baseUrl}) {
    String _countryName = "";

    if (baseUrl.contains("theone.com")) {
      _countryName = "United Arab Emirates";
    } else if (baseUrl.contains("theonekuwait")) {
      _countryName = "Kuwait";
    } else if (baseUrl.contains("theoneqatar")) {
      _countryName = "Qatar";
    } else if (baseUrl.contains("theonebahrain")) {
      _countryName = "Bahrain";
    }
    return _countryName;
  }

  /*Forgot Password*/

  static Future<String> forgotPassword(
    BuildContext context,
    String email,
  ) async {
    String _baseUrl = await ApiCalls.getSelectedStore();
    String message = '';
    final uri = Uri.parse(_baseUrl.replaceAll('/apisSecondVer', '') +
        'AppCustomerSecondVer/ForgotPassword?apiToken=${ConstantsVar.apiTokken}&email=$email&CustId=${ConstantsVar.prefs.getString('userId') ?? ConstantsVar.prefs.getString('guestCustomerID')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey)}');
    log('>>> ${uri.toString()}');
    try {
      var response = await http.post(uri,
          headers: {'Cookie': '.Nop.Customer=$customerGuid'}).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        log('${jsonDecode(response.body)}');

        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          return jsonDecode(response.body)['Message'].toString();
        } else {
          message =
              jsonDecode(response.body)['ResponseData']['Result'].toString();
          return message;
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code: ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      message = e.toString();
      return message;
    }
  }

  static Future<String> checkForUpdates() async {
    Fluttertoast.showToast(
        msg: "Checking for updates.....", toastLength: Toast.LENGTH_LONG);
    log("111");

    final uri =
        Uri.parse("https://dev.theone.com/apisSecondVer/GetLatestVersion");
    log(uri.toString());
    try {
      log("1111");
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      Fluttertoast.cancel();
      if (response.statusCode == 200) {
        log("11111");
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          log("111111");
          Fluttertoast.showToast(
            msg: "Checking Version" +
                jsonDecode(response.body)['message'].toString(),
          );
          return kerrorString;
        } else {
          log("Shipping method selection  Api " + response.body);
          return response.body;
        }
      } else if (response.statusCode == 408) {
        return kerrorString;
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<String> deleteAccount() async {
    String _baseUrl = await getSelectedStore();

    String url = _baseUrl.replaceAll('/apisSecondVer', '') +
        "ApisSecondVer/DeleteAccount?CustomerId=${ConstantsVar.prefs.getString('userId')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey)}";
    final uri = Uri.parse(url);
    log(uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      Fluttertoast.cancel();
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
            msg: jsonDecode(response.body)['Message'].toString(),
          );
          return kerrorString;
        } else {
          Fluttertoast.showToast(msg: 'Account Deleted');
          return 'success';
        }
      } else if (response.statusCode == 408) {
        return kerrorString;
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<String> bogoCategoryData() async {
    String _baseUrl = await getSelectedStore();

    String url = _baseUrl +
        "GetBogoCategory?CustomerId=${ConstantsVar.prefs.getString('guestCustomerID')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}";
    final uri = Uri.parse(url);
    log(uri.toString());
    try {
      var response = await http.get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=$customerGuid',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      Fluttertoast.cancel();
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
            msg: jsonDecode(response.body)['Message'].toString(),
          );
          return kerrorString;
        } else {
          return jsonEncode(jsonDecode(response.body)['ResponseData'] ?? '');
        }
      } else if (response.statusCode == 408) {
        return kerrorString;
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return kerrorString;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return kerrorString;
    }
  }

  static Future<bool> getBookingStatus() async {
    String _baseUrl = await getSelectedStore();

    String url = _baseUrl +
        "GetHomestylingBookingStatus?CustomerId=${ConstantsVar.prefs.getString('guestCustomerID')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}";
    try {
      print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie':
              '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey) ?? ''}',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      Fluttertoast.cancel();
      if (response.statusCode == 200) {
        log('Booking response>>>>>>' + response.body);
        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString() +
                  jsonDecode(response.body)['ResponseData'].toString());
          return false;
        } else {
          if (jsonDecode(response.body)['ResponseData']
              .toString()
              .contains('true')) {
            return true;
          } else {
            return false;
          }
        }
      } else if (response.statusCode == 408) {
        return false;
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }
}
