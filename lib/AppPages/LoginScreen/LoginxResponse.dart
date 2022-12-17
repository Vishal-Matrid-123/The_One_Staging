// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

LoginResponse responseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String responseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.guid,
    required this.userName,
    required this.phone,
    required this.email,
  });

  int id;
  String guid;
  String userName;
  String phone;
  String email;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        guid: json["guid"],
        userName: json["userName"],
        phone: json["Phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "guid": guid,
        "userName": userName,
        "Phone": phone,
        "email": email,
      };
}
