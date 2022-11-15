// To parse this JSON data, do
//
//     final registrationResponse = registrationResponseFromJson(jsonString);

import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) =>
    RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) =>
    json.encode(data.toJson());

class RegistrationResponse {
  RegistrationResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  String message;
  dynamic responseData;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      RegistrationResponse(
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
