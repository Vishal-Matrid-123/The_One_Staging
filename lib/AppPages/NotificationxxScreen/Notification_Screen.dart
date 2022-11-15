import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class NotificationClass extends StatefulWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  State<NotificationClass> createState() => _NotificationClassState();
}

class _NotificationClassState extends State<NotificationClass> {
  List<NotificationClass> myNotifications = [];
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('UserNotifications')
      .orderBy('Time', descending: true)
      .snapshots();

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
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          return buildListTile(snapshot.data!.docs[index]);
                        },
                      ),
                    );
                  }
                }
              },
              stream: _stream,
            )));
  }

  Card buildListTile(DocumentSnapshot doc) {
    return Card(
      child: Container(
        height: 16.h,
        child: Stack(
          children: [
            ListTile(
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
                  doc['Title'] ?? '',
                  style: TextStyle(
                    fontSize: 4.5.w,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              subtitle: Padding(
                child: AutoSizeText(
                  doc['Desc'],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: 3,
                ),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              // trailing: ,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: AutoSizeText(
                  getTimefromTimeStamp(
                    timestamp: doc['Time'],
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getTimefromTimeStamp({required Timestamp timestamp}) {
    final DateTime date = timestamp.toDate();

    return DateFormat('dd-MM-yyyy hh:mm a').format(date.toLocal());
  }
}
