import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/CartBadgeCounter/SearchModel/SearchNotifier.dart';

import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';
import 'main_dev.dart';
import 'new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const kFCMVApiKey =
    'BF27tL7I4pys6pW2j2JZUTL6zQNJxcfQZTsHQKilR_26OV6ua1xt0VdaPrPP1mEcSSQvOUZd0j911kaeXzFZhFQ';

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  final reference =
      FirebaseFirestore.instance.collection('UserNotificationsStaging');
  DateTime _now = DateTime.now();
  DateTime _current = DateTime(_now.year, _now.month, _now.day);
  DateTime _notificationTime = message.sentTime!;
  String _notificationDesc = message.notification?.body ?? '';
  String _notificationTitle = message.notification?.title ?? '';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // bool isExistedAlready = await reference.snapshots().any((element) {
  //
  //   });
  String fDate = formatter.format(_notificationTime);
  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': Timestamp.fromDate(message.sentTime!),
    'Image': message.notification!.android!.imageUrl
  };
  bool isAlreadyExisted = false;

  late StreamSubscription sub;
  sub = await reference.snapshots().listen((event) {
    QuerySnapshot<Map<String, dynamic>> dataSnapshot = event;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list = dataSnapshot.docs;
    String id = '';
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in list) {
      String _title = element['Title'];
      String _desc = element['Desc'];
      id = element.id;
      print(element.id);

      print('Title>>>>>>>>' +
          _title +
          'Notification Title >>>>>>' +
          _notificationTitle +
          'Notification Date>>>>>>>' +
          fDate +
          'Current Date>>>>>>>>>>>' +
          _current.toString() +
          'difference>>>' +
          formatter.format(element['Time'].toDate()));
      if (_title.toLowerCase().contains(_notificationTitle.toLowerCase()) &&
          _desc.toLowerCase().contains(_notificationDesc.toLowerCase()) &&
          formatter.format(element['Time'].toDate()).contains(fDate)) {
        isAlreadyExisted = true;
        print('Existed');
        break;
      }
    }
    if (isAlreadyExisted == true) {
      reference.doc(id).delete();
      // reference.snapshots()
      reference.doc().set(data);
      sub.cancel();
    } else {
      reference.doc().set(data);
      sub.cancel();
    }

    // list.any((element){
    //     });
    // print(isAlreadyExisted == true ? 'Title Existed' : 'Not Existed');
// isAlreadyExisted == true?break:null;
  });
  // reference.doc().set(data);
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
}

// Future<void> main() async {
//   await runZonedGuarded(
//     () async {
//       WidgetsFlutterBinding.ensureInitialized();
//       HttpOverrides.global = MyHttpOverrides();
//                                                 // FirebaseApp firebaseApp = Fireb
//
//       Platform.isIOS
//           ? await Firebase.initializeApp(
//
//               options: FirebaseOptions(
//               appId: Platform.isIOS
//                   ? '1:150803512425:ios:8d69ecbb65f9d98d7476f8'
//                   : '1:150803512425:android:40a3d7372d12e1757476f8',
//               apiKey: 'AIzaSyBoMLFhJ8ir_pT57X1qFtmYSS-CQQzoXuE',
//               projectId: 'theone-cce7f',
//               messagingSenderId: '150803512425',
//             ))
//          :  await Firebase.initializeApp();
//       //
//       // FirebaseMessaging.onBackgroundMessage(
//       //         (message) => _messageHandler(message));
//       FCMBackgroundService.initializeService();
//       await NotificationController.initializeLocalNotifications(
//           debug: kDebugMode);
//       await NotificationController.initializeRemoteNotifications(
//           debug: kDebugMode);
//       await NotificationController.getInitialNotificationAction();
//       NotificationController.resetBadge();
//
//       FirebaseMessaging _message = FirebaseMessaging.instance;
//       var token = await _message.getToken(vapidKey: kFCMVApiKey);
//       Fluttertoast.showToast(msg:'FCM Token>>' + token!,toastLength: Toast.LENGTH_LONG,);
//
//       log('FCM Token>>' + token) ;
//
//       ConstantsVar.prefs = await SharedPreferences.getInstance();
//       ConstantsVar.prefs.setBool('isFirstTime', true);
//
//       FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
//
//       FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//
//       if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == true) {
//         FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//       } else {
//         FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//       }
//
//       GestureBinding.instance.resamplingEnabled = true;
//
//       SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//           .then((_) async {
//         SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
//             .then((_) async {
//           FirebaseMessaging.instance;
//
//           FirebaseMessaging.onMessage.listen((event) {
//             _messageHandler(event);
//           });
//
//           ErrorWidget.builder =
//               (error) =>
//                   ErrorWidget.withDetails(message: error.exception.toString(),);
//                   // ErrorClass(data: error.exception.toString());
//
//
//
//         });
//       });
//     },
//     (error, stack) {
//       Logger().d(error.toString());
//       FirebaseCrashlytics.instance.recordError(error, stack);
//     },
//   );
// }

void requestPermission() async {
  await NotificationPermissions.requestNotificationPermissions();
}

var permGranted = "granted";
var permDenied = "denied";
var permUnknown = "unknown";
var permProvisional = "provisional";

const Map<int, Color> color = {
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

class MainApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final bool requiredBanner;

  const MainApp(
      {required this.analytics,
      required this.observer,
      required this.requiredBanner});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RestartWidget(
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
                debugShowCheckedModeBanner: requiredBanner,
                title: 'The One',
                navigatorObservers: [routeObserver],
                builder: (context, child) {
                  return MediaQuery(
                    child: child!,
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
                  );
                },
                home: const SplashScreen(),
                darkTheme:ThemeData(
                  appBarTheme: AppBarTheme(
                      backgroundColor: Colors.grey,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: fromHex('#948a7e'))),
                  bottomAppBarColor: fromHex('#948a7e'),
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      TargetPlatform.iOS:
                      CupertinoWillPopScopePageTransionsBuilder(),
                    },
                  ),
                  fontFamily: 'Arial',
                  primarySwatch: MaterialColor(0xFF800E4F, color),
                  primaryColor: ConstantsVar.appColor,
                ),
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                      backgroundColor: Colors.grey,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: fromHex('#948a7e'))),
                  bottomAppBarColor: fromHex('#948a7e'),
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: ZoomPageTransitionsBuilder(),
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
    );
  }
}
changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);

  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}

changeNavigationColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setNavigationBarColor(color, animate: true);
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}
