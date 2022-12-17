// To parse this JSON data, do
//
//     final homeScreenProduct = homeScreenProductFromJson(jsonString);

import 'dart:convert';

List<HomeScreenProduct> homeScreenProductFromJson(String str) =>
    List<HomeScreenProduct>.from(
        json.decode(str).map((x) => HomeScreenProduct.fromJson(x)));

String homeScreenProductToJson(List<HomeScreenProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeScreenProduct {
  HomeScreenProduct({
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.seName,
    required this.sku,
    required this.productType,
    required this.markAsNew,
    required this.productPrice,
    required this.defaultPictureModel,
    required this.specificationAttributeModels,
    required this.reviewOverviewModel,
    required this.id,
    required this.customProperties,
  });

  String name;
  String shortDescription;
  String fullDescription;
  String seName;
  String sku;
  int productType;
  bool markAsNew;
  ProductPrice productPrice;
  DefaultPictureModel defaultPictureModel;
  List<dynamic> specificationAttributeModels;
  ReviewOverviewModel reviewOverviewModel;
  int id;
  CustomProperties customProperties;

  factory HomeScreenProduct.fromJson(Map<String, dynamic> json) =>
      HomeScreenProduct(
        name: json["Name"],
        shortDescription: json["ShortDescription"],
        fullDescription: json["FullDescription"],
        seName: json["SeName"],
        sku: json["Sku"],
        productType: json["ProductType"],
        markAsNew: json["MarkAsNew"],
        productPrice: ProductPrice.fromJson(json["ProductPrice"]),
        defaultPictureModel:
            DefaultPictureModel.fromJson(json["DefaultPictureModel"]),
        specificationAttributeModels: List<dynamic>.from(
            json["SpecificationAttributeModels"].map((x) => x)),
        reviewOverviewModel:
            ReviewOverviewModel.fromJson(json["ReviewOverviewModel"]),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "ShortDescription": shortDescription,
        "FullDescription": fullDescription,
        "SeName": seName,
        "Sku": sku,
        "ProductType": productType,
        "MarkAsNew": markAsNew,
        "ProductPrice": productPrice.toJson(),
        "DefaultPictureModel": defaultPictureModel.toJson(),
        "SpecificationAttributeModels":
            List<dynamic>.from(specificationAttributeModels.map((x) => x)),
        "ReviewOverviewModel": reviewOverviewModel.toJson(),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class DefaultPictureModel {
  DefaultPictureModel({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.customProperties,
  });

  String imageUrl;
  dynamic thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties customProperties;

  factory DefaultPictureModel.fromJson(Map<String, dynamic> json) =>
      DefaultPictureModel(
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

class ProductPrice {
  ProductPrice({
    required this.oldPrice,
    required this.price,
    required this.priceValue,
    required this.basePricePAngV,
    required this.disableBuyButton,
    required this.disableWishlistButton,
    required this.disableAddToCompareListButton,
    required this.availableForPreOrder,
    required this.preOrderAvailabilityStartDateTimeUtc,
    required this.isRental,
    required this.forceRedirectionAfterAddingToCart,
    required this.displayTaxShippingInfo,
    required this.customProperties,
  });

  dynamic oldPrice;
  String price;
  int priceValue;
  dynamic basePricePAngV;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool disableAddToCompareListButton;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  bool isRental;
  bool forceRedirectionAfterAddingToCart;
  bool displayTaxShippingInfo;
  CustomProperties customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        oldPrice: json["OldPrice"],
        price: json["Price"],
        priceValue: json["PriceValue"],
        basePricePAngV: json["BasePricePAngV"],
        disableBuyButton: json["DisableBuyButton"],
        disableWishlistButton: json["DisableWishlistButton"],
        disableAddToCompareListButton: json["DisableAddToCompareListButton"],
        availableForPreOrder: json["AvailableForPreOrder"],
        preOrderAvailabilityStartDateTimeUtc:
            json["PreOrderAvailabilityStartDateTimeUtc"],
        isRental: json["IsRental"],
        forceRedirectionAfterAddingToCart:
            json["ForceRedirectionAfterAddingToCart"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "OldPrice": oldPrice,
        "Price": price,
        "PriceValue": priceValue,
        "BasePricePAngV": basePricePAngV,
        "DisableBuyButton": disableBuyButton,
        "DisableWishlistButton": disableWishlistButton,
        "DisableAddToCompareListButton": disableAddToCompareListButton,
        "AvailableForPreOrder": availableForPreOrder,
        "PreOrderAvailabilityStartDateTimeUtc":
            preOrderAvailabilityStartDateTimeUtc,
        "IsRental": isRental,
        "ForceRedirectionAfterAddingToCart": forceRedirectionAfterAddingToCart,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "CustomProperties": customProperties.toJson(),
      };
}

class ReviewOverviewModel {
  ReviewOverviewModel({
    required this.productId,
    required this.ratingSum,
    required this.totalReviews,
    required this.allowCustomerReviews,
    required this.customProperties,
  });

  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  CustomProperties customProperties;

  factory ReviewOverviewModel.fromJson(Map<String, dynamic> json) =>
      ReviewOverviewModel(
        productId: json["ProductId"],
        ratingSum: json["RatingSum"],
        totalReviews: json["TotalReviews"],
        allowCustomerReviews: json["AllowCustomerReviews"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "RatingSum": ratingSum,
        "TotalReviews": totalReviews,
        "AllowCustomerReviews": allowCustomerReviews,
        "CustomProperties": customProperties.toJson(),
      };
}
