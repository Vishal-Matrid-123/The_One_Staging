// To parse this JSON data, do
//
//     final storeResponse = storeResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse storeResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String storeResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final ResponseData responseData;
  final int storeId;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: ResponseData.fromJson(json["ResponseData"]),
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData.toJson(),
        "StoreId": storeId,
      };
}

class ResponseData {
  ResponseData({
    required this.getProductsByCategoryIdClasses,
    required this.specificationAttributeFilters,
    required this.sorting,
    required this.totalCount,
    required this.priceRange,
  });

  final List<GetProductsByCategoryIdClass> getProductsByCategoryIdClasses;
  final List<SpecificationAttributeFilter> specificationAttributeFilters;
  final List<Sorting> sorting;
  final int totalCount;
  final PriceRange priceRange;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        getProductsByCategoryIdClasses: List<GetProductsByCategoryIdClass>.from(
            json["getProductsByCategoryIdClasses"]
                .map((x) => GetProductsByCategoryIdClass.fromJson(x))),
        specificationAttributeFilters: List<SpecificationAttributeFilter>.from(
            json["specificationAttributeFilters"]
                .map((x) => SpecificationAttributeFilter.fromJson(x))),
        sorting:
            List<Sorting>.from(json["sorting"].map((x) => Sorting.fromJson(x))),
        totalCount: json["TotalCount"],
        priceRange: PriceRange.fromJson(json["priceRange"]),
      );

  Map<String, dynamic> toJson() => {
        "getProductsByCategoryIdClasses": List<dynamic>.from(
            getProductsByCategoryIdClasses.map((x) => x.toJson())),
        "specificationAttributeFilters": List<dynamic>.from(
            specificationAttributeFilters.map((x) => x.toJson())),
        "sorting": List<dynamic>.from(sorting.map((x) => x.toJson())),
        "TotalCount": totalCount,
        "priceRange": priceRange.toJson(),
      };
}

class GetProductsByCategoryIdClass {
  GetProductsByCategoryIdClass({
    required this.id,
    required this.name,
    required this.stockQuantity,
    required this.productPicture,
    required this.price,
    required this.discountedPrice,
    required this.discountPercent,
    required this.priceValue,
    required this.isDisable,
    required this.isAvailable,
    required this.isGiftCard,
    required this.havingattributes,
  });

  final int id;
  final String name;
  final String stockQuantity;
  final String productPicture;
  final String price;
  final String discountedPrice;
  final String discountPercent;
  final double priceValue;
  final bool isDisable;
  final bool isAvailable;
  final bool isGiftCard;
  final bool havingattributes;

  factory GetProductsByCategoryIdClass.fromJson(Map<String, dynamic> json) =>
      GetProductsByCategoryIdClass(
        id: json["Id"],
        name: json["Name"],
        stockQuantity: json["StockQuantity"] ?? 'No Available Value Return',
        productPicture: json["ProductPicture"],
        price: json["Price"] ?? 'No Pricing Available',
        discountedPrice: json["DiscountedPrice"] ?? '',
        discountPercent: json["DiscountPercent"] ?? '',
        priceValue: json["PriceValue"],
        isDisable: json["IsDisable"],
        isAvailable: json["IsAvailable"],
        isGiftCard: json["IsGiftCard"],
        havingattributes: json["havingattributes"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "StockQuantity": stockQuantity,
        "ProductPicture": productPicture,
        "Price": price,
        "DiscountedPrice": discountedPrice,
        "DiscountPercent": discountPercent,
        "PriceValue": priceValue,
        "IsDisable": isDisable,
        "IsAvailable": isAvailable,
        "IsGiftCard": isGiftCard,
        "havingattributes": havingattributes,
      };
}

class PriceRange {
  PriceRange({
    required this.minPrice,
    required this.maxPrice,
  });

  final double minPrice;
  final double maxPrice;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        minPrice: json["minPrice"],
        maxPrice: json["maxPrice"],
      );

  Map<String, dynamic> toJson() => {
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}

class Sorting {
  Sorting({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Sorting.fromJson(Map<String, dynamic> json) => Sorting(
        id: json["Id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
      };
}

class SpecificationAttributeFilter {
  SpecificationAttributeFilter({
    required this.id,
    required this.name,
    required this.specificationoptions,
  });

  final int id;
  final String name;
  final List<Specificationoption> specificationoptions;

  factory SpecificationAttributeFilter.fromJson(Map<String, dynamic> json) =>
      SpecificationAttributeFilter(
        id: json["id"],
        name: json["name"],
        specificationoptions: List<Specificationoption>.from(
            json["specificationoptions"]
                .map((x) => Specificationoption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "specificationoptions":
            List<dynamic>.from(specificationoptions.map((x) => x.toJson())),
      };
}

class Specificationoption {
  Specificationoption({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Specificationoption.fromJson(Map<String, dynamic> json) =>
      Specificationoption(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
