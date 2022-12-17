// To parse this JSON data, do
//
//     final newSubcategoryListResponse = newSubcategoryListResponseFromJson(jsonString);

import 'dart:convert';

NewSubcategoryListResponse newSubcategoryListResponseFromJson(String str) =>
    NewSubcategoryListResponse.fromJson(json.decode(str));

String newSubcategoryListResponseToJson(NewSubcategoryListResponse data) =>
    json.encode(data.toJson());

class NewSubcategoryListResponse {
  NewSubcategoryListResponse({
    required this.status,
    required this.message,
    required this.parentCategoryData,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final ParentCategoryData parentCategoryData;
  final List<SubcategoriesData> responseData;
  final int storeId;

  factory NewSubcategoryListResponse.fromJson(Map<String, dynamic> json) =>
      NewSubcategoryListResponse(
        status: json["Status"],
        message: json["Message"],
        parentCategoryData:
            ParentCategoryData.fromJson(json["parentCategoryData"]),
        responseData: List<SubcategoriesData>.from(
            json["ResponseData"].map((x) => SubcategoriesData.fromJson(x))),
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "parentCategoryData": parentCategoryData.toJson(),
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
        "StoreId": storeId,
      };
}

class ParentCategoryData {
  ParentCategoryData({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory ParentCategoryData.fromJson(Map<String, dynamic> json) =>
      ParentCategoryData(
        id: json["id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
      };
}

class SubcategoriesData {
  SubcategoriesData({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.pictureUrl,
    required this.displayOrder,
    required this.isSubcategory,
  });

  final int id;
  final String name;
  final int pictureId;
  final String pictureUrl;
  final int displayOrder;
  final bool isSubcategory;

  factory SubcategoriesData.fromJson(Map<String, dynamic> json) =>
      SubcategoriesData(
        id: json["Id"],
        name: json["Name"],
        pictureId: json["PictureId"],
        pictureUrl: json["PictureUrl"],
        displayOrder: json["DisplayOrder"],
        isSubcategory: json["IsSubcategory"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "PictureId": pictureId,
        "PictureUrl": pictureUrl,
        "DisplayOrder": displayOrder,
        "IsSubcategory": isSubcategory,
      };
}
