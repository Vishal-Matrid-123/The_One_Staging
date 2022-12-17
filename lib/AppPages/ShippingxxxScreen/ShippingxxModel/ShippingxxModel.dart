// To parse this JSON data, do
//
//     final pickUpPointResponse = pickUpPointResponseFromJson(jsonString);

import 'dart:convert';

PickUpPointResponse pickUpPointResponseFromJson(String str) =>
    PickUpPointResponse.fromJson(json.decode(str));

String pickUpPointResponseToJson(PickUpPointResponse data) =>
    json.encode(data.toJson());

class PickUpPointResponse {
  PickUpPointResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<PickupPointsxx> responseData;

  factory PickUpPointResponse.fromJson(Map<String, dynamic> json) =>
      PickUpPointResponse(
        status: json["status"],
        message: json["Message"],
        responseData: List<PickupPointsxx>.from(
            json["ResponseData"].map((x) => PickupPointsxx.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class PickupPointsxx {
  PickupPointsxx({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory PickupPointsxx.fromJson(Map<String, dynamic> json) => PickupPointsxx(
        id: json["Id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
      };
}
