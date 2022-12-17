// To parse this JSON data, do
//
//     final sharedResposnse = sharedResposnseFromJson(jsonString);

import 'dart:convert';

SharedResposnse sharedResposnseFromJson(String str) =>
    SharedResposnse.fromJson(json.decode(str));

String sharedResposnseToJson(SharedResposnse data) =>
    json.encode(data.toJson());

class SharedResposnse {
  SharedResposnse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  String message;
  dynamic responseData;

  factory SharedResposnse.fromJson(Map<String, dynamic> json) =>
      SharedResposnse(
        status: json["status"],
        message: json["Message"],
        responseData: json["ResponseData"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "ResponseData": responseData,
      };
}
