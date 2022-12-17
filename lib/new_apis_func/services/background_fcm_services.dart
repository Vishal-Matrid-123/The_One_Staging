import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class FCMBackgroundService {
  FCMBackgroundService._();

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id



    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    /// OPTIONAL when use custom notification
    ///


    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          // if you don't using custom notification, uncomment this
          FirebaseMessaging.onBackgroundMessage(_messageHandler);
        }
      }
    });
  }

  static Future<void> setFireStoreData(
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
      List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
          dataSnapshot.docs;
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
  static Future<void> _messageHandler(RemoteMessage message) async {
    print('Saving');
    await Firebase.initializeApp();
    setFireStoreData(message);
  }
}
