import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/ConstantVariables.dart';
import 'main.dart';
import 'new_apis_func/cofig/app_config.dart';
import 'new_apis_func/services/background_fcm_services.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final remoteConfig = FirebaseRemoteConfig.instance;
Color systemColor = Colors.black;
const kFCMVApiKey =
    'BEk4Ih_PMitirti5swgq1MBKTb9kbcSr5SJl9n-92EncoKLi4Pl3ds2bopIBou7JRkkKMDDX4uSsgld4tN7cb9g';
// FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//
// Future<void> initDynamicLinks() async {
//   dynamicLinks.onLink.listen((dynamicLinkData) async {
//     await _handleDeepLink(dynamicLinkData);
//     Fluttertoast.showToast(msg: 'sdfsdf');
//   }).onError((error) {
//     print('onLink error');
//     print(error.message);
//   });
// }
// // void handleDynamicLinks() async {
// //   ///To bring INTO FOREGROUND FROM DYNAMIC LINK.
// //   // dynamicLinks.onLink.;
// //
// //   final PendingDynamicLinkData? data =
// //   await dynamicLinks.getInitialLink();
// //   _handleDeepLink(data);
// // }
//
// // bool _deeplink = true;
// // _handleDeepLink(PendingDynamicLinkData? data) async {
// //   final Uri? deeplink = data!.link;
// //   if (deeplink != null) {
// //     print('Handling Deep Link | deepLink: $deeplink');
// //   }
// // }

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  final reference =
      FirebaseFirestore.instance.collection('THE_One_Staging_Notifications');
  String _imageUrlIOS = Platform.isIOS
      ? await message.notification!.apple!.imageUrl ?? ''
      : await message.notification!.android!.imageUrl ?? '';

  String _notificationDesc = message.notification?.body ?? '';
  String _notificationTitle = message.notification?.title ?? '';

  bool isAlreadyExisted = false;
  QuerySnapshot _query = await reference
      .where('Title', isEqualTo: message.notification!.title)
      .get();
  if (_query.docs.length > 0) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
        _query.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

    for (QueryDocumentSnapshot<Map<String, dynamic>> element in list) {
      String _title = element['Title'];
      String _desc = element['Desc'];
      Timestamp time = element['Time'];
      print('Time Difference Id>>>>' +
          DateTime.now().difference(time.toDate()).inHours.toString());

      if (_title.toLowerCase().contains(_notificationTitle.toLowerCase()) &&
          DateTime.now().difference(time.toDate()).inHours < 6 &&
          _desc.toLowerCase().contains(_notificationDesc.toLowerCase())) {
        isAlreadyExisted = true;

        print('Existed');
        break;
      } else {
        print('Not Existed');
      }
    }

    // the ID exists

  }

  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch),
    'Image': _imageUrlIOS
  };

  if (isAlreadyExisted == true) {
  } else {
    reference.doc().set(data);
  }
  // reference.doc().set(data);
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();
      // NotificationService().initializePlatformNotifications();
      // FirebaseApp firebaseApp = Fireb
      FlutterNativeSplash.remove();
      Platform.isIOS
          ? await Firebase.initializeApp(
              options: FirebaseOptions(
              appId: '1:602261305319:ios:a3656df389f8dc630aef42',
              apiKey: 'AIzaSyBdCZWrBcsLo2M56yLVrCa_IZ6u0DS3NA4',
              projectId: 'the-one-staging-6',
              messagingSenderId: '602261305319',
            ))
          : await Firebase.initializeApp();


      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(minutes: 1),
      //   minimumFetchInterval: const Duration(seconds: 10),
      // ));
      //
      // await remoteConfig.fetchAndActivate();
      // Map<String, RemoteConfigValue> val = await remoteConfig.getAll();
      // print('Remote config val>>' + val['default_color_set']!.asString());
      // systemColor = fromHex(jsonDecode(
      //     val['default_color_set']!.asString())['default_color_for_system']);
      // initDynamicLinks();
      FirebaseMessaging.onBackgroundMessage(
          (message) => _messageHandler(message));
      FCMBackgroundService.initializeService();

      FirebaseMessaging _message = FirebaseMessaging.instance;
      // var token = await _message.getToken(vapidKey: kFCMVApiKey);
      // _message.subscribeToTopic("topic");
      // print('FCM Token>>' + token!);

      ConstantsVar.prefs = await SharedPreferences.getInstance();
      ConstantsVar.prefs.setBool('isFirstTime', true);

      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == true) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      } else {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }

      GestureBinding.instance.resamplingEnabled = true;

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
            .then((_) async {
          FirebaseMessaging.instance;

          FirebaseMessaging.onMessage.listen((event) {
            _messageHandler(event);
          });

          // ErrorWidget.builder = (error) => ErrorWidget.withDetails(
          //       message: error.exception.toString(),
          //     );
          // // ErrorClass(data: error.exception.toString());

          FirebaseAnalytics analytics = FirebaseAnalytics.instance;
          FirebaseAnalyticsObserver observer =
              FirebaseAnalyticsObserver(analytics: analytics);
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: fromHex('#948a7e'),
              //or set color with: Color(0xFF0000FF)
              systemNavigationBarColor: fromHex('#948a7e')));
          changeStatusColor(fromHex('#948a7e'));
          changeNavigationColor(fromHex('#948a7e'));
          var configuredApp = AppConfig(
            child: MainApp(
              requiredBanner: true,
              analytics: analytics,
              observer: observer,
            ),
            appTitle: 'THE One Development',
            buildFlavor: 'Development',
            databaseTableName: 'THE_One_Staging_Notifications',
          );

          runApp(configuredApp);
        });
      });
    },
    (error, stack) {
      Logger().d(error.toString());
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
