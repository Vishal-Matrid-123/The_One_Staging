// To parse this JSON data, do
//
//     final newCategoryResponse = newCategoryResponseFromJson(jsonString);

import 'dart:convert';

NewCategoryResponse newCategoryResponseFromJson(String str) =>
    NewCategoryResponse.fromJson(json.decode(str));

String newCategoryResponseToJson(NewCategoryResponse data) =>
    json.encode(data.toJson());

class NewCategoryResponse {
  NewCategoryResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final String responseData;
  final int storeId;

  factory NewCategoryResponse.fromJson(Map<String, dynamic> json) =>
      NewCategoryResponse(
        status: json["status"],
        message: json["Message"],
        responseData: json["ResponseData"] ?? 'No Data Available',
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "ResponseData": responseData,
        "StoreId": storeId,
      };
}
// To parse this JSON data, do
//
//     final newCategoryListResponse = newCategoryListResponseFromJson(jsonString);
