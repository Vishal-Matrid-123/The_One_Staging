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
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';

import 'Constants/ConstantVariables.dart';
import 'main.dart';
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
    'Image': Platform.isAndroid
        ? message.notification!.android!.imageUrl
        : message.notification!.apple!.imageUrl
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
      await  secureStorage.write(key: 'isFirstTime', value: 'value');
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
