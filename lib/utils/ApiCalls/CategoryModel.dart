// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.name,
    required this.description,
    required this.metaKeywords,
    this.metaDescription,
    required this.metaTitle,
    required this.seName,
    required this.pictureModel,
    required this.pagingFilteringContext,
    required this.displayCategoryBreadcrumb,
    required this.categoryBreadcrumb,
    required this.subCategories,
    required this.featuredProducts,
    required this.productss,
  });

  String name;
  String description;
  String metaKeywords;
  dynamic metaDescription;
  String metaTitle;
  String seName;
  PictureModel pictureModel;
  PagingFilteringContext pagingFilteringContext;
  bool displayCategoryBreadcrumb;
  List<CategoryModelCategoryBreadcrumb> categoryBreadcrumb;
  List<SubCategory> subCategories;
  List<dynamic> featuredProducts;
  List<Productss> productss;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["Name"],
        description: json["Description"],
        metaKeywords: json["MetaKeywords"],
        metaDescription: json["MetaDescription"],
        metaTitle: json["MetaTitle"],
        seName: json["SeName"],
        pictureModel: PictureModel.fromJson(json["PictureModel"]),
        pagingFilteringContext:
            PagingFilteringContext.fromJson(json["PagingFilteringContext"]),
        displayCategoryBreadcrumb: json["DisplayCategoryBreadcrumb"],
        categoryBreadcrumb: List<CategoryModelCategoryBreadcrumb>.from(
            json["CategoryBreadcrumb"]
                .map((x) => CategoryModelCategoryBreadcrumb.fromJson(x))),
        subCategories: List<SubCategory>.from(
            json["SubCategories"].map((x) => SubCategory.fromJson(x))),
        featuredProducts:
            List<dynamic>.from(json["FeaturedProducts"].map((x) => x)),
        productss: List<Productss>.from(
            json["Productss"].map((x) => Productss.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "MetaKeywords": metaKeywords,
        "MetaDescription": metaDescription,
        "MetaTitle": metaTitle,
        "SeName": seName,
        "PictureModel": pictureModel.toJson(),
        "PagingFilteringContext": pagingFilteringContext.toJson(),
        "DisplayCategoryBreadcrumb": displayCategoryBreadcrumb,
        "CategoryBreadcrumb":
            List<dynamic>.from(categoryBreadcrumb.map((x) => x.toJson())),
        "SubCategories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
        "FeaturedProducts": List<dynamic>.from(featuredProducts.map((x) => x)),
        "Productss": List<dynamic>.from(productss.map((x) => x.toJson())),
      };
}

class CategoryModelCategoryBreadcrumb {
  CategoryModelCategoryBreadcrumb({
    required this.name,
    this.description,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    required this.seName,
    required this.pictureModel,
    required this.pagingFilteringContext,
    required this.displayCategoryBreadcrumb,
    required this.categoryBreadcrumb,
    required this.subCategories,
    required this.featuredProducts,
    required this.products,
    required this.id,
    required this.customProperties,
  });

  String name;
  dynamic description;
  dynamic metaKeywords;
  dynamic metaDescription;
  dynamic metaTitle;
  String seName;
  PictureModel pictureModel;
  PagingFilteringContext pagingFilteringContext;
  bool displayCategoryBreadcrumb;
  List<dynamic> categoryBreadcrumb;
  List<dynamic> subCategories;
  List<dynamic> featuredProducts;
  List<dynamic> products;
  int id;
  CustomProperties customProperties;

