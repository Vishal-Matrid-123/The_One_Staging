import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class ConstantsVar {
  static String baseUri = 'https://www.theone.com/apis/';

  static double width = MediaQueryData.fromWindow(window).size.width;
  static double height = MediaQueryData.fromWindow(window).size.height;
  static String customerID = prefs.getString('guestCustomerID')!;

  static bool isCart = true;
  static late SharedPreferences prefs;
  static bool isVisible = false;


  static String orderSummaryResponse = '';

  static int selectedIndex = 0;

  static String stringShipping =
      'Pick up your items at the store or our Local Warehouse. Our Customer Service will confirm your pick up date as soon as possible.';

  static showSnackbar(BuildContext context, String value, int time) {
    final _scaffold = ScaffoldMessenger.of(context);
    final _snackbarContent = SnackBar(
      content: Text(value),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: time),
    );
    _scaffold.showSnackBar(_snackbarContent);
  }

  static late int productID;

  static String? apiTokken = prefs.getString('apiTokken');

  static const Color appColor = Color.fromARGB(255, 164, 0, 0);

  // static const String OtpCode = '1234';

  static double textSize = width * .06;
  static double textFieldSize = width * .05;

  static List<BottomNavigationBarItem> btmItem = [
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: const Icon(
            Icons.notifications,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: const Icon(
            HeartIcon.heart,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: const Icon(
            HeartIcon.user,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: const Icon(
            HeartIcon.logout,
            color: appColor,
          ),
        ),
        label: ''),
  ];

  static const String pass_Pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String email_Pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static Future checkValidation(
      String email, String pass, BuildContext context) async {
    if (RegExp(pass_Pattern).hasMatch(pass) &&
        RegExp(email_Pattern).hasMatch(email)) {
      showSnackbar(context, 'Pattern Matches', 4);
    } else {
      showSnackbar(context, 'Pattern Missmatches', 4);
      isVisible = false;
    }
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '\n');
  }

  static void excecptionMessage(Exception e) {
    if (e is FormatException) {
      Fluttertoast.showToast(
        msg: 'Url not found.',
      );
    } else if (e is SocketException) {
      Fluttertoast.showToast(
          msg: internetException, toastLength: Toast.LENGTH_LONG);
    } else if (e is TimeoutException) {
      Fluttertoast.showToast(
          msg: timeoutException, toastLength: Toast.LENGTH_LONG);
    } else if (e is NoSuchMethodError) {
      Fluttertoast.showToast(msg: dataNotExist, toastLength: Toast.LENGTH_LONG);
    } else if (e is DeferredLoadException) {
      Fluttertoast.showToast(
          msg: libraryFailed, toastLength: Toast.LENGTH_LONG);
    } else if (e is IntegerDivisionByZeroException) {
      Fluttertoast.showToast(
          msg: 'Number can\'t be divided by Zero.',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  static var compare = (String b, a) => b.compareTo(a);

  static List<String> suggestionList = [
    "Bath Accessories",
    "Bedroom Accessories",
    "BEDROOM Storage FUSION",
    "Beds",
    "Bedside Tables",
    "Bedside Tables FUSION",
    "Bedspreads",
    "Cabinets FUSION",
    "Candle Accessories",
    "Candle Accessories FUSION",
    "Candles",
    "Ceiling Lamps",
    "Ceiling Lamps FUSION",
    "Chairs",
    "Chairs FUSION",
    "Clocks & Wall Decor",
    "Coffee & Side Tables",
    "Coffee & Side Tables FUSION",
    "Cushions",
    "Cushions & Throws",
    "Decor",
    "Desk Accessories",
    "Desks",
    "Dining Accessories",
    "Dining Chair FUSION",
    "Dining Chairs",
    "Dining Storage",
    "Dining Storage FUSION",
    "Dining Tables FUSION",
    "Display Units",
    "Display Units FUSION",
    "Floor Lamps",
    "Floor Lamps FUSION",
    "Flowers",
    "Flowers & Plants",
    "Framed Wall Art",
    "GIFT SHOP",
    "Glassware",
    "Home Decor",
    "Kitchen",
    "Mirrors",
    "Mirrors FUSION",
    "Sofas",
    "Music FUSION",
    "Photo Accessories",
    "Pots & Planters",
    "Quilts, Pillows & Inners",
    "Stools & Poufs",
    "Table Lamps",
    "Table Lamps FUSION",
    "Tableware",
    "Throws",
    "Vases",
    "Wall Lamps",
    "Wall Lamps FUSION"
  ];
}

const String internetException =
    'Please ensure WiFi or Mobile Data is turned on or may be server is busy.\n Please try again.';
const String dataNotExist = 'Data does not exist.';
const String timeoutException =
    'Sorry your session has timed out please try again.';
const libraryFailed = 'Sorry loading has failed, please try again.';
const notifyMessage =
    'Click Notify Me for an email when product is available again';
const subscribeMessage =
    'You will be notify notified soon when the this product is available again.';
const addToCartMessage =
    'Product was successfully added to the your Shopping Cart.';
const cartLimitMessage = 'Your quantity exceeds the stock on hand.';
const stockOutMessage =
    'Product is out of stock, please subscribe for updates.';
const removeCartItemMessage = 'Item Successfully Removed.';
const loginFailedMessage =
    '\'Wrong Details\.\’Your account or password is incorrect.';
const customerDeleteMessage = 'Customer account has been deleted.';
const successfullyLoginMessage = "Successfully logged in.";
const registrationDetailsMissingMessage = 'Please provide all details.';
const otpMessage = 'You will receive a security code shortly.';
const otpWrongMessage = 'Something went wrong\! Please try again.';
const otpVerificationFailedMessage = 'Verification failed please try again\.';
const registrationCompleteMessage = ' Registration completed';
