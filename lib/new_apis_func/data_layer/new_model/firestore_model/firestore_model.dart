
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class FirestoreModel {
  final String title, desc,  timeStamp;
final dynamic imageUrl;
  FirestoreModel(
      {required this.title,
      required this.desc,
      required this.imageUrl,
      required this.timeStamp});

  factory FirestoreModel.fromJson({required Map<String, dynamic> json}) =>
      FirestoreModel(
        title: json['Title'] ?? '',
        desc: json['Desc'] ?? '',
        imageUrl: json.containsKey('Image')?json['Image'] : null,
        timeStamp:
            getTimefromTimeStamp(timestamp: json['Time'] as Timestamp) ??
                '',
      );

  Map<String, dynamic> toJson() => {
        'Title': title,
        'Desc': desc,
        'Image': imageUrl,
        'Time': getTimestamp(
          date: DateTime.parse(
            timeStamp,
          ),
        )
      };
}

String getTimefromTimeStamp({required Timestamp timestamp}) {
  final DateTime date = timestamp.toDate();

  return DateFormat('dd-MM-yyyy hh:mm a').format(date);
}

Timestamp getTimestamp({required DateTime date}) => Timestamp.fromDate(date);
