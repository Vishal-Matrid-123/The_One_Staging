// To parse this JSON data, do
//
//     final guestCustomerResponse = guestCustomerResponseFromJson(jsonString);

import 'dart:convert';

GuestCustomerResponse guestCustomerResponseFromJson(String str) =>
    GuestCustomerResponse.fromJson(json.decode(str));

String guestCustomerResponseToJson(GuestCustomerResponse data) =>
    json.encode(data.toJson());

class GuestCustomerResponse {
  GuestCustomerResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  String message;
  ResponseData responseData;

  factory GuestCustomerResponse.fromJson(Map<String, dynamic> json) =>
      GuestCustomerResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: ResponseData.fromJson(json["ResponseData"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData.toJson(),
      };
}

class ResponseData {
  ResponseData({
    required this.customerId,
    required this.customerGuid,
    this.username,
    this.email,
    required this.hasShoppingCartItems,
    this.registeredInStoreId,
  });

  int customerId;
  String customerGuid;
  String? username;
  String? email;
  bool hasShoppingCartItems;
  int? registeredInStoreId;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
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
