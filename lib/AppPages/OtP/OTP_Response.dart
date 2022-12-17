// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  OtpResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  ResponseData responseData;

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
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
    required this.requestId,
    required this.errorLevel,
    required this.procResponse,
    required this.campaignId,
    required this.otpReference,
  });

  String requestId;
  int errorLevel;
  String procResponse;
  String campaignId;
  String otpReference;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        requestId: json["requestID"],
        errorLevel: json["errorLevel"],
        procResponse: json["procResponse"],
        campaignId: json["campaignID"],
        otpReference: json["otpReference"],
      );

  Map<String, dynamic> toJson() => {
        "requestID": requestId,
        "errorLevel": errorLevel,
        "procResponse": procResponse,
        "campaignID": campaignId,
        "otpReference": otpReference,
      };
}
