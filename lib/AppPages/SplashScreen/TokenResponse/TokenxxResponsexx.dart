// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) =>
    TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  TokenResponse({
    required this.tokenId,
    required this.expiryTime,
    required this.cutomer,
    required this.customProperties,
  });

  String tokenId;
  DateTime expiryTime;
  Cutomer cutomer;
  CustomProperties customProperties;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        tokenId: json["tokenId"],
        expiryTime: DateTime.parse(json["ExpiryTime"]),
        cutomer: Cutomer.fromJson(json["cutomer"]),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "tokenId": tokenId,
        "ExpiryTime": expiryTime.toIso8601String(),
        "cutomer": cutomer.toJson(),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class Cutomer {
  Cutomer({
    required this.customerId,
    required this.customerGuid,
    this.username,
    this.email,
    required this.hasShoppingCartItems,
    required this.registeredInStoreId,
  });

  int customerId;
  String customerGuid;
  dynamic username;
  dynamic email;
  bool hasShoppingCartItems;
  int registeredInStoreId;

  factory Cutomer.fromJson(Map<String, dynamic> json) => Cutomer(
        customerId: json["CustomerId"],
        customerGuid: json["CustomerGuid"],
        username: json["Username"],
        email: json["Email"],
        hasShoppingCartItems: json["HasShoppingCartItems"],
        registeredInStoreId: json["RegisteredInStoreId"],
      );

  Map<String, dynamic> toJson() => {
        "CustomerId": customerId,
        "CustomerGuid": customerGuid,
        "Username": username,
        "Email": email,
        "HasShoppingCartItems": hasShoppingCartItems,
        "RegisteredInStoreId": registeredInStoreId,
      };
}
