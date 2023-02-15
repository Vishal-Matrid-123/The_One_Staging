import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';

import 'Constants/ConstantVariables.dart';
import 'main.dart';
import 'main_dev.dart';
import 'new_apis_func/cofig/app_config.dart';
import 'new_apis_func/services/background_fcm_services.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const kFCMVApiKey =
    'BF27tL7I4pys6pW2j2JZUTL6zQNJxcfQZTsHQKilR_26OV6ua1xt0VdaPrPP1mEcSSQvOUZd0j911kaeXzFZhFQ';

Future<void> clearSharedPreference() async {
  final prefs = await SharedPreferences.getInstance();
  if (await prefs.getString('isFirstTime') == null) {
    prefs.clear();
    await prefs.setString('isFirstTime', 'value');
    Fluttertoast.showToast(msg: 'Values reset');
  } else {
    Fluttertoast.showToast(msg: 'Value available');
  }
}

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  final reference = FirebaseFirestore.instance.collection('UserNotifications');
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
      print('Element Id>>>>' + element.id);
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
      // FirebaseApp firebaseApp = Fireb

      Platform.isIOS
          ? await Firebase.initializeApp(
              options: FirebaseOptions(
              appId: Platform.isIOS
                  ? '1:150803512425:ios:8d69ecbb65f9d98d7476f8'
                  : '1:150803512425:android:40a3d7372d12e1757476f8',
              apiKey: 'AIzaSyBoMLFhJ8ir_pT57X1qFtmYSS-CQQzoXuE',
              projectId: 'theone-cce7f',
              messagingSenderId: '150803512425',
            ))
          : await Firebase.initializeApp();
      //
      // FirebaseMessaging.onBackgroundMessage(
      //         (message) => _messageHandler(message));
      FCMBackgroundService.initializeService();
      // await NotificationController.initializeLocalNotifications(
      //     debug: kDebugMode);
      // await NotificationController.initializeRemoteNotifications(
      //     debug: kDebugMode);
      // await NotificationController.getInitialNotificationAction();
      // NotificationController.resetBadge();

      FirebaseMessaging _message = FirebaseMessaging.instance;

      ConstantsVar.prefs = await SharedPreferences.getInstance();

      if (await secureStorage.read(key: 'isFirstTime') == null) {
        secureStorage.deleteAll();
        ConstantsVar.prefs.clear();
        await secureStorage.write(key: 'isFirstTime', value: 'value');
        print('Value reset');
      }

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

          ErrorWidget.builder = (error) => ErrorWidget.withDetails(
                message: error.exception.toString(),
              );
          // ErrorClass(data: error.exception.toString());

          FirebaseAnalytics analytics = FirebaseAnalytics.instance;
          FirebaseAnalyticsObserver observer =
              FirebaseAnalyticsObserver(analytics: analytics);
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: fromHex('#948a7e'), //or set color with: Color(0xFF0000FF)
              systemNavigationBarColor:fromHex('#948a7e')
          ));
          changeStatusColor(fromHex('#948a7e'));
          changeNavigationColor(fromHex('#948a7e'));
          var configuredApp = AppConfig(
            child: MainApp(
                requiredBanner: false,
                analytics: analytics,
                observer: observer),
            appTitle: 'THE One Production',
            buildFlavor: 'Production',
            databaseTableName: 'UserNotifications',
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
