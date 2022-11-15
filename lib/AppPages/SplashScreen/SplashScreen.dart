import 'dart:convert';
import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/SplashScreen/TokenResponse/TokenxxResponsexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/new_apis_func/presentation_layer/screens/store_selection_screen/store_selection_screen.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String name = "MyAssets/logo.png";
  var _guestCustomerID = '';
  var _guestGUID = "";

  bool shouldScaleDown = true;
  final width = 200.0;
  final height = 300.0;
  late AnimationController animationController;
  Animation? animation;
  var isVisible = false;
  NewApisProvider _provider = NewApisProvider();

  Future initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    try {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      } else if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.authorized) {
        await FacebookAppEvents().setAutoLogAppEventsEnabled(true);
        await FacebookAppEvents().setAdvertiserTracking(enabled: true);
      } else if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.restricted) {
        Fluttertoast.showToast(
            msg: 'Permission Restricted', toastLength: Toast.LENGTH_LONG);
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: 'Something Went Wrong');
    }
    if (ConstantsVar.prefs.getStringList('RecentProducts') == null) {
      ConstantsVar.prefs.setStringList('RecentProducts', []);
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation!.addListener(() => setState(() {}));
    animationController.forward();
    final x = Provider.of<NewApisProvider>(context, listen: false);
    getCheckNotificationPermStatus();
    printDate();
    initPlugin()
        // ;
        // initSecurityState()
        .whenComplete(
      () async {
        Future.delayed(Duration(seconds: 3));

        isDeviceSecure == true
            ? getLocation().whenComplete(
                () async {
                  {
                    await x.checkAppUpdate(ctx: context).then((v) async {
                      _guestCustomerID =
                          ConstantsVar.prefs.getString('guestCustomerID') ?? "";

                      if ((_guestCustomerID == '' ||
                              _guestCustomerID.toString().isEmpty) &&
                          await ConstantsVar.prefs.getString(kExpireDateKey) ==
                              null) {
                        // Fluttertoast.showToast(
                        //     msg:
                        //         'Expire Date and Customer ID  is not available ');
                        await ApiCalls.getApiTokken(context).then(
                          (value) async {
                            TokenResponse myResponse =
                                TokenResponse.fromJson(jsonDecode(value));
                            _guestCustomerID =
                                myResponse.cutomer.customerId.toString();
                            _guestGUID = myResponse.cutomer.customerGuid;
                            ConstantsVar.prefs
                                .setString('guestCustomerID', _guestCustomerID);
                            ConstantsVar.prefs
                                .setString('guestGUID', _guestGUID);
                            ConstantsVar.prefs.setString('sepGuid', _guestGUID);
                            ConstantsVar.prefs.setString(kExpireDateKey,
                                myResponse.expiryTime.toIso8601String());
                          },
                        );
                        if (_provider.isLocationAllow == false ||
                            _provider.isPermanentDenied == true ||
                            (_provider.isPermanentDenied == false &&
                                _provider.isLocationAllow == false)) {
                          if (await secureStorage.read(
                                  key: kselectedStoreIdKey) ==
                              null) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const StoreSelectionScreen()),
                                (route) => false);
                          } else {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyApp()));
                          }
                        } else {
                          if (mounted)
                            _provider.setLocationFunction(context: context);
                        }
                      } else if (_guestCustomerID.toString().isNotEmpty &&
                          await ConstantsVar.prefs.getString(kExpireDateKey) ==
                              null) {
                        await ApiCalls.getApiTokken(context).then(
                          (value) async {
                            TokenResponse myResponse =
                                TokenResponse.fromJson(jsonDecode(value));

                            ConstantsVar.prefs.setString(kExpireDateKey,
                                myResponse.expiryTime.toIso8601String());
                          },
                        );
                        if (_provider.isLocationAllow == false ||
                            _provider.isPermanentDenied == true ||
                            (_provider.isPermanentDenied == false &&
                                _provider.isLocationAllow == false)) {
                          if (await secureStorage.read(
                                  key: kselectedStoreIdKey) ==
                              null) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const StoreSelectionScreen()),
                                (route) => false);
                          } else {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyApp()));
                          }
                        } else {
                          _provider.setLocationFunction(context: context);
                        }
                      } else {
                        /*Last Condition*/

                        String expDate = await ConstantsVar.prefs
                                .getString(kExpireDateKey) ??
                            '';
                        List<String> splitDateAndTime = expDate.split('T');
                        List<String> splitDate = [splitDateAndTime[0]];
                        List<String> splitTime = [
                          splitDateAndTime[1].split('.')[0]
                        ];
                        // splitDate.addAll(splitTime);
                        log(jsonEncode(splitDate[0].split(':')));
                        int day = int.parse(splitDate[0].split('-')[2]);
                        int month = int.parse(splitDate[0].split('-')[1]);
                        int year = int.parse(splitDate[0].split('-')[0]);
                        int hours = int.parse(splitTime[0].split(':')[0]);
                        int minutes = int.parse(splitTime[0].split(':')[1]);
                        int seconds = int.parse(splitTime[0].split(':')[2]);

                        final date1 =
                            DateTime(year, month, day, hours, minutes, seconds);
                        final date2 = DateTime.now();

                        if (date1.compareTo(date2) == 0 ||
                            date1.compareTo(date2) < 0) {
                          log("Hitting Api Again");
                          await ApiCalls.getApiTokken(context)
                              .then((value) async {
                            TokenResponse myResponse =
                                TokenResponse.fromJson(jsonDecode(value));

                            ConstantsVar.prefs.setString(kExpireDateKey,
                                myResponse.expiryTime.toIso8601String());

                            if (_provider.isLocationAllow == false ||
                                _provider.isPermanentDenied == true ||
                                (_provider.isPermanentDenied == false &&
                                    _provider.isLocationAllow == false)) {
                              if (await secureStorage.read(
                                      key: kselectedStoreIdKey) ==
                                  null) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const StoreSelectionScreen()),
                                    (route) => false);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MyApp()));
                              }
                            } else {
                              if (mounted)
                                _provider.setLocationFunction(context: context);
                            }
                          });
                        }

                        if (date1.compareTo(date2) > 0) {
                          log("Birthday  is after Current Date");
                          if (_provider.isLocationAllow == false ||
                              _provider.isPermanentDenied == true ||
                              (_provider.isPermanentDenied == false &&
                                  _provider.isLocationAllow == false)) {
                            if (await secureStorage.read(
                                    key: kselectedStoreIdKey) ==
                                null) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const StoreSelectionScreen()),
                                  (route) => false);
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MyApp()));
                            }
                          } else {
                            if (mounted)
                              _provider.setLocationFunction(context: context);
                          }
                        }
                        log(
                          'Exp Date Time>>>>${date1.toIso8601String()}>>>}',
                        );

                        printDate();
                      }
                    });
                  }
                },
              )
            : Fluttertoast.showToast(msg: 'Device is not Secure');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return Scaffold(
          body: SafeArea(
            top: true,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: animation!.value * width,
                    height: animation!.value * height,
                    child: Hero(
                      tag: 'HomeImage',
                      child: Image.asset(name),
                      transitionOnUserGestures: true,
                      placeholderBuilder: (context, _, widget) {
                        return SizedBox(
                          height: 15.w,
                          width: 15.w,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  const SpinKitRipple(
                    color: Colors.red,
                    size: 60,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (ConstantsVar.prefs.getString('userId') != null) {
      ConstantsVar.customerID = ConstantsVar.prefs.getString('userId')!;
    }

    return ConstantsVar.customerID;
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. '
            'Can we continue to use your data to tailor best recommendations for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you best recommendations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("I'll decide later"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow tracking'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> initPlugin() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      } else if (status == TrackingStatus.authorized) {
        await FacebookAppEvents().setAutoLogAppEventsEnabled(true);
        await FacebookAppEvents().setAdvertiserTracking(enabled: true);
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      } else if (status == TrackingStatus.denied) {
        await FacebookAppEvents().setAutoLogAppEventsEnabled(false);
        await FacebookAppEvents().setAdvertiserTracking(enabled: false);
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  void printDate() {
    // final birthday = DateTime(2022, 11, 01);
    final birthday2 = DateTime(2023, 11, 01);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday2);
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    if (birthday2.compareTo(date2) == 0) {
      print("Both date time are at same moment.");
    }

    if (birthday2.compareTo(date2) < 0) {
      print("Birthday is before Current Date");
    }

    if (birthday2.compareTo(date2) > 0) {
      print("Birthday  is after Current Date");
    }
    log(
      'Current Date Time>>>>$difference',
    );
  }

  Future<String> getCheckNotificationPermStatus() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          requestPermission();
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return '';
      }
    });
  }

  bool isDeviceSecure = true;

  getLocation() async {
    _provider = Provider.of<NewApisProvider>(context, listen: false);
    // _provider.checkLocationPermission();
    _provider.getLocation(context: context);
  }

// and lack of delete
}

class LocationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LocationScreen({Key? key}) : super(key: key);
  final color1 = color.entries.firstWhere((element) => element.key == 900);
  final color2 = color.entries.firstWhere((element) => element.key == 600);
  final color3 = color.entries.firstWhere((element) => element.key == 500);
 final bool passError = true;

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            color1.value,
            color2.value,
            color3.value,
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Developer Login".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.5.w,
                              fontWeight: FontWeight.w800),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 7.w),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: color1.value,
                                        blurRadius: 20,
                                        offset: const Offset(0, 10))
                                  ]),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextFormField(
                                        validator: (userName) {
                                          if (!userName!
                                              .toLowerCase()
                                              .trim()
                                              .contains(kdeveloperUserName
                                                  .toLowerCase())) {
                                            return "Please Enter Correct UserName";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "UserName",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: Consumer<NewApisProvider>(
                                        builder: (_, val, c) => Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                                obscureText: val.passwordObs,
                                                validator: (password) {
                                                  if (!password!
                                                      .toLowerCase()
                                                      .trim()
                                                      .contains(
                                                          kdeveloperPassword
                                                              .toLowerCase())) {
                                                    return "Please Enter Correct Password";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "Password",
                                                        hintStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border:
                                                            InputBorder.none),
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
                                                    final _provider = Provider
                                                        .of<NewApisProvider>(
                                                            context,
                                                            listen: false);
                                                    _provider.changePassField();
                                                  },
                                                  isChecked: val.passwordObs,
                                                  checkedWidget: const Center(
                                                    child: Icon(
                                                      Icons.visibility_off,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  uncheckedWidget: const Center(
                                                    child: Icon(
                                                      Icons.visibility,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.6,
                              GestureDetector(
                                onTap: () {
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => MyApp(),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 15.w,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: color1.value),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.w,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..add(AniProps.translateY, Tween(begin: -30.0, end: 0.0),
          const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AniProps.translateY)),
            child: child),
      ),
    );
  }
}

class FraudDetectionScreen extends StatelessWidget {
  const FraudDetectionScreen({Key? key, required String message})
      : _message = message,
        super(key: key);
  final String _message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantsVar.appColor,
        toolbarHeight: size.width * 0.18,
        centerTitle: true,
        title: Image.asset(
          'MyAssets/logo.png',
          width: size.width * 0.15,
          height: size.width * 0.15,
        ),
      ),
      body: Center(
        child: Text(
          "Cannot run this app on this device.\n$_message",
          textAlign: TextAlign.center,
          style: TextStyle(
            shadows: <Shadow>[
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
            ],
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
