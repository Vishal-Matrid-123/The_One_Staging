// To parse this JSON data, do
//
//     final storeResponse = storeResponseFromJson(jsonString);

import 'dart:convert';

StoreResponse storeResponseFromJson(String str) =>
    StoreResponse.fromJson(json.decode(str));

String storeResponseToJson(StoreResponse data) => json.encode(data.toJson());

class StoreResponse {
  StoreResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  final String status;
  final dynamic message;
  final List<StoreData> responseData;

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: List<StoreData>.from(
            json["ResponseData"].map((x) => StoreData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class StoreData {
  StoreData({
    required this.id,
    required this.name,
    required this.url,
  });

  final int id;
  final String name;
  final String url;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        id: json["Id"],
        name: json["Name"],
        url: json["Url"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Url": url,
      };
}
