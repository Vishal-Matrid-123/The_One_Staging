// To parse this JSON data, do
//
//     final bookingResponse = bookingResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) => BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) => json.encode(data.toJson());

class BookingResponse {
  BookingResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final String message;
  final String responseData;
  final int storeId;

  factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
    status: json["status"],
    message: json["Message"],
    responseData: json["ResponseData"],
    storeId: json["StoreId"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "ResponseData": responseData,
    "StoreId": storeId,
  };
}
