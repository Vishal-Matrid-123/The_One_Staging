// To parse this JSON data, do
//
//     final productDetails = productDetailsFromJson(jsonString);

import 'dart:convert';

ProductDetails productDetailsFromJson(String str) =>
    ProductDetails.fromJson(json.decode(str));

String productDetailsToJson(ProductDetails data) => json.encode(data.toJson());

class ProductDetails {
  ProductDetails({
    this.defaultPictureZoomEnabled,
    required this.defaultPictureModel,
    required this.pictureModels,
    required this.name,
    required this.shortDescription,
    this.metaKeywords,
    required this.fullDescription,
    required this.metaDescription,
    this.metaTitle,
    required this.seName,
    required this.productType,
    required this.sku,
    required this.showSku,
    required this.showManufacturerPartNumber,
    this.manufacturerPartNumber,
    required this.showGtin,
    this.gtin,
    required this.showVendor,
    required this.hasSampleDownload,
    required this.vendorModel,
    required this.giftCard,
    required this.isShipEnabled,
    required this.freeShippingNotificationEnabled,
    required this.isFreeShipping,
    this.deliveryDate,
    required this.isRental,
    this.rentalStartDate,
    this.rentalEndDate,
    required this.manageInventoryMethod,
    required this.stockAvailability,
    required this.displayBackInStockSubscription,
    required this.emailAFriendEnabled,
    required this.compareProductsEnabled,
    required this.pageShareCode,
    required this.productPrice,
    required this.addToCart,
    required this.breadcrumb,
    required this.productTags,
    required this.productAttributes,
    required this.productSpecifications,
    required this.productManufacturers,
    required this.productReviewOverview,
    this.tierPrices,
    this.associatedProducts,
    required this.displayDiscontinuedMessage,
    required this.currentStoreName,
    required this.id,
    this.customProperties,
  });

