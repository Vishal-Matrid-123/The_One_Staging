// To parse this JSON data, do
//
//     final otpVerifyResponse = otpVerifyResponseFromJson(jsonString);

import 'dart:convert';

OtpVerifyResponse otpVerifyResponseFromJson(String str) =>
    OtpVerifyResponse.fromJson(json.decode(str));

String otpVerifyResponseToJson(OtpVerifyResponse data) =>
    json.encode(data.toJson());

class OtpVerifyResponse {
  OtpVerifyResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  ResponseData responseData;

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      OtpVerifyResponse(
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
  });

  String requestId;
  int errorLevel;
  String procResponse;
  dynamic campaignId;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        requestId: json["requestID"],
        errorLevel: json["errorLevel"],
        procResponse: json["procResponse"],
        campaignId: json["campaignID"],
      );

  Map<String, dynamic> toJson() => {
        "requestID": requestId,
        "errorLevel": errorLevel,
        "procResponse": procResponse,
        "campaignID": campaignId,
      };
}
