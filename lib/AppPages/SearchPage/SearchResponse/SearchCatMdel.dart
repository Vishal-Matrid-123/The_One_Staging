// To parse this JSON data, do
//
//     final searchCatModel = searchCatModelFromJson(jsonString);

import 'dart:convert';

SearchCatModel searchCatModelFromJson(String str) =>
    SearchCatModel.fromJson(json.decode(str));

String searchCatModelToJson(SearchCatModel data) => json.encode(data.toJson());

class SearchCatModel {
  SearchCatModel({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<SearchCatResponeData> responseData;

  factory SearchCatModel.fromJson(Map<String, dynamic> json) => SearchCatModel(
        status: json["Status"],
        message: json["Message"],
        responseData: List<SearchCatResponeData>.from(
            json["ResponseData"].map((x) => SearchCatResponeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class SearchCatResponeData {
  SearchCatResponeData({
    required this.id,
    required this.name,
    required this.parentCategoryId,
  });

  int id;
  String name;
  int parentCategoryId;

  factory SearchCatResponeData.fromJson(Map<String, dynamic> json) =>
      SearchCatResponeData(
        id: json["Id"],
        name: json["Name"],
        parentCategoryId: json["parentCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "parentCategoryId": parentCategoryId,
      };
}
