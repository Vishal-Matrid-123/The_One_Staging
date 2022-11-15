import 'dart:async';
import 'dart:io';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:logger/logger.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/ErrorScreen/error_screen.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/CartBadgeCounter/SearchModel/SearchNotifier.dart';

// import 'found'
import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';
import 'new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

// import 'package:flutter/services.dart' as Platform;
Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  final refrence = FirebaseFirestore.instance.collection('UserNotifications');
  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': Timestamp.fromDate(message.sentTime!)
  };
  refrence.doc().set(data);
}

Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
}

Future<void> main() async {
  // initSecurityState();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();
      Platform.isIOS
          ? await Firebase.initializeApp(
              options: FirebaseOptions(
              appId: Platform.isIOS
                  ? '1:150803512425:ios:8d69ecbb65f9d98d7476f8'
                  : '1:150803512425:android:40a3d7372d12e1757476f8',
              apiKey: 'AIzaSyB32cFMw4-1O4f1ilVc6ebUIP_VcMIETlg',
              projectId: 'theone-cce7f',
              messagingSenderId: '150803512425',
            ))
          : await Firebase.initializeApp();

      // AndroidOptions _getAndroidOptions() => const AndroidOptions(
      //   encryptedSharedPreferences: true,
      // );

      // _checkPermissions();



      FirebaseMessaging.onBackgroundMessage(_messageHandler);
      ConstantsVar.prefs = await SharedPreferences.getInstance();
      ConstantsVar.prefs.setBool('isFirstTime', true);

      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == true) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      } else {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }

      GestureBinding.instance!.resamplingEnabled = true;

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
            .then((_) async {
          FirebaseMessaging.instance;

          FirebaseMessaging.onMessage.listen((event) {
            _messageHandler(event);
          });

          ErrorWidget.builder =
              (error) => ErrorClass(data: error.exception.toString());

          FirebaseAnalytics analytics = FirebaseAnalytics.instance;
          FirebaseAnalyticsObserver observer =
              FirebaseAnalyticsObserver(analytics: analytics);
          // FirebaseMessaging.onMessage.;
          runApp(RestartWidget(
            child: BackGestureWidthTheme(
              backGestureWidth: BackGestureWidth.fraction(1 / 4),
              child: DevicePreview(
                enabled: false,
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => CartCounter(),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => NewApisProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => SearchModel(),
                    ),
                    /*Analytics Enable here*/

                    Provider<FirebaseAnalytics>.value(value: analytics),
                    Provider<FirebaseAnalyticsObserver>.value(value: observer),
                  ],
                  child: Phoenix(
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'The One',
                      builder: (context, child) {
                        return MediaQuery(
                          child: child!,
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 0.9),
                        );
                      },
                      home: const SplashScreen(),
                      darkTheme: ThemeData(
                        platform: TargetPlatform.iOS,
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                CupertinoPageTransitionsBuilder(),
                            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                          },
                        ),
                        fontFamily: 'Arial',
                        primarySwatch: MaterialColor(0xFF800E4F, color),
                        primaryColor: ConstantsVar.appColor,
                      ),
                      theme: ThemeData(
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                ZoomPageTransitionsBuilder(),
                            TargetPlatform.iOS:
                                CupertinoWillPopScopePageTransionsBuilder(),
                          },
                        ),
                        fontFamily: 'Arial',
                        primarySwatch: MaterialColor(0xFF800E4F, color),
                        primaryColor: ConstantsVar.appColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
        });
      });
    },
    (error, stack) {
      Logger().d(error.toString());
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}



void requestPermission() async {
  await NotificationPermissions.requestNotificationPermissions();
}

var permGranted = "granted";
var permDenied = "denied";
var permUnknown = "unknown";
var permProvisional = "provisional";
// void checkLocationPermission() async {
//   // const Permission _locationPermission = Permission.location;
//   bool locationStatus = false;
//   bool ispermanetelydenied = await _locationPermission.isDenied;
//   PermissionStatus _status = await _locationPermission.status;
//   switch (_status) {
//     case PermissionStatus.denied:
//       await _locationPermission.request();
//       break;
//     case PermissionStatus.restricted:
//       await openAppSettings();
//       break;
//     case PermissionStatus.granted:
//       log("Permission is granted");
//      bool  serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // Location services are not enabled don't continue
//         // accessing the position and request users of the
//         // App to enable the location services.
//         // await Geolocator
//         // await Location
//         await Location().requestService();
//
//       }
//       break;
//
//     case PermissionStatus.limited:
//       // TODO: Handle this case
//       log("Permission is limited");
//       break;
//     case PermissionStatus.permanentlyDenied:
//       // TODO: Handle this case.
//       await openAppSettings();
//       break;
//   }
//   //
//   // if (ispermanetelydenied) {
//   //   log("denied");
//   //   await openAppSettings();
//   // } else {
//   //   var locationStatu = await _locationPermission.request();
//   //   locationStatus = locationStatu.isGranted;
//   //   log(locationStatus.toString());
//   // }
// }

