// To parse this JSON data, do
//
//     final adsResponse = adsResponseFromJson(jsonString);

import 'dart:convert';

AdsResponse adsResponseFromJson(String str) =>
    AdsResponse.fromJson(json.decode(str));

String adsResponseToJson(AdsResponse data) => json.encode(data.toJson());

class AdsResponse {
  AdsResponse({
    required this.status,
    required this.message,
    required this.active,
    required this.responseData,
    required this.intervalTime,
  });

  String status;
  dynamic message;
  bool active;
  String responseData;
  int intervalTime;

  factory AdsResponse.fromJson(Map<String, dynamic> json) => AdsResponse(
        status: json["status"],
        message: json["Message"],
        active: json["Active"],
        responseData: json["ResponseData"] ?? 'No Data Available',
        intervalTime: json['interval'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "Active": active,
        "ResponseData": responseData,
      };
}
