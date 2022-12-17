// To parse this JSON data, do
//
//     final addToCartResponse = addToCartResponseFromJson(jsonString);

import 'dart:convert';

AddToCartResponse addToCartResponseFromJson(String str) =>
    AddToCartResponse.fromJson(json.decode(str));

String addToCartResponseToJson(AddToCartResponse data) =>
    json.encode(data.toJson());

class AddToCartResponse {
  AddToCartResponse({
    required this.status,
    required this.message,
    this.responseData,
    required this.storeId,
  });

  final String status;
  final String message;
  dynamic responseData;
  final String storeId;

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartResponse(
        status: json["Status"],
        message: json["Message"] ?? '',
        responseData: json["ResponseData"],
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData,
        "StoreId": storeId,
      };
}