Future<void> initSecurityState() async {
  // final _deviceInfo = await DeviceInfoPlugin().androidInfo;
  // print(_deviceInfo.device);

  if (await FlutterJailbreakDetection.developerMode) {
    Fluttertoast.showToast(
            msg: 'Developer Mode is on. Cannot run this app on this device.')
        .then(
      (value) => Future.delayed(const Duration(seconds: 2)).whenComplete(
        () => exit(0),
      ),
    );
  }

  TalsecConfig config = TalsecConfig(
    /// For Android
    androidConfig: AndroidConfig(
      expectedSigningCertificateHash: 'eLqz+HNqpo7ayE7MUrzsffPyqTc=',
      expectedPackageName: 'com.theone.androidtheone',
    ),

    /// For iOS
    iosConfig: IOSconfig(
      appBundleId: 'com.dev.theone',
      appTeamId: '4TD6VF2SFJ',
    ),

    watcherMail: 'vishal.matrid2380@gmail.com',
  );

  /// Callbacks thrown by library

  TalsecCallback callback = TalsecCallback(
    /// For Android
    androidCallback: AndroidCallback(
      onRootDetected: () async {
        Fluttertoast.showToast(
                msg:
                    'Your Device is rooted. Cannot run this app on this device.',
                toastLength: Toast.LENGTH_LONG)
            .then(
          (value) => Future.delayed(const Duration(seconds: 2)).whenComplete(
            () => exit(0),
          ),
        );
      },
      onEmulatorDetected: () {
        Fluttertoast.showToast(
                msg:
                    'Your Device is an emulator. Cannot run this app on this device.')
            .then((value) => Future.delayed(const Duration(seconds: 2))
                .whenComplete(() => exit(0)));
      },
      onHookDetected: () {
        Fluttertoast.showToast(
                msg:
                    'Hooking Process is detected. Cannot run this app on this device.')
            .then(
          (value) => Future.delayed(const Duration(seconds: 2)).whenComplete(
            () => exit(0),
          ),
        );
      },
      onTamperDetected: () {
        // DeviceInformation _info = DeviceInformation();

        // print(_info);
        // Fluttertoast.showToast(
        //         msg: 'Oops, dude.\n Something went wrong. Try again latter.')
        //     .then(
        //   (value) => Future.delayed(const Duration(seconds: 2)).whenComplete(
        //     () => exit(0),
        //   ),
        // );
      },
      onDeviceBindingDetected: () {},
      onUntrustedInstallationDetected: () {
        Fluttertoast.showToast(
                msg:
                    'Untrusted Installation Source Detected. Cannot run this app on this device.')
            .then(
          (value) => Future.delayed(const Duration(seconds: 2)).whenComplete(
            () => exit(0),
          ),
        );
      },
    ),

    /// For iOS
    iosCallback: IOScallback(
        onRuntimeManipulationDetected: () {
          Fluttertoast.showToast(
                  msg:
                      'Runtime Manipulation Detected. Cannot run this app on this device.')
              .then((value) => Future.delayed(const Duration(seconds: 2))
                  .whenComplete(() => exit(0)));
        },
        onJailbreakDetected: () {
          Fluttertoast.showToast(
                  msg:
                      'Your Device is jailbreak. Cannot run this app on this device.')
              .then((value) => Future.delayed(const Duration(seconds: 2))
                  .whenComplete(() => exit(0)));
        },
        onSimulatorDetected: () {
          Fluttertoast.showToast(
                  msg:
                      'Your Device is a simulator. Cannot run this app on this device.')
              .then((value) => Future.delayed(const Duration(seconds: 2))
                  .whenComplete(() => exit(0)));
        },
        onMissingSecureEnclaveDetected: () {
          Fluttertoast.showToast(
                  msg:
                      'Your Device is not enclave secure. Cannot run this app on this device.')
              .then(
            (value) => Future.delayed(const Duration(seconds: 2))
                .whenComplete(() => exit(0)),
          );
        },
        onDeviceIdDetected: () {}),

    /// Debugger is common for both platforms
    onDebuggerDetected: () {
      Fluttertoast.showToast(
              msg: 'Debugging Mode is on. Cannot run this app on this device.')
          .then((value) => Future.delayed(const Duration(seconds: 2))
              .whenComplete(() => exit(0)));
    },
  );

  TalsecApp app = TalsecApp(
    config: config,
    callback: callback,
  );

  app.start();
}

const Map<int, Color> color = {
  // 10: Color.fromRGBO(255, 255, 255, 1)
  50: Color.fromRGBO(225, 17, 75, .1),
  100: Color.fromRGBO(225, 17, 75, .2),
  200: Color.fromRGBO(225, 17, 75, .3),
  300: Color.fromRGBO(225, 17, 75, .4),
  400: Color.fromRGBO(225, 17, 75, .5),
  500: Color.fromRGBO(225, 17, 75, .6),
  600: Color.fromRGBO(225, 17, 75, .7),
  700: Color.fromRGBO(225, 17, 75, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(225, 17, 75, 1),
};

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
