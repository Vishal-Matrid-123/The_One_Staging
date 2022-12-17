import 'dart:io' show Platform;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/ChangePassword/ChangePassword.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ReturnScreen/OrderReturnStatus/OrderReturnScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool _willPop = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> _willgoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => MyHomePage(
              pageIndex: 4,
            ),
          ),
          (route) => false);
      setState(() {
        _willPop = true;
      });
      return _willPop;
    }

    return WillPopScope(
      onWillPop: _willPop ? _willgoBack : () async => false,
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              centerTitle: true,
              toolbarHeight: 18.w,
              title: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ), (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              )),
          body: GestureDetector(
            onHorizontalDragUpdate: (dragDetails) {
              Platform.isIOS
                  ? checkBackSwipe(dragDetails)
                  : print('Android Here');
            },
            child: Container(
              width: 100.w,
              height: 100.h,
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: AutoSizeText(
                          'my account'.toUpperCase(),
                          style: TextStyle(shadows: <Shadow>[
                            Shadow(
                              offset: const Offset(1.0, 1.2),
                              blurRadius: 3.0,
                              color: Colors.grey.shade300,
                            ),
                            Shadow(
                              offset: const Offset(1.0, 1.2),
                              blurRadius: 8.0,
                              color: Colors.grey.shade300,
                            ),
                          ], fontSize: 5.w, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            onTap: () async {
                              ConstantsVar.prefs =
                                  await SharedPreferences.getInstance();
                              var customerId =
                                  ConstantsVar.prefs.getString('userId');

                              if (customerId == null || customerId == '') {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      bottom: true,
                                      maintainBottomViewPadding: true,
                                      child: Container(
                                        width: 100.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 3.h),
                                        height: 27.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AutoSizeText(
                                              'You are not logged in.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 12.w,
                                                      width: 30.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10.0,
                                                        ),
                                                        color: ConstantsVar
                                                            .appColor,
                                                        border: const Border(
                                                          top: BorderSide(
                                                            color: ConstantsVar
                                                                .appColor,
                                                          ),
                                                          bottom: BorderSide(
                                                            color: ConstantsVar
                                                                .appColor,
                                                          ),
                                                          left: BorderSide(
                                                            color: ConstantsVar
                                                                .appColor,
                                                          ),
                                                          right: BorderSide(
                                                            color: ConstantsVar
                                                                .appColor,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: LoadingButton(
                                                          color: Colors.black,
                                                          loadingWidget:
                                                              const SpinKitCircle(
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                          height: 12.w,
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoginScreen(
                                                                  screenKey:
                                                                      'My Account',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          defaultWidget:
                                                              const AutoSizeText(
                                                            "LOGIN",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.0,
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 16.0,
                                                      ),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            Colors.black,
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              side:
                                                                  const BorderSide(
                                                                color:
                                                                    ConstantsVar
                                                                        .appColor,
                                                              ),
                                                            ),
                                                          ),
                                                          overlayColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .red),
                                                        ),
                                                        onPressed: () async {
                                                          Future.delayed(
                                                            const Duration(
                                                              milliseconds: 90,
                                                            ),
                                                            () => Navigator.of(
                                                                    context)
                                                                .push(
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const RegstrationPage(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            const AutoSizeText(
                                                          "REGISTER",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const MyAddresses()));
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.w,
                                  horizontal: 8.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Card(
                                      child: Icon(
                                        HeartIcon.address,
                                        color: ConstantsVar.appColor,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: AutoSizeText(
                                        'my Addresses'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            onTap: () async {
                              ConstantsVar.prefs =
                                  await SharedPreferences.getInstance();
                              var customerId =
                                  ConstantsVar.prefs.getString('userId');

                              if (customerId == null || customerId == '') {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      bottom: true,
                                      maintainBottomViewPadding: true,
                                      child: Container(
                                        width: 100.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 3.h),
                                        height: 27.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AutoSizeText(
                                              'You are not logged in.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                      color:
                                                          ConstantsVar.appColor,
                                                      border: const Border(
                                                        top: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        bottom: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        left: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        right: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: LoadingButton(
                                                        color: Colors.black,
                                                        loadingWidget:
                                                            const SpinKitCircle(
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                        height: 12.w,
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  const LoginScreen(
                                                                screenKey:
                                                                    'My Account',
                                                              ),
                                                            ),
                                                          );
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
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 16.0,
                                                    ),
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          Colors.black,
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                              color:
                                                                  ConstantsVar
                                                                      .appColor,
                                                            ),
                                                          ),
                                                        ),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () async {
                                                        Future.delayed(
                                                          const Duration(
                                                            milliseconds: 90,
                                                          ),
                                                          () => Navigator.of(
                                                                  context)
                                                              .push(
                                                            CupertinoPageRoute(
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => const MyOrders(
                                        isFromWeb: false,
                                      ),
                                    ));
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.w,
                                  horizontal: 8.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Card(
                                      child: Icon(
                                        HeartIcon.order,
                                        color: ConstantsVar.appColor,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: AutoSizeText(
                                        'my orders'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            onTap: () async {
                              ConstantsVar.prefs =
                                  await SharedPreferences.getInstance();
                              var customerId =
                                  ConstantsVar.prefs.getString('userId');

                              if (customerId == null || customerId == '') {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      bottom: true,
                                      maintainBottomViewPadding: true,
                                      child: Container(
                                        width: 100.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 3.h),
                                        height: 27.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AutoSizeText(
                                              'You are not logged in.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                      color:
                                                          ConstantsVar.appColor,
                                                      border: const Border(
                                                        top: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        bottom: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        left: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        right: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: LoadingButton(
                                                        color: Colors.black,
                                                        loadingWidget:
                                                            const SpinKitCircle(
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                        height: 12.w,
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  const LoginScreen(
                                                                screenKey:
                                                                    'My Account',
                                                              ),
                                                            ),
                                                          );
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
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 16.0,
                                                    ),
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          Colors.black,
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                              color:
                                                                  ConstantsVar
                                                                      .appColor,
                                                            ),
                                                          ),
                                                        ),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () async {
                                                        Future.delayed(
                                                          const Duration(
                                                            milliseconds: 90,
                                                          ),
                                                          () => Navigator.of(
                                                                  context)
                                                              .push(
                                                            CupertinoPageRoute(
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const ChangePassword(),
                                    ));
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.w,
                                  horizontal: 8.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Card(
                                      child: Icon(
                                        Icons.password,
                                        color: ConstantsVar.appColor,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: AutoSizeText(
                                        'change password'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              ConstantsVar.prefs.getString('userId') == null
                                  ? false
                                  : true,
                          child: DelayedDisplay(
                            delay: const Duration(
                              milliseconds: 70,
                            ),
                            child: InkWell(
                              onTap: () async {
                                Platform.isAndroid
                                    ? showMaterialDialogBox(
                                        context: context,
                                      )
                                    : showCupertinoAlertaDialog(
                                        context: context,
                                      );
                              },
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.w,
                                    horizontal: 8.w,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Card(
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color: ConstantsVar.appColor,
                                          size: 34,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: AutoSizeText(
                                          'Delete Account'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            onTap: () async {
                              ConstantsVar.prefs =
                                  await SharedPreferences.getInstance();
                              var customerId =
                                  ConstantsVar.prefs.getString('userId');

                              if (customerId == null || customerId == '') {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      bottom: true,
                                      maintainBottomViewPadding: true,
                                      child: Container(
                                        width: 100.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 5.h),
                                        height: 27.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AutoSizeText(
                                              'You are not logged in.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                      color:
                                                          ConstantsVar.appColor,
                                                      border: const Border(
                                                        top: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        bottom: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        left: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                        right: BorderSide(
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: LoadingButton(
                                                        color: Colors.black,
                                                        loadingWidget:
                                                            const SpinKitCircle(
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                        height: 12.w,
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  const LoginScreen(
                                                                screenKey:
                                                                    'My Account',
                                                              ),
                                                            ),
                                                          );
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
                                                Expanded(
                                                  child: Container(
                                                    height: 12.w,
                                                    width: 30.w,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 16.0,
                                                    ),
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          Colors.black,
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side:
                                                                const BorderSide(
                                                              color:
                                                                  ConstantsVar
                                                                      .appColor,
                                                            ),
                                                          ),
                                                        ),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () async {
                                                        Future.delayed(
                                                          const Duration(
                                                            milliseconds: 90,
                                                          ),
                                                          () => Navigator.of(
                                                                  context)
                                                              .push(
                                                            CupertinoPageRoute(
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const OrderReturnDetailScreen(),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.w,
                                  horizontal: 8.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Card(
                                      child: Icon(
                                        HeartIcon.order,
                                        color: ConstantsVar.appColor,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    AutoSizeText(
                                      'Return Request(s)'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 5.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  checkBackSwipe(DragUpdateDetails dragDetails) {
    if (dragDetails.delta.direction <= 0) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => MyHomePage(
              pageIndex: 4,
            ),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  showCupertinoAlertaDialog({
    required BuildContext context,
  }) {
    CupertinoDialogAction _yesButton = CupertinoDialogAction(
      child: const Text("YES"),
      onPressed: () {
        CustomProgressDialog _progress = CustomProgressDialog(context,
            loadingWidget: const SpinKitRipple(
              color: ConstantsVar.appColor,
              size: 50,
            ));
        _progress.show();
        ApiCalls.deleteAccount().then((val) {
          _progress.dismiss();
          Navigator.maybePop(context);

          if (val == 'success') {
            clearUserDetails();
            Phoenix.rebirth(context);
          }
        });
        Navigator.of(context).pop();
      },
    );

    CupertinoDialogAction _cancelButton = CupertinoDialogAction(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("THE One Mobile App"),
        content: const Text(
            "Are you sure you want to delete your account\? If you click on \"Yes\" please note your account will be deleted permanently for THE One website and mobile apps."),
        actions: <Widget>[
          _yesButton,
          _cancelButton,
        ],
      ),
    );
  }

  showMaterialDialogBox({
    required BuildContext context,
  }) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        CustomProgressDialog _progress = CustomProgressDialog(context,
            loadingWidget: const SpinKitRipple(
              color: ConstantsVar.appColor,
              size: 50,
            ));
        _progress.show();
        ApiCalls.deleteAccount().then((val) {
          _progress.dismiss();
          Navigator.maybePop(context);

          if (val == 'success') {
            clearUserDetails();
            Phoenix.rebirth(context);
          }
        });
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("THE One Mobile App"),
      content: const Text(
          "Are you sure you want to delete your account\? If you click on \"Yes\" please note your account will be deleted permanently for THE One website and mobile apps."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
    await secureStorage.deleteAll();
  }
}