  factory CategoryModelCategoryBreadcrumb.fromJson(Map<String, dynamic> json) =>
      CategoryModelCategoryBreadcrumb(
        name: json["Name"],
        description: json["Description"],
        metaKeywords: json["MetaKeywords"],
        metaDescription: json["MetaDescription"],
        metaTitle: json["MetaTitle"],
        seName: json["SeName"],
        pictureModel: PictureModel.fromJson(json["PictureModel"]),
        pagingFilteringContext:
            PagingFilteringContext.fromJson(json["PagingFilteringContext"]),
        displayCategoryBreadcrumb: json["DisplayCategoryBreadcrumb"],
        categoryBreadcrumb:
            List<dynamic>.from(json["CategoryBreadcrumb"].map((x) => x)),
        subCategories: List<dynamic>.from(json["SubCategories"].map((x) => x)),
        featuredProducts:
            List<dynamic>.from(json["FeaturedProducts"].map((x) => x)),
        products: List<dynamic>.from(json["Products"].map((x) => x)),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "MetaKeywords": metaKeywords,
        "MetaDescription": metaDescription,
        "MetaTitle": metaTitle,
        "SeName": seName,
        "PictureModel": pictureModel.toJson(),
        "PagingFilteringContext": pagingFilteringContext.toJson(),
        "DisplayCategoryBreadcrumb": displayCategoryBreadcrumb,
        "CategoryBreadcrumb":
            List<dynamic>.from(categoryBreadcrumb.map((x) => x)),
        "SubCategories": List<dynamic>.from(subCategories.map((x) => x)),
        "FeaturedProducts": List<dynamic>.from(featuredProducts.map((x) => x)),
        "Products": List<dynamic>.from(products.map((x) => x)),
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

class PagingFilteringContext {
  PagingFilteringContext({
    required this.priceRangeFilter,
    required this.specificationFilter,
    required this.allowProductSorting,
    required this.availableSortOptions,
    required this.allowProductViewModeChanging,
    required this.availableViewModes,
    required this.allowCustomersToSelectPageSize,
    required this.pageSizeOptions,
    this.orderBy,
    required this.viewMode,
    required this.pageIndex,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.firstItem,
    required this.lastItem,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.customProperties,
  });

  PriceRangeFilter priceRangeFilter;
  SpecificationFilter specificationFilter;
  bool allowProductSorting;
  List<Available> availableSortOptions;
  bool allowProductViewModeChanging;
  List<Available> availableViewModes;
  bool allowCustomersToSelectPageSize;
  List<dynamic> pageSizeOptions;
  dynamic orderBy;
  String viewMode;
  int pageIndex;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  int firstItem;
  int lastItem;
  bool hasPreviousPage;
  bool hasNextPage;
  CustomProperties customProperties;

  factory PagingFilteringContext.fromJson(Map<String, dynamic> json) =>
      PagingFilteringContext(
        priceRangeFilter: PriceRangeFilter.fromJson(json["PriceRangeFilter"]),
        specificationFilter:
            SpecificationFilter.fromJson(json["SpecificationFilter"]),
        allowProductSorting: json["AllowProductSorting"],
        availableSortOptions: List<Available>.from(
            json["AvailableSortOptions"].map((x) => Available.fromJson(x))),
        allowProductViewModeChanging: json["AllowProductViewModeChanging"],
        availableViewModes: List<Available>.from(
            json["AvailableViewModes"].map((x) => Available.fromJson(x))),
        allowCustomersToSelectPageSize: json["AllowCustomersToSelectPageSize"],
        pageSizeOptions:
            List<dynamic>.from(json["PageSizeOptions"].map((x) => x)),
        orderBy: json["OrderBy"],
        viewMode: json["ViewMode"] == null ? null : json["ViewMode"],
        pageIndex: json["PageIndex"],
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalItems: json["TotalItems"],
        totalPages: json["TotalPages"],
        firstItem: json["FirstItem"],
        lastItem: json["LastItem"],
        hasPreviousPage: json["HasPreviousPage"],
        hasNextPage: json["HasNextPage"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PriceRangeFilter": priceRangeFilter.toJson(),
        "SpecificationFilter": specificationFilter.toJson(),
        "AllowProductSorting": allowProductSorting,
        "AvailableSortOptions":
            List<dynamic>.from(availableSortOptions.map((x) => x.toJson())),
        "AllowProductViewModeChanging": allowProductViewModeChanging,
        "AvailableViewModes":
            List<dynamic>.from(availableViewModes.map((x) => x.toJson())),
        "AllowCustomersToSelectPageSize": allowCustomersToSelectPageSize,
        "PageSizeOptions": List<dynamic>.from(pageSizeOptions.map((x) => x)),
        "OrderBy": orderBy,
        "ViewMode": viewMode == null ? null : viewMode,
        "PageIndex": pageIndex,
        "PageNumber": pageNumber,
        "PageSize": pageSize,
        "TotalItems": totalItems,
        "TotalPages": totalPages,
        "FirstItem": firstItem,
        "LastItem": lastItem,
        "HasPreviousPage": hasPreviousPage,
        "HasNextPage": hasNextPage,
        "CustomProperties": customProperties.toJson(),
      };
}

class Available {
  Available({
    required this.disabled,
    this.group,
    required this.selected,
    required this.text,
    required this.value,
  });

  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
        disabled: json["Disabled"],
        group: json["Group"],
        selected: json["Selected"],
        text: json["Text"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Disabled": disabled,
        "Group": group,
        "Selected": selected,
        "Text": text,
        "Value": value,
      };
}

class PriceRangeFilter {
  PriceRangeFilter({
    required this.enabled,
    this.removeFilterUrl,
    required this.customProperties,
    required this.items,
  });

  bool enabled;
  List<dynamic> items;
  dynamic removeFilterUrl;
  CustomProperties customProperties;

  factory PriceRangeFilter.fromJson(Map<String, dynamic> json) =>
      PriceRangeFilter(
        enabled: json["Enabled"],
        items: List<dynamic>.from(json["Items"].map((x) => x)),
        removeFilterUrl: json["RemoveFilterUrl"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Enabled": enabled,
        "Items": List<dynamic>.from(items.map((x) => x)),
        "RemoveFilterUrl": removeFilterUrl,
        "CustomProperties": customProperties.toJson(),
      };
}

class SpecificationFilter {
  SpecificationFilter({
    required this.enabled,
    required this.alreadyFilteredItems,
    required this.notFilteredItems,
    this.removeFilterUrl,
    required this.customProperties,
  });

  bool enabled;
  List<dynamic> alreadyFilteredItems;
  List<dynamic> notFilteredItems;
  dynamic removeFilterUrl;
  CustomProperties customProperties;

  factory SpecificationFilter.fromJson(Map<String, dynamic> json) =>
      SpecificationFilter(
        enabled: json["Enabled"],
        alreadyFilteredItems:
            List<dynamic>.from(json["AlreadyFilteredItems"].map((x) => x)),
        notFilteredItems:
            List<dynamic>.from(json["NotFilteredItems"].map((x) => x)),
        removeFilterUrl: json["RemoveFilterUrl"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Enabled": enabled,
        "AlreadyFilteredItems":
            List<dynamic>.from(alreadyFilteredItems.map((x) => x)),
        "NotFilteredItems": List<dynamic>.from(notFilteredItems.map((x) => x)),
        "RemoveFilterUrl": removeFilterUrl,
        "CustomProperties": customProperties.toJson(),
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
        imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
        thumbImageUrl:
            json["ThumbImageUrl"] == null ? null : json["ThumbImageUrl"],
        fullSizeImageUrl:
            json["FullSizeImageUrl"] == null ? null : json["FullSizeImageUrl"],
        title: json["Title"] == null ? null : json["Title"],
        alternateText:
            json["AlternateText"] == null ? null : json["AlternateText"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl == null ? null : imageUrl,
        "ThumbImageUrl": thumbImageUrl == null ? null : thumbImageUrl,
        "FullSizeImageUrl": fullSizeImageUrl == null ? null : fullSizeImageUrl,
        "Title": title == null ? null : title,
        "AlternateText": alternateText == null ? null : alternateText,
        "CustomProperties": customProperties.toJson(),
      };
}

class Productss {
  Productss({
    required this.defaultPictureZoomEnabled,
    required this.defaultPictureModel,
    required this.pictureModels,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.metaKeywords,
    required this.metaDescription,
    required this.metaTitle,
    required this.productType,
    required this.seName,
    required this.showSku,
    required this.sku,
    required this.showManufacturerPartNumber,
    required this.manufacturerPartNumber,
    required this.showGtin,
    required this.gtin,
    required this.showVendor,
    required this.vendorModel,
    required this.hasSampleDownload,
    required this.giftCard,
    required this.isShipEnabled,
    required this.isFreeShipping,
    required this.freeShippingNotificationEnabled,
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
    required this.tierPrices,
    required this.associatedProducts,
    required this.displayDiscontinuedMessage,
    required this.currentStoreName,
    required this.id,
    required this.customProperties,
  });

  bool defaultPictureZoomEnabled;
  PictureModel defaultPictureModel;
  List<PictureModel> pictureModels;
  String name;
  String shortDescription;
  String fullDescription;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  int productType;
  bool showSku;
  String sku;
  bool showManufacturerPartNumber;
  String manufacturerPartNumber;
  bool showGtin;
  String gtin;
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
  Breadcrumb breadcrumb;
  List<VendorModel> productTags;
  List<ProductAttribute> productAttributes;
  List<dynamic> productSpecifications;
  List<dynamic> productManufacturers;
  ProductReviewOverview productReviewOverview;
  List<dynamic> tierPrices;
  List<dynamic> associatedProducts;
  bool displayDiscontinuedMessage;
  CurrentStoreName? currentStoreName;
  int id;
  CustomProperties customProperties;

  factory Productss.fromJson(Map<String, dynamic> json) => Productss(
        defaultPictureZoomEnabled: json["DefaultPictureZoomEnabled"],
        defaultPictureModel: PictureModel.fromJson(json["DefaultPictureModel"]),
        pictureModels: List<PictureModel>.from(
            json["PictureModels"].map((x) => PictureModel.fromJson(x))),
        name: json["Name"],
        shortDescription: json["ShortDescription"],
        fullDescription: json["FullDescription"],
        metaKeywords:
            json["MetaKeywords"] == null ? null : json["MetaKeywords"],
        metaDescription: json["MetaDescription"],
        metaTitle: json["MetaTitle"] == null ? null : json["MetaTitle"],
        seName: json["SeName"],
        productType: json["ProductType"],
        showSku: json["ShowSku"],
        sku: json["Sku"],
        showManufacturerPartNumber: json["ShowManufacturerPartNumber"],
        manufacturerPartNumber: json["ManufacturerPartNumber"] == null
            ? null
            : json["ManufacturerPartNumber"],
        showGtin: json["ShowGtin"],
        gtin: json["Gtin"] == null ? null : json["Gtin"],
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
        productTags: List<VendorModel>.from(
            json["ProductTags"].map((x) => VendorModel.fromJson(x))),
        productAttributes: List<ProductAttribute>.from(
            json["ProductAttributes"].map((x) => ProductAttribute.fromJson(x))),
        productSpecifications:
            List<dynamic>.from(json["ProductSpecifications"].map((x) => x)),
        productManufacturers:
            List<dynamic>.from(json["ProductManufacturers"].map((x) => x)),
        productReviewOverview:
            ProductReviewOverview.fromJson(json["ProductReviewOverview"]),
        tierPrices: List<dynamic>.from(json["TierPrices"].map((x) => x)),
        associatedProducts:
            List<dynamic>.from(json["AssociatedProducts"].map((x) => x)),
        displayDiscontinuedMessage: json["DisplayDiscontinuedMessage"],
        currentStoreName: currentStoreNameValues.map![json["CurrentStoreName"]],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "DefaultPictureZoomEnabled": defaultPictureZoomEnabled,
        "DefaultPictureModel": defaultPictureModel.toJson(),
        "PictureModels":
            List<dynamic>.from(pictureModels.map((x) => x.toJson())),
        "Name": name,
        "ShortDescription": shortDescription,
        "FullDescription": fullDescription,
        "MetaKeywords": metaKeywords == null ? null : metaKeywords,
        "MetaDescription": metaDescription,
        "MetaTitle": metaTitle == null ? null : metaTitle,
        "SeName": seName,
        "ProductType": productType,
        "ShowSku": showSku,
        "Sku": sku,
        "ShowManufacturerPartNumber": showManufacturerPartNumber,
        "ManufacturerPartNumber":
            manufacturerPartNumber == null ? null : manufacturerPartNumber,
        "ShowGtin": showGtin,
        "Gtin": gtin == null ? null : gtin,
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
        "Breadcrumb": breadcrumb.toJson(),
        "ProductTags": List<dynamic>.from(productTags.map((x) => x.toJson())),
        "ProductAttributes":
            List<dynamic>.from(productAttributes.map((x) => x.toJson())),
        "ProductSpecifications":
            List<dynamic>.from(productSpecifications.map((x) => x)),
        "ProductManufacturers":
            List<dynamic>.from(productManufacturers.map((x) => x)),
        "ProductReviewOverview": productReviewOverview.toJson(),
        "TierPrices": List<dynamic>.from(tierPrices.map((x) => x)),
        "AssociatedProducts":
            List<dynamic>.from(associatedProducts.map((x) => x)),
        "DisplayDiscontinuedMessage": displayDiscontinuedMessage,
        "CurrentStoreName": currentStoreNameValues.reverse[currentStoreName],
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class AddToCart {
  AddToCart({
    required this.productId,
    required this.enteredQuantity,
    this.minimumQuantityNotification,
    required this.customerEntersPrice,
    required this.allowedQuantities,
    required this.customerEnteredPrice,
    required this.customerEnteredPriceRange,
    required this.disableBuyButton,
    required this.disableWishlistButton,
    required this.isRental,
    required this.availableForPreOrder,
    required this.preOrderAvailabilityStartDateTimeUtc,
    required this.updatedShoppingCartItemId,
    required this.updateShoppingCartItemType,
    required this.customProperties,
  });

  int productId;
  int enteredQuantity;
  dynamic minimumQuantityNotification;
  List<dynamic> allowedQuantities;
  bool customerEntersPrice;
  int customerEnteredPrice;
  dynamic customerEnteredPriceRange;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool isRental;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  int updatedShoppingCartItemId;
  dynamic updateShoppingCartItemType;
  CustomProperties customProperties;

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
            List<dynamic>.from(allowedQuantities.map((x) => x)),
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
        "CustomProperties": customProperties.toJson(),
      };
}

class Breadcrumb {
  Breadcrumb({
    required this.enabled,
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.categoryBreadcrumb,
    required this.customProperties,
  });

  bool enabled;
  int productId;
  String productName;
  String productSeName;
  List<BreadcrumbCategoryBreadcrumb> categoryBreadcrumb;
  CustomProperties customProperties;

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
        enabled: json["Enabled"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        categoryBreadcrumb: List<BreadcrumbCategoryBreadcrumb>.from(
            json["CategoryBreadcrumb"]
                .map((x) => BreadcrumbCategoryBreadcrumb.fromJson(x))),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Enabled": enabled,
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "CategoryBreadcrumb":
            List<dynamic>.from(categoryBreadcrumb.map((x) => x.toJson())),
        "CustomProperties": customProperties.toJson(),
      };
}

class BreadcrumbCategoryBreadcrumb {
  BreadcrumbCategoryBreadcrumb({
    required this.name,
    required this.seName,
    required this.numberOfProducts,
    required this.includeInTopMenu,
    required this.subCategories,
    required this.id,
    required this.customProperties,
  });

  String name;
  String seName;
  dynamic numberOfProducts;
  bool includeInTopMenu;
  List<dynamic> subCategories;
  int id;
  CustomProperties customProperties;

  factory BreadcrumbCategoryBreadcrumb.fromJson(Map<String, dynamic> json) =>
      BreadcrumbCategoryBreadcrumb(
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
        "SubCategories": List<dynamic>.from(subCategories.map((x) => x)),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

enum CurrentStoreName { THE_ONE_UAE }

final currentStoreNameValues =
    EnumValues({"THE One UAE": CurrentStoreName.THE_ONE_UAE});

class GiftCard {
  GiftCard({
    required this.isGiftCard,
    required this.recipientName,
    required this.recipientEmail,
    required this.senderName,
    required this.senderEmail,
    required this.message,
    required this.giftCardType,
    required this.customProperties,
  });

  bool isGiftCard;
  dynamic recipientName;
  dynamic recipientEmail;
  dynamic senderName;
  dynamic senderEmail;
  dynamic message;
  int giftCardType;
  CustomProperties customProperties;

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
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductAttribute {
  ProductAttribute({
    required this.productId,
    required this.productAttributeId,
    required this.name,
    required this.description,
    required this.textPrompt,
    required this.isRequired,
    required this.defaultValue,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.hasCondition,
    required this.allowedFileExtensions,
    required this.attributeControlType,
    required this.values,
    required this.id,
    required this.customProperties,
  });

  int productId;
  int productAttributeId;
  Name? name;
  dynamic description;
  Name? textPrompt;
  bool isRequired;
  dynamic defaultValue;
  dynamic selectedDay;
  dynamic selectedMonth;
  dynamic selectedYear;
  bool hasCondition;
  List<dynamic> allowedFileExtensions;
  int attributeControlType;
  List<Value> values;
  int id;
  CustomProperties customProperties;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      ProductAttribute(
        productId: json["ProductId"],
        productAttributeId: json["ProductAttributeId"],
        name: nameValues.map![json["Name"]],
        description: json["Description"],
        textPrompt: nameValues.map![json["TextPrompt"]],
        isRequired: json["IsRequired"],
        defaultValue: json["DefaultValue"],
        selectedDay: json["SelectedDay"],
        selectedMonth: json["SelectedMonth"],
        selectedYear: json["SelectedYear"],
        hasCondition: json["HasCondition"],
        allowedFileExtensions:
            List<dynamic>.from(json["AllowedFileExtensions"].map((x) => x)),
        attributeControlType: json["AttributeControlType"],
        values: List<Value>.from(json["Values"].map((x) => Value.fromJson(x))),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "ProductAttributeId": productAttributeId,
        "Name": nameValues.reverse[name],
        "Description": description,
        "TextPrompt": nameValues.reverse[textPrompt],
        "IsRequired": isRequired,
        "DefaultValue": defaultValue,
        "SelectedDay": selectedDay,
        "SelectedMonth": selectedMonth,
        "SelectedYear": selectedYear,
        "HasCondition": hasCondition,
        "AllowedFileExtensions":
            List<dynamic>.from(allowedFileExtensions.map((x) => x)),
        "AttributeControlType": attributeControlType,
        "Values": List<dynamic>.from(values.map((x) => x.toJson())),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

enum Name { ASSEMBLY_CHARGE }

final nameValues = EnumValues({"Assembly Charge": Name.ASSEMBLY_CHARGE});

class Value {
  Value({
    required this.name,
    required this.colorSquaresRgb,
    required this.imageSquaresPictureModel,
    required this.priceAdjustment,
    required this.priceAdjustmentValue,
    required this.isPreSelected,
    required this.pictureId,
    required this.customerEntersQty,
    required this.quantity,
    required this.id,
    required this.customProperties,
  });

  ValueName? name;
  dynamic colorSquaresRgb;
  PictureModel imageSquaresPictureModel;
  dynamic priceAdjustment;
  int priceAdjustmentValue;
  bool isPreSelected;
  int pictureId;
  bool customerEntersQty;
  int quantity;
  int id;
  CustomProperties customProperties;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        name: valueNameValues.map![json["Name"]],
        colorSquaresRgb: json["ColorSquaresRgb"],
        imageSquaresPictureModel:
            PictureModel.fromJson(json["ImageSquaresPictureModel"]),
        priceAdjustment: json["PriceAdjustment"],
        priceAdjustmentValue: json["PriceAdjustmentValue"],
        isPreSelected: json["IsPreSelected"],
        pictureId: json["PictureId"],
        customerEntersQty: json["CustomerEntersQty"],
        quantity: json["Quantity"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": valueNameValues.reverse[name],
        "ColorSquaresRgb": colorSquaresRgb,
        "ImageSquaresPictureModel": imageSquaresPictureModel.toJson(),
        "PriceAdjustment": priceAdjustment,
        "PriceAdjustmentValue": priceAdjustmentValue,
        "IsPreSelected": isPreSelected,
        "PictureId": pictureId,
        "CustomerEntersQty": customerEntersQty,
        "Quantity": quantity,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

enum ValueName { ADDITIONAL_CHARGES }

final valueNameValues =
    EnumValues({"Additional Charges": ValueName.ADDITIONAL_CHARGES});

class ProductPrice {
  ProductPrice({
    required this.currencyCode,
    required this.oldPrice,
    required this.price,
    required this.priceWithDiscount,
    required this.priceValue,
    required this.customerEntersPrice,
    required this.callForPrice,
    required this.productId,
    required this.hidePrices,
    required this.isRental,
    required this.rentalPrice,
    required this.displayTaxShippingInfo,
    required this.basePricePAngV,
    required this.customProperties,
  });

  CurrencyCode? currencyCode;
  dynamic oldPrice;
  String price;
  String priceWithDiscount;
  double priceValue;
  bool customerEntersPrice;
  bool callForPrice;
  int productId;
  bool hidePrices;
  bool isRental;
  dynamic rentalPrice;
  bool displayTaxShippingInfo;
  dynamic basePricePAngV;
  CustomProperties customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        currencyCode: currencyCodeValues.map![json["CurrencyCode"]],
        oldPrice: json["OldPrice"],
        price: json["Price"],
        priceWithDiscount: json["PriceWithDiscount"] == null
            ? null
            : json["PriceWithDiscount"],
        priceValue: json["PriceValue"].toDouble(),
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
        "CurrencyCode": currencyCodeValues.reverse[currencyCode],
        "OldPrice": oldPrice,
        "Price": price,
        "PriceWithDiscount":
            priceWithDiscount == null ? null : priceWithDiscount,
        "PriceValue": priceValue,
        "CustomerEntersPrice": customerEntersPrice,
        "CallForPrice": callForPrice,
        "ProductId": productId,
        "HidePrices": hidePrices,
        "IsRental": isRental,
        "RentalPrice": rentalPrice,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "BasePricePAngV": basePricePAngV,
        "CustomProperties": customProperties.toJson(),
      };
}

enum CurrencyCode { AED }

final currencyCodeValues = EnumValues({"AED": CurrencyCode.AED});

class ProductReviewOverview {
  ProductReviewOverview({
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

class VendorModel {
  VendorModel({
    required this.name,
    required this.seName,
    required this.productCount,
    required this.id,
    required this.customProperties,
  });

  String name;
  String seName;
  int productCount;
  int id;
  CustomProperties customProperties;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        name: json["Name"] == null ? null : json["Name"],
        seName: json["SeName"] == null ? null : json["SeName"],
        productCount:
            json["ProductCount"] == null ? null : json["ProductCount"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name == null ? null : name,
        "SeName": seName == null ? null : seName,
        "ProductCount": productCount == null ? null : productCount,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class SubCategory {
  SubCategory({
    required this.name,
    required this.seName,
    required this.description,
    required this.pictureModel,
  });

  String name;
  String seName;
  String description;
  PictureModel pictureModel;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        name: json["Name"],
        seName: json["SeName"],
        description: json["Description"] == null ? null : json["Description"],
        pictureModel: PictureModel.fromJson(json["PictureModel"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SeName": seName,
        "Description": description == null ? null : description,
        "PictureModel": pictureModel.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
