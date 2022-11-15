import 'dart:convert';

List<NewCategoryListResponse> newCategoryListResponseFromJson(String str) =>
    List<NewCategoryListResponse>.from(
        json.decode(str).map((x) => NewCategoryListResponse.fromJson(x)));

String newCategoryListResponseToJson(List<NewCategoryListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewCategoryListResponse {
  NewCategoryListResponse({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.sbc,
  });

  final int id;
  final String name;
  final int displayOrder;
  final List<Sbc> sbc;

  factory NewCategoryListResponse.fromJson(Map<String, dynamic> json) =>
      NewCategoryListResponse(
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
    required this.isSubCategory,
  });

  final int id;
  final String name;
  final String imageUrl;
  final int parentCategoryId;
  final int displayOrder;
  final int numberOfProducts;
  final bool isSubCategory;

  factory Sbc.fromJson(Map<String, dynamic> json) => Sbc(
        id: json["Id"],
        name: json["Name"],
        imageUrl: json["ImageUrl"],
        parentCategoryId: json["ParentCategoryId"],
        displayOrder: json["DisplayOrder"],
        numberOfProducts: json["NumberOfProducts"],
        isSubCategory: json["IsSubCategory"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "ImageUrl": imageUrl,
        "ParentCategoryId": parentCategoryId,
        "DisplayOrder": displayOrder,
        "NumberOfProducts": numberOfProducts,
        "IsSubCategory": isSubCategory,
      };
}
