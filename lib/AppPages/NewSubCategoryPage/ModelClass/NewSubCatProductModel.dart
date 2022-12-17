// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) =>
    json.encode(data.toJson());

class ProductListModel {
  ProductListModel({
    required this.status,
    required this.message,
    required this.productCount,
    required this.responseData,
  });

  String status;
  dynamic message;
  int productCount;
  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        status: json["Status"],
        message: json["Message"],
        productCount: json["ProductCount"],
        responseData: List<ResponseDatum>.from(json["ResponseData"]
                    .map((x) => ResponseDatum.fromJson(x))).length ==
                0
            ? []
            : List<ResponseDatum>.from(
                json["ResponseData"].map((x) => ResponseDatum.fromJson(x))),
      );

  List<ResponseDatum> responseData;

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ProductCount": productCount,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class ResponseDatum {
  ResponseDatum({
    required this.priceValue,
    required this.discountPrice,
    required this.id,
    required this.name,
    required this.stockQuantity,
    required this.productPicture,
    required this.price,
    required this.isDisable,
    required this.isAvailable,
    required this.discountPercentage,
  });

  int id;
  String name;
  String stockQuantity;
  String productPicture;
  String price;
  String discountPrice;
  double priceValue;
  String discountPercentage;
  bool isDisable;
  bool isAvailable;

  factory ResponseDatum.fromJson(Map<String, dynamic> json) => ResponseDatum(
        id: json["Id"],
        name: json["Name"],
        stockQuantity: json["StockQuantity"],
        productPicture: json["ProductPicture"],
        price: json["Price"],
        isDisable: json["IsDisable"],
        isAvailable: json["IsAvailable"],
        discountPrice: json["DiscountedPrice"],
        priceValue: json["PriceValue"],
        discountPercentage:
            json['DiscountPercent'] == null ? '' : json['DiscountPercent'],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "StockQuantity": stockQuantity,
        "ProductPicture": productPicture,
        "Price": price,
        "IsDisable": isDisable,
        "IsAvailable": isAvailable,
        'DiscountPercent ': discountPercentage,
      };
}
