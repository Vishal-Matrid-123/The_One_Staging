import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsInitializer {
  FacebookAppEvents returnFacebookEvent() {
    return FacebookAppEvents();
  }

  FirebaseAnalytics returnFirebaseAnalytics({required BuildContext context}) {
    return Provider.of<FirebaseAnalytics>(context, listen: false);
  }
}
