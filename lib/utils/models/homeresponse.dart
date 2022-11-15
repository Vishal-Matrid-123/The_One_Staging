// To parse this JSON data, do
//
//     final homeResponse1 = homeResponse1FromJson(jsonString);

import 'dart:convert';

HomeResponse1 homeResponse1FromJson(String str) =>
    HomeResponse1.fromJson(json.decode(str));

String homeResponse1ToJson(HomeResponse1 data) => json.encode(data.toJson());

class HomeResponse1 {
  HomeResponse1({
    required this.banners,
    required this.homePageCategoriesImage,
    required this.homePageProductImage,
    required this.homepageProductsTitle,
  });

  List<Bannerxx> banners;
  List<HomePageCategoriesImage> homePageCategoriesImage;
  List<HomePageProductImage> homePageProductImage;
  String homepageProductsTitle;

  factory HomeResponse1.fromJson(Map<String, dynamic> json) => HomeResponse1(
      banners:
          List<Bannerxx>.from(json["banners"].map((x) => Bannerxx.fromJson(x))),
      homePageCategoriesImage: List<HomePageCategoriesImage>.from(
          json["HomePageCategoriesImage"]
              .map((x) => HomePageCategoriesImage.fromJson(x))),
      homePageProductImage: List<HomePageProductImage>.from(
          json["HomePageProductImage"]
              .map((x) => HomePageProductImage.fromJson(x))),
      homepageProductsTitle: json['HomepageProductsTitle'] ?? "");

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "HomePageCategoriesImage":
            List<dynamic>.from(homePageCategoriesImage.map((x) => x.toJson())),
        "HomePageProductImage":
            List<dynamic>.from(homePageProductImage.map((x) => x.toJson())),
        "HomepageProductsTitle": homepageProductsTitle,
      };
}

class Bannerxx {
  Bannerxx({
    required this.imageUrl,
    required this.imageLink,
    required this.displayOrder,
    required this.type,
    required this.id,
  });

  String imageUrl;
  String imageLink;
  String displayOrder;
  String type;
  String id;

  factory Bannerxx.fromJson(Map<String, dynamic> json) => Bannerxx(
        imageUrl: json["ImageUrl"],
        imageLink: json["ImageLink"],
        displayOrder: json["DisplayOrder"],
        type: json["Type"],
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl,
        "ImageLink": imageLink,
        "DisplayOrder": displayOrder,
        "Type": type,
        "Id": id,
      };
}

class HomePageCategoriesImage {
  HomePageCategoriesImage({
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

  factory HomePageCategoriesImage.fromJson(Map<String, dynamic> json) =>
      HomePageCategoriesImage(
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

class HomePageProductImage {
  HomePageProductImage({
    required this.price,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.discountPercentage,
  });

  String price;
  int id;
  String name;
  String discountPercentage;
  List<String> imageUrl;

  factory HomePageProductImage.fromJson(Map<String, dynamic> json) =>
      HomePageProductImage(
        price: json["price"],
        id: json["Id"],
        name: json["Name"],
        imageUrl: List<String>.from(json["ImageUrl"].map((x) => x)),
        discountPercentage: json['DiscountPercent'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "Id": id,
        "Name": name,
        "ImageUrl": imageUrl,
        'DiscountPercent ': discountPercentage,
      };
}
