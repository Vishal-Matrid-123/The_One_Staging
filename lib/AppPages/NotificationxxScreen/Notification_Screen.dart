import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/cofig/app_config.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/firestore_model/firestore_model.dart';
// import 'package:untitled2/new_apis_func/presentation_layer/screens/chat_screen/chat_screen.dart';

class NotificationClass extends StatefulWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  State<NotificationClass> createState() => _NotificationClassState();
}

class _NotificationClassState extends State<NotificationClass> {
  List<NotificationClass> myNotifications = [];
  late Stream<QuerySnapshot<FirestoreModel>> _stream;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
          toolbarHeight: 18.w,
          centerTitle: true,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyApp()),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: StreamBuilder(
          builder:
              (context, AsyncSnapshot<QuerySnapshot<FirestoreModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: const SpinKitRipple(
                  color: Colors.red,
                  size: 90,
                ),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: AutoSizeText('No New Notifications'),
                );
              } else {
                return Container(
                  width: 100.w,
                  height: 100.h,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return buildListTile(snapshot.data!.docs[index].data());
                    },
                  ),
                );
              }
            }
          },
          stream: _stream,
        ),
      ),
    );
  }

  Card buildListTile(FirestoreModel doc) {
    return Card(
      child: doc.imageUrl != null
          ? Stack(
              children: [
                ExpansionTile(
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'MyAssets/logo.png',
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: AutoSizeText(
                      doc.title ?? '',
                      style: TextStyle(
                        fontSize: 4.5.w,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        child: AutoSizeText(
                          doc.desc,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          maxLines: 10,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.w),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: AutoSizeText(
                            doc.timeStamp,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  children: [
                    CachedNetworkImage(
                      imageUrl: doc.imageUrl,
                      placeholder: (context, reason) => Center(
                        child: SpinKitRipple(
                          size: 30,
                          color: ConstantsVar.appColor,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          : ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'MyAssets/logo.png',
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: AutoSizeText(
                  doc.title ?? '',
                  style: TextStyle(
                    fontSize: 4.5.w,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    child: AutoSizeText(
                      doc.desc,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: 3,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: AutoSizeText(
                        doc.timeStamp,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final counterState = AppConfig.of(context: context);
    _stream = FirebaseFirestore.instance
        .collection(counterState.databaseTableName)
        .orderBy('Time', descending: true)
        .withConverter<FirestoreModel>(
          fromFirestore: (snapshots, _) =>
              FirestoreModel.fromJson(json: snapshots.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        )
        .snapshots();
    super.didChangeDependencies();
  }
}
