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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/notification_service.dart';

import 'Constants/ConstantVariables.dart';
import 'main.dart';
import 'new_apis_func/cofig/app_config.dart';
import 'new_apis_func/services/background_fcm_services.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const kFCMVApiKey =
    'BEk4Ih_PMitirti5swgq1MBKTb9kbcSr5SJl9n-92EncoKLi4Pl3ds2bopIBou7JRkkKMDDX4uSsgld4tN7cb9g';

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  final reference =
      FirebaseFirestore.instance.collection('THE_One_Staging_Notifications');
  String _imageUrlIOS = Platform.isIOS
      ? await message.notification!.apple!.imageUrl ?? ''
      : await message.notification!.android!.imageUrl ?? '';
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
    'Time': Timestamp.fromDate(_now),
    'Image': _imageUrlIOS
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
      Timestamp time = element['Time'];
      print('Element Id>>>>' + element.id);
      print('Time Difference Id>>>>' +
          DateTime.now().difference(time.toDate()).inHours.toString());

      if (_title.toLowerCase().contains(_notificationTitle.toLowerCase()) &&
          DateTime.now().difference(time.toDate()).inHours < 24&&
          _desc.toLowerCase().contains(_notificationDesc.toLowerCase())) {
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

Future<String?> _downloadAndSavePicture(String? url, String fileName) async {
  if (url == null) return null;
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();
      // NotificationService().initializePlatformNotifications();
      // FirebaseApp firebaseApp = Fireb
      Platform.isIOS
          ? await Firebase.initializeApp(
              options: FirebaseOptions(
              appId: '1:602261305319:ios:a3656df389f8dc630aef42',
              apiKey: 'AIzaSyBdCZWrBcsLo2M56yLVrCa_IZ6u0DS3NA4',
              projectId: 'the-one-staging-6',
              messagingSenderId: '602261305319',
            ))
          : await Firebase.initializeApp();

      FirebaseMessaging.instance.requestPermission();

      // FirebaseMessaging.onMessage.listen((event) async {
      //   String _imageUrlIOS = await event.notification!.apple!.imageUrl ?? '';
      //   print('Image Url IOS >>>' + _imageUrlIOS);
      //   NotificationService().localNotifications.show(
      //       12,
      //       event.notification!.title,
      //       event.notification!.body,
      //       );
      // });
      FirebaseMessaging.onBackgroundMessage(
          (message) => _messageHandler(message));
      FCMBackgroundService.initializeService();
      // await NotificationController.initializeLocalNotifications(
      //     debug: kDebugMode);
      // await NotificationController.initializeRemoteNotifications(
      //     debug: kDebugMode);
      // await NotificationController.getInitialNotificationAction();
      // NotificationController.resetBadge();

      FirebaseMessaging _message = FirebaseMessaging.instance;
      var token = await _message.getToken(vapidKey: kFCMVApiKey);

      print('FCM Token>>' + token!);

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

          ErrorWidget.builder = (error) => ErrorWidget.withDetails(
                message: error.exception.toString(),
              );
          // ErrorClass(data: error.exception.toString());

          FirebaseAnalytics analytics = FirebaseAnalytics.instance;
          FirebaseAnalyticsObserver observer =
              FirebaseAnalyticsObserver(analytics: analytics);

          var configuredApp = AppConfig(
            child: MainApp(
                requiredBanner: true, analytics: analytics, observer: observer),
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
