// To parse this JSON data, do
//
//     final wishlistResponse = wishlistResponseFromJson(jsonString);

import 'dart:convert';

WishlistResponse wishlistResponseFromJson(String str) =>
    WishlistResponse.fromJson(json.decode(str));

String wishlistResponseToJson(WishlistResponse data) =>
    json.encode(data.toJson());

class WishlistResponse {
  WishlistResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  WishlistData? responseData;

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        status: json["status"],
        message: json["Message"],
        responseData: WishlistData.fromJson(json["ResponseData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "ResponseData": responseData!.toJson(),
      };
}

class WishlistData {
  WishlistData({
    required this.customerGuid,
    required this.customerFullname,
    required this.emailWishlistEnabled,
    required this.showSku,
    required this.showProductImages,
    required this.isEditable,
    required this.displayAddToCart,
    required this.displayTaxShippingInfo,
    required this.items,
    required this.warnings,
    required this.customProperties,
  });

  String customerGuid;
  String customerFullname;
  bool emailWishlistEnabled;
  bool showSku;
  bool showProductImages;
  bool isEditable;
  bool displayAddToCart;
  bool displayTaxShippingInfo;
  List<WishlistItem> items;
  List<dynamic> warnings;
  CustomProperties customProperties;

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
        customerGuid: json["CustomerGuid"],
        customerFullname: json["CustomerFullname"],
        emailWishlistEnabled: json["EmailWishlistEnabled"],
        showSku: json["ShowSku"],
        showProductImages: json["ShowProductImages"],
        isEditable: json["IsEditable"],
        displayAddToCart: json["DisplayAddToCart"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        items: List<WishlistItem>.from(
            json["Items"].map((x) => WishlistItem.fromJson(x))),
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomerGuid": customerGuid,
        "CustomerFullname": customerFullname,
        "EmailWishlistEnabled": emailWishlistEnabled,
        "ShowSku": showSku,
        "ShowProductImages": showProductImages,
        "IsEditable": isEditable,
        "DisplayAddToCart": displayAddToCart,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class WishlistItem {
  WishlistItem({
    required this.sku,
    required this.picture,
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.unitPrice,
    required this.subTotal,
    required this.discount,
    required this.maximumDiscountedQty,
    required this.quantity,
    required this.allowedQuantities,
    required this.attributeInfo,
    required this.recurringInfo,
    required this.rentalInfo,
    required this.allowItemEditing,
    required this.warnings,
    required this.id,
    required this.customProperties,
  });

  String sku;
  Picture picture;
  int productId;
  String productName;
  String productSeName;
  String unitPrice;
  String subTotal;
  String discount;
  dynamic maximumDiscountedQty;
  int quantity;
  List<dynamic> allowedQuantities;
  String attributeInfo;
  dynamic recurringInfo;
  dynamic rentalInfo;
  bool allowItemEditing;
  List<dynamic> warnings;
  int id;
  CustomProperties customProperties;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        sku: json["Sku"],
        picture: Picture.fromJson(json["Picture"]),
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        unitPrice: json["UnitPrice"],
        subTotal: json["SubTotal"],
        discount: json["Discount"] == null ? null : json["Discount"],
        maximumDiscountedQty: json["MaximumDiscountedQty"],
        quantity: json["Quantity"],
        allowedQuantities:
            List<dynamic>.from(json["AllowedQuantities"].map((x) => x)),
        attributeInfo: json["AttributeInfo"],
        recurringInfo: json["RecurringInfo"],
        rentalInfo: json["RentalInfo"],
        allowItemEditing: json["AllowItemEditing"],
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Sku": sku,
        "Picture": picture.toJson(),
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "UnitPrice": unitPrice,
        "SubTotal": subTotal,
        "Discount": discount == null ? null : discount,
        "MaximumDiscountedQty": maximumDiscountedQty,
        "Quantity": quantity,
        "AllowedQuantities":
            List<dynamic>.from(allowedQuantities.map((x) => x)),
        "AttributeInfo": attributeInfo,
        "RecurringInfo": recurringInfo,
        "RentalInfo": rentalInfo,
        "AllowItemEditing": allowItemEditing,
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class Picture {
  Picture({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.customProperties,
  });

  String imageUrl;
  dynamic thumbImageUrl;
  dynamic fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties customProperties;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        imageUrl: json["ImageUrl"],
        thumbImageUrl: json["ThumbImageUrl"],
        fullSizeImageUrl: json["FullSizeImageUrl"],
        title: json["Title"],
        alternateText: json["AlternateText"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl,
        "ThumbImageUrl": thumbImageUrl,
        "FullSizeImageUrl": fullSizeImageUrl,
        "Title": title,
        "AlternateText": alternateText,
        "CustomProperties": customProperties.toJson(),
      };
}
