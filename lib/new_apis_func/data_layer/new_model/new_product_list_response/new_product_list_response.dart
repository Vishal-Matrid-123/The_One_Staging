// To parse this JSON data, do
//
//     final newProductListResponse = newProductListResponseFromJson(jsonString);

import 'dart:convert';

NewProductListResponse newProductListResponseFromJson(String str) =>
    NewProductListResponse.fromJson(json.decode(str));

String newProductListResponseToJson(NewProductListResponse data) =>
    json.encode(data.toJson());

class NewProductListResponse {
  NewProductListResponse({
    required this.status,
    required this.message,
    required this.productCount,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final int productCount;
  final List<ProductListResponse> responseData;
  final int storeId;

  factory NewProductListResponse.fromJson(Map<String, dynamic> json) =>
      NewProductListResponse(
        status: json["Status"],
        message: json["Message"],
        productCount: json["ProductCount"],
        responseData: List<ProductListResponse>.from(
            json["ResponseData"].map((x) => ProductListResponse.fromJson(x))),
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ProductCount": productCount,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
        "StoreId": storeId,
      };
}

class ProductListResponse {
  ProductListResponse({
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
    required this.parentCategoryId
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
  final String parentCategoryId;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      ProductListResponse(
  parentCategoryId: json['categoryIds'],
        id: json["Id"],
        name: json["Name"],
        stockQuantity: json["StockQuantity"] ?? '',
        productPicture: json["ProductPicture"],
        price: json["Price"],
        discountedPrice: json["DiscountedPrice"] ?? '',
        discountPercent: json["DiscountPercent"] ?? '',
        priceValue: json["PriceValue"].toDouble(),
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
