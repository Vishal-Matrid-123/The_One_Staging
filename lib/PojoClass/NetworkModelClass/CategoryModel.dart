// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.sbc,
  });

  int id;
  String name;
  int displayOrder;
  List<Sbc> sbc;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        displayOrder: json["DisplayOrder"],
        sbc: List<Sbc>.from(json["sbc"].map((x) => Sbc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "DisplayOrder": displayOrder,
        "sbc": List<dynamic>.from(sbc.map((x) => x.toJson())),
      };
}

class Sbc {
  Sbc({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.parentCategoryId,
    required this.displayOrder,
    required this.numberOfProducts,
  });

  int id;
  String name;
  String imageUrl;
  int parentCategoryId;
  int displayOrder;
  int numberOfProducts;

  factory Sbc.fromJson(Map<String, dynamic> json) => Sbc(
        id: json["Id"],
        name: json["Name"],
        imageUrl: json["ImageUrl"],
        parentCategoryId: json["ParentCategoryId"],
        displayOrder: json["DisplayOrder"],
        numberOfProducts: json["NumberOfProducts"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "ImageUrl": imageUrl,
        "ParentCategoryId": parentCategoryId,
        "DisplayOrder": displayOrder,
        "NumberOfProducts": numberOfProducts,
      };
}
