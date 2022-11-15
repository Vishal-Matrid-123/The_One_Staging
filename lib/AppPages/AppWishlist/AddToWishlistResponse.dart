// To parse this JSON data, do
//
//     final addToWishlist = addToWishlistFromJson(jsonString);

import 'dart:convert';

AddToWishlist addToWishlistFromJson(String str) =>
    AddToWishlist.fromJson(json.decode(str));

String addToWishlistToJson(AddToWishlist data) => json.encode(data.toJson());

class AddToWishlist {
  AddToWishlist({
    required this.warning,
    required this.result,
    required this.error,
  });

  List<dynamic> warning;
  String result;
  dynamic error;

  factory AddToWishlist.fromJson(Map<String, dynamic> json) => AddToWishlist(
        warning: json["warning"],
        result: json["result"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "warning": warning,
        "result": result,
        "error": error,
      };
}