  bool? defaultPictureZoomEnabled;
  PictureModel defaultPictureModel;
  List<PictureModel> pictureModels;
  String name;
  String shortDescription;
  String fullDescription;
  dynamic metaKeywords;
  String metaDescription;
  dynamic metaTitle;
  String seName;
  int productType;
  bool showSku;
  String sku;
  bool showManufacturerPartNumber;
  dynamic manufacturerPartNumber;
  bool showGtin;
  dynamic gtin;
  bool showVendor;
  VendorModel vendorModel;
  bool hasSampleDownload;
  GiftCard giftCard;
  bool isShipEnabled;
  bool isFreeShipping;
  bool freeShippingNotificationEnabled;
  dynamic deliveryDate;
  bool isRental;
  dynamic rentalStartDate;
  dynamic rentalEndDate;
  int manageInventoryMethod;
  String stockAvailability;
  bool displayBackInStockSubscription;
  bool emailAFriendEnabled;
  bool compareProductsEnabled;
  String pageShareCode;
  ProductPrice productPrice;
  AddToCart addToCart;
  Breadcrumb? breadcrumb;
  List<dynamic>? productTags;
  List<dynamic>? productAttributes;
  List<ProductSpecification> productSpecifications;
  List<dynamic>? productManufacturers;
  ProductReviewOverview productReviewOverview;
  List<dynamic>? tierPrices;
  List<dynamic>? associatedProducts;
  bool displayDiscontinuedMessage;
  String currentStoreName;
  int id;
  CustomProperties? customProperties;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        defaultPictureZoomEnabled: json["DefaultPictureZoomEnabled"],
        defaultPictureModel: PictureModel.fromJson(json["DefaultPictureModel"]),
        pictureModels: List<PictureModel>.from(
            json["PictureModels"].map((x) => PictureModel.fromJson(x))),
        name: json["Name"],
        shortDescription: json["ShortDescription"],
        fullDescription: json["FullDescription"],
        metaKeywords: json["MetaKeywords"],
        metaDescription: json["MetaDescription"],
        metaTitle: json["MetaTitle"],
        seName: json["SeName"],
        productType: json["ProductType"],
        showSku: json["ShowSku"],
        sku: json["Sku"],
        showManufacturerPartNumber: json["ShowManufacturerPartNumber"],
        manufacturerPartNumber: json["ManufacturerPartNumber"],
        showGtin: json["ShowGtin"],
        gtin: json["Gtin"],
        showVendor: json["ShowVendor"],
        vendorModel: VendorModel.fromJson(json["VendorModel"]),
        hasSampleDownload: json["HasSampleDownload"],
        giftCard: GiftCard.fromJson(json["GiftCard"]),
        isShipEnabled: json["IsShipEnabled"],
        isFreeShipping: json["IsFreeShipping"],
        freeShippingNotificationEnabled:
            json["FreeShippingNotificationEnabled"],
        deliveryDate: json["DeliveryDate"],
        isRental: json["IsRental"],
        rentalStartDate: json["RentalStartDate"],
        rentalEndDate: json["RentalEndDate"],
        manageInventoryMethod: json["ManageInventoryMethod"],
        stockAvailability: json["StockAvailability"],
        displayBackInStockSubscription: json["DisplayBackInStockSubscription"],
        emailAFriendEnabled: json["EmailAFriendEnabled"],
        compareProductsEnabled: json["CompareProductsEnabled"],
        pageShareCode: json["PageShareCode"],
        productPrice: ProductPrice.fromJson(json["ProductPrice"]),
        addToCart: AddToCart.fromJson(json["AddToCart"]),
        breadcrumb: Breadcrumb.fromJson(json["Breadcrumb"]),
        productTags: List<dynamic>.from(json["ProductTags"].map((x) => x)),
        productAttributes:
            List<dynamic>.from(json["ProductAttributes"].map((x) => x)),
        productSpecifications: List<ProductSpecification>.from(
            json["ProductSpecifications"]
                .map((x) => ProductSpecification.fromJson(x))),
        productManufacturers:
            List<dynamic>.from(json["ProductManufacturers"].map((x) => x)),
        productReviewOverview:
            ProductReviewOverview.fromJson(json["ProductReviewOverview"]),
        tierPrices: List<dynamic>.from(json["TierPrices"].map((x) => x)),
        associatedProducts:
            List<dynamic>.from(json["AssociatedProducts"].map((x) => x)),
        displayDiscontinuedMessage: json["DisplayDiscontinuedMessage"],
        currentStoreName: json["CurrentStoreName"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "DefaultPictureZoomEnabled": defaultPictureZoomEnabled!,
        "DefaultPictureModel": defaultPictureModel.toJson(),
        "PictureModels":
            List<dynamic>.from(pictureModels.map((x) => x.toJson())),
        "Name": name,
        "ShortDescription": shortDescription,
        "FullDescription": fullDescription,
        "MetaKeywords": metaKeywords,
        "MetaDescription": metaDescription,
        "MetaTitle": metaTitle,
        "SeName": seName,
        "ProductType": productType,
        "ShowSku": showSku,
        "Sku": sku,
        "ShowManufacturerPartNumber": showManufacturerPartNumber,
        "ManufacturerPartNumber": manufacturerPartNumber,
        "ShowGtin": showGtin,
        "Gtin": gtin,
        "ShowVendor": showVendor,
        "VendorModel": vendorModel.toJson(),
        "HasSampleDownload": hasSampleDownload,
        "GiftCard": giftCard.toJson(),
        "IsShipEnabled": isShipEnabled,
        "IsFreeShipping": isFreeShipping,
        "FreeShippingNotificationEnabled": freeShippingNotificationEnabled,
        "DeliveryDate": deliveryDate,
        "IsRental": isRental,
        "RentalStartDate": rentalStartDate,
        "RentalEndDate": rentalEndDate,
        "ManageInventoryMethod": manageInventoryMethod,
        "StockAvailability": stockAvailability,
        "DisplayBackInStockSubscription": displayBackInStockSubscription,
        "EmailAFriendEnabled": emailAFriendEnabled,
        "CompareProductsEnabled": compareProductsEnabled,
        "PageShareCode": pageShareCode,
        "ProductPrice": productPrice.toJson(),
        "AddToCart": addToCart.toJson(),
        "Breadcrumb": breadcrumb!.toJson(),
        "ProductTags": List<dynamic>.from(productTags!.map((x) => x)),
        "ProductAttributes":
            List<dynamic>.from(productAttributes!.map((x) => x)),
        "ProductSpecifications":
            List<dynamic>.from(productSpecifications.map((x) => x.toJson())),
        "ProductManufacturers":
            List<dynamic>.from(productManufacturers!.map((x) => x)),
        "ProductReviewOverview": productReviewOverview.toJson(),
        "TierPrices": List<dynamic>.from(tierPrices!.map((x) => x)),
        "AssociatedProducts":
            List<dynamic>.from(associatedProducts!.map((x) => x)),
        "DisplayDiscontinuedMessage": displayDiscontinuedMessage,
        "CurrentStoreName": currentStoreName,
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}

class AddToCart {
  AddToCart({
    required this.productId,
    required this.enteredQuantity,
    this.minimumQuantityNotification,
    required this.allowedQuantities,
    required this.customerEntersPrice,
    required this.customerEnteredPrice,
    this.customerEnteredPriceRange,
    required this.disableBuyButton,
    required this.disableWishlistButton,
    required this.isRental,
    required this.availableForPreOrder,
    this.preOrderAvailabilityStartDateTimeUtc,
    required this.updatedShoppingCartItemId,
    this.updateShoppingCartItemType,
    required this.customProperties,
  });

