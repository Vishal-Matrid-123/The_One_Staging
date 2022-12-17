// To parse this JSON data, do
//
//     final selectShippingMethodResponse = selectShippingMethodResponseFromJson(jsonString);

import 'dart:convert';

SelectShippingMethodResponse selectShippingMethodResponseFromJson(String str) =>
    SelectShippingMethodResponse.fromJson(json.decode(str));

String selectShippingMethodResponseToJson(SelectShippingMethodResponse data) =>
    json.encode(data.toJson());

class SelectShippingMethodResponse {
  SelectShippingMethodResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  String message;
  dynamic responseData;

  factory SelectShippingMethodResponse.fromJson(Map<String, dynamic> json) =>
      SelectShippingMethodResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: json["ResponseData"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData,
      };
}
