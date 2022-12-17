// To parse this JSON data, do
//
//     final removeItemWishlistResponse = removeItemWishlistResponseFromJson(jsonString);

import 'dart:convert';

RemoveItemWishlistResponse removeItemWishlistResponseFromJson(String str) =>
    RemoveItemWishlistResponse.fromJson(json.decode(str));

String removeItemWishlistResponseToJson(RemoveItemWishlistResponse data) =>
    json.encode(data.toJson());

class RemoveItemWishlistResponse {
  RemoveItemWishlistResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  String message;
  dynamic responseData;

  factory RemoveItemWishlistResponse.fromJson(Map<String, dynamic> json) =>
      RemoveItemWishlistResponse(
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