  int productId;
  int enteredQuantity;
  dynamic minimumQuantityNotification;
  List<dynamic>? allowedQuantities;
  bool customerEntersPrice;
  double customerEnteredPrice;
  dynamic customerEnteredPriceRange;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool isRental;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  int updatedShoppingCartItemId;
  dynamic updateShoppingCartItemType;
  CustomProperties? customProperties;

  factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
        productId: json["ProductId"],
        enteredQuantity: json["EnteredQuantity"],
        minimumQuantityNotification: json["MinimumQuantityNotification"],
        allowedQuantities:
            List<dynamic>.from(json["AllowedQuantities"].map((x) => x)),
        customerEntersPrice: json["CustomerEntersPrice"],
        customerEnteredPrice: json["CustomerEnteredPrice"],
        customerEnteredPriceRange: json["CustomerEnteredPriceRange"],
        disableBuyButton: json["DisableBuyButton"],
        disableWishlistButton: json["DisableWishlistButton"],
        isRental: json["IsRental"],
        availableForPreOrder: json["AvailableForPreOrder"],
        preOrderAvailabilityStartDateTimeUtc:
            json["PreOrderAvailabilityStartDateTimeUtc"],
        updatedShoppingCartItemId: json["UpdatedShoppingCartItemId"],
        updateShoppingCartItemType: json["UpdateShoppingCartItemType"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "EnteredQuantity": enteredQuantity,
        "MinimumQuantityNotification": minimumQuantityNotification,
        "AllowedQuantities":
            List<dynamic>.from(allowedQuantities!.map((x) => x)),
        "CustomerEntersPrice": customerEntersPrice,
        "CustomerEnteredPrice": customerEnteredPrice,
        "CustomerEnteredPriceRange": customerEnteredPriceRange,
        "DisableBuyButton": disableBuyButton,
        "DisableWishlistButton": disableWishlistButton,
        "IsRental": isRental,
        "AvailableForPreOrder": availableForPreOrder,
        "PreOrderAvailabilityStartDateTimeUtc":
            preOrderAvailabilityStartDateTimeUtc,
        "UpdatedShoppingCartItemId": updatedShoppingCartItemId,
        "UpdateShoppingCartItemType": updateShoppingCartItemType,
        "CustomProperties": customProperties!.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class Breadcrumb {
  Breadcrumb({
    this.enabled,
    this.productId,
    this.productName,
    this.productSeName,
    this.categoryBreadcrumb,
    this.customProperties,
  });

  bool? enabled;
  int? productId;
  String? productName;
  String? productSeName;
  List<CategoryBreadcrumb>? categoryBreadcrumb;
  CustomProperties? customProperties;

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
        enabled: json["Enabled"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        categoryBreadcrumb: List<CategoryBreadcrumb>.from(
            json["CategoryBreadcrumb"]
                .map((x) => CategoryBreadcrumb.fromJson(x))),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Enabled": enabled,
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "CategoryBreadcrumb":
            List<dynamic>.from(categoryBreadcrumb!.map((x) => x.toJson())),
        "CustomProperties": customProperties!.toJson(),
      };
}

class CategoryBreadcrumb {
  CategoryBreadcrumb({
    this.name,
    this.seName,
    this.numberOfProducts,
    this.includeInTopMenu,
    this.subCategories,
    this.id,
    this.customProperties,
  });

  String? name;
  String? seName;
  dynamic? numberOfProducts;
  bool? includeInTopMenu;
  List<dynamic>? subCategories;
  int? id;
  CustomProperties? customProperties;

  factory CategoryBreadcrumb.fromJson(Map<String, dynamic> json) =>
      CategoryBreadcrumb(
        name: json["Name"],
        seName: json["SeName"],
        numberOfProducts: json["NumberOfProducts"],
        includeInTopMenu: json["IncludeInTopMenu"],
        subCategories: List<dynamic>.from(json["SubCategories"].map((x) => x)),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SeName": seName,
        "NumberOfProducts": numberOfProducts,
        "IncludeInTopMenu": includeInTopMenu,
        "SubCategories": List<dynamic>.from(subCategories!.map((x) => x)),
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}

class PictureModel {
  PictureModel({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.customProperties,
  });

  String imageUrl;
  String thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties customProperties;

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        imageUrl: json["ImageUrl"],
        thumbImageUrl:
            json["ThumbImageUrl"] == null ? null : json["ThumbImageUrl"],
        fullSizeImageUrl: json["FullSizeImageUrl"],
        title: json["Title"],
        alternateText: json["AlternateText"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl,
        "ThumbImageUrl": thumbImageUrl == null ? null : thumbImageUrl,
        "FullSizeImageUrl": fullSizeImageUrl,
        "Title": title,
        "AlternateText": alternateText,
        "CustomProperties": customProperties.toJson(),
      };
}

class GiftCard {
  GiftCard({
    this.isGiftCard,
    this.recipientName,
    this.recipientEmail,
    this.senderName,
    this.senderEmail,
    this.message,
    this.giftCardType,
    this.customProperties,
  });

  bool? isGiftCard;
  dynamic recipientName;
  dynamic recipientEmail;
  dynamic senderName;
  dynamic senderEmail;
  dynamic message;
  int? giftCardType;
  CustomProperties? customProperties;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        isGiftCard: json["IsGiftCard"],
        recipientName: json["RecipientName"],
        recipientEmail: json["RecipientEmail"],
        senderName: json["SenderName"],
        senderEmail: json["SenderEmail"],
        message: json["Message"],
        giftCardType: json["GiftCardType"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "IsGiftCard": isGiftCard,
        "RecipientName": recipientName,
        "RecipientEmail": recipientEmail,
        "SenderName": senderName,
        "SenderEmail": senderEmail,
        "Message": message,
        "GiftCardType": giftCardType,
        "CustomProperties": customProperties!.toJson(),
      };
}

class ProductPrice {
  ProductPrice({
    required this.currencyCode,
    this.oldPrice,
    required this.price,
    this.priceWithDiscount,
    required this.priceValue,
    required this.customerEntersPrice,
    required this.callForPrice,
    required this.productId,
    required this.hidePrices,
    this.rentalPrice,
    required this.isRental,
    required this.displayTaxShippingInfo,
    this.basePricePAngV,
    this.customProperties,
  });

  String currencyCode;
  dynamic oldPrice;
  String price;
  dynamic priceWithDiscount;
  double priceValue;
  bool customerEntersPrice;
  bool callForPrice;
  int productId;
  bool hidePrices;
  bool isRental;
  dynamic rentalPrice;
  bool displayTaxShippingInfo;
  dynamic basePricePAngV;
  CustomProperties? customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        currencyCode: json["CurrencyCode"],
        oldPrice: json["OldPrice"],
        price: json["Price"],
        priceWithDiscount: json["PriceWithDiscount"],
        priceValue: json["PriceValue"],
        customerEntersPrice: json["CustomerEntersPrice"],
        callForPrice: json["CallForPrice"],
        productId: json["ProductId"],
        hidePrices: json["HidePrices"],
        isRental: json["IsRental"],
        rentalPrice: json["RentalPrice"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        basePricePAngV: json["BasePricePAngV"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CurrencyCode": currencyCode,
        "OldPrice": oldPrice,
        "Price": price,
        "PriceWithDiscount": priceWithDiscount,
        "PriceValue": priceValue,
        "CustomerEntersPrice": customerEntersPrice,
        "CallForPrice": callForPrice,
        "ProductId": productId,
        "HidePrices": hidePrices,
        "IsRental": isRental,
        "RentalPrice": rentalPrice,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "BasePricePAngV": basePricePAngV,
        "CustomProperties": customProperties!.toJson(),
      };
}

class ProductReviewOverview {
  ProductReviewOverview({
    required this.productId,
    required this.ratingSum,
    required this.allowCustomerReviews,
    required this.totalReviews,
    required this.customProperties,
  });

  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  CustomProperties customProperties;

  factory ProductReviewOverview.fromJson(Map<String, dynamic> json) =>
      ProductReviewOverview(
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

class ProductSpecification {
  ProductSpecification({
    required this.specificationAttributeId,
    required this.specificationAttributeName,
    required this.valueRaw,
    this.colorSquaresRgb,
    this.customProperties,
  });

  int specificationAttributeId;
  String specificationAttributeName;
  String valueRaw;
  dynamic colorSquaresRgb;
  CustomProperties? customProperties;

  factory ProductSpecification.fromJson(Map<String, dynamic> json) =>
      ProductSpecification(
        specificationAttributeId: json["SpecificationAttributeId"],
        specificationAttributeName: json["SpecificationAttributeName"],
        valueRaw: json["ValueRaw"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SpecificationAttributeId": specificationAttributeId,
        "SpecificationAttributeName": specificationAttributeName,
        "ValueRaw": valueRaw,
        "ColorSquaresRgb": colorSquaresRgb,
        "CustomProperties": customProperties!.toJson(),
      };
}

class VendorModel {
  VendorModel({
    this.name,
    this.seName,
    required this.id,
    this.customProperties,
  });

  dynamic name;
  dynamic seName;
  int id;
  CustomProperties? customProperties;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        name: json["Name"],
        seName: json["SeName"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SeName": seName,
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}
