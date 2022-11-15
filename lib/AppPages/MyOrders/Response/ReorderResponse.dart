// To parse this JSON data, do
//
//     final reorderResponse = reorderResponseFromJson(jsonString);

import 'dart:convert';

class ReorderResponse {
  ReorderResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  List<dynamic> message;
  dynamic responseData;

  factory ReorderResponse.fromRawJson(String str) =>
      ReorderResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReorderResponse.fromJson(Map<String, dynamic> json) =>
      ReorderResponse(
        status: json["Status"],
        message: List<dynamic>.from(json["Message"].map((x) => x)),
        responseData: json["ResponseData"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": List<dynamic>.from(message.map((x) => x)),
        "ResponseData": responseData,
      };
}
