// To parse this JSON data, do
//
//     final searchCategoryResponse = searchCategoryResponseFromJson(jsonString);

import 'dart:convert';

SearchCategoryResponse searchCategoryResponseFromJson(String str) =>
    SearchCategoryResponse.fromJson(json.decode(str));

String searchCategoryResponseToJson(SearchCategoryResponse data) =>
    json.encode(data.toJson());

class SearchCategoryResponse {
  SearchCategoryResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<SearchCategories> responseData;

  factory SearchCategoryResponse.fromJson(Map<String, dynamic> json) =>
      SearchCategoryResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: List<SearchCategories>.from(
            json["ResponseData"].map((x) => SearchCategories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class SearchCategories {
  SearchCategories({
    required this.id,
    required this.name,
    required this.parentCategoryId,
    required this.imageUrl,
    required this.isSubCategory,
  });

  int id;
  String name;
  int parentCategoryId;
  String imageUrl;
  bool isSubCategory;

  factory SearchCategories.fromJson(Map<String, dynamic> json) =>
      SearchCategories(
        id: json["Id"],
        name: json["Name"],
        parentCategoryId: json["ParentCategoryId"],
        imageUrl: json["ImageUrl"],
        isSubCategory: json["IsSubCategory"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "ParentCategoryId": parentCategoryId,
        "ImageUrl": imageUrl,
        "IsSubCategory": isSubCategory,
      };
}
