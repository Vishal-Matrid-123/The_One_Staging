// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.listCart,
    required this.orderTotalsModel,
  });

  ListCart listCart;
  OrderTotalsModel orderTotalsModel;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        // String idm = '$id'.toString()

        listCart: ListCart.fromJson(json["ListCart"]),
        orderTotalsModel: OrderTotalsModel.fromJson(json["orderTotalsModel"]),
      );

  Map<String, dynamic> toJson() => {
        "ListCart": listCart.toJson(),
        "orderTotalsModel": orderTotalsModel.toJson(),
      };
}

class ListCart {
  ListCart({
    required this.id,
    required this.onePageCheckoutEnabled,
    required this.showSku,
    required this.showProductImages,
    required this.isEditable,
    required this.items,
    required this.checkoutAttributes,
    required this.warnings,
    this.minOrderSubtotalWarning,
    required this.displayTaxShippingInfo,
    required this.termsOfServiceOnShoppingCartPage,
    required this.termsOfServiceOnOrderConfirmPage,
    required this.termsOfServicePopup,
    required this.discountBox,
    required this.giftCardBox,
    required this.orderReviewData,
    required this.buttonPaymentMethodViewComponentNames,
    required this.hideCheckoutButton,
    required this.customProperties,
  });

  String id;
  bool onePageCheckoutEnabled;
  bool showSku;
  bool showProductImages;
  bool isEditable;
  List<CartItems> items;
  List<dynamic> checkoutAttributes;
  List<dynamic> warnings;
  dynamic minOrderSubtotalWarning;
  bool displayTaxShippingInfo;
  bool termsOfServiceOnShoppingCartPage;
  bool termsOfServiceOnOrderConfirmPage;
  bool termsOfServicePopup;
  DiscountBox discountBox;
  GiftCardBox giftCardBox;
  OrderReviewData orderReviewData;
  List<dynamic> buttonPaymentMethodViewComponentNames;
  bool hideCheckoutButton;
  Custom customProperties;

  factory ListCart.fromJson(Map<String, dynamic> json) => ListCart(
        id: json["\u0024id"],
        onePageCheckoutEnabled: json["OnePageCheckoutEnabled"],
        showSku: json["ShowSku"],
        showProductImages: json["ShowProductImages"],
        isEditable: json["IsEditable"],
        items: List<CartItems>.from(
            json["Items"].map((x) => CartItems.fromJson(x))),
        checkoutAttributes:
            List<dynamic>.from(json["CheckoutAttributes"].map((x) => x)),
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        minOrderSubtotalWarning: json["MinOrderSubtotalWarning"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        termsOfServiceOnShoppingCartPage:
            json["TermsOfServiceOnShoppingCartPage"],
        termsOfServiceOnOrderConfirmPage:
            json["TermsOfServiceOnOrderConfirmPage"],
        termsOfServicePopup: json["TermsOfServicePopup"],
        discountBox: DiscountBox.fromJson(json["DiscountBox"]),
        giftCardBox: GiftCardBox.fromJson(json["GiftCardBox"]),
        orderReviewData: OrderReviewData.fromJson(json["OrderReviewData"]),
        buttonPaymentMethodViewComponentNames: List<dynamic>.from(
            json["ButtonPaymentMethodViewComponentNames"].map((x) => x)),
        hideCheckoutButton: json["HideCheckoutButton"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "OnePageCheckoutEnabled": onePageCheckoutEnabled,
        "ShowSku": showSku,
        "ShowProductImages": showProductImages,
        "IsEditable": isEditable,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "CheckoutAttributes":
            List<dynamic>.from(checkoutAttributes.map((x) => x)),
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "MinOrderSubtotalWarning": minOrderSubtotalWarning,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "TermsOfServiceOnShoppingCartPage": termsOfServiceOnShoppingCartPage,
        "TermsOfServiceOnOrderConfirmPage": termsOfServiceOnOrderConfirmPage,
        "TermsOfServicePopup": termsOfServicePopup,
        "DiscountBox": discountBox.toJson(),
        "GiftCardBox": giftCardBox.toJson(),
        "OrderReviewData": orderReviewData.toJson(),
        "ButtonPaymentMethodViewComponentNames": List<dynamic>.from(
            buttonPaymentMethodViewComponentNames.map((x) => x)),
        "HideCheckoutButton": hideCheckoutButton,
        "CustomProperties": customProperties.toJson(),
      };
}

class Custom {
  Custom({
    required this.id,
  });

  String id;

  factory Custom.fromJson(Map<String, dynamic> json) => Custom(
        id: json["\u0024id"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
      };
}

class DiscountBox {
  DiscountBox({
    required this.id,
    required this.appliedDiscountsWithCodes,
    required this.display,
    required this.messages,
    required this.isApplied,
    required this.customProperties,
  });

  String id;
  List<dynamic> appliedDiscountsWithCodes;
  bool display;
  List<dynamic> messages;
  bool isApplied;
  Custom customProperties;

  factory DiscountBox.fromJson(Map<String, dynamic> json) => DiscountBox(
        id: json["\u0024id"],
        appliedDiscountsWithCodes:
            List<dynamic>.from(json["AppliedDiscountsWithCodes"].map((x) => x)),
        display: json["Display"],
        messages: List<dynamic>.from(json["Messages"].map((x) => x)),
        isApplied: json["IsApplied"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "AppliedDiscountsWithCodes":
            List<dynamic>.from(appliedDiscountsWithCodes.map((x) => x)),
        "Display": display,
        "Messages": List<dynamic>.from(messages.map((x) => x)),
        "IsApplied": isApplied,
        "CustomProperties": customProperties.toJson(),
      };
}

class GiftCardBox {
  GiftCardBox({
    required this.id,
    required this.display,
    this.message,
    required this.isApplied,
    required this.customProperties,
  });

  String id;
  bool display;
  dynamic message;
  bool isApplied;
  Custom customProperties;

  factory GiftCardBox.fromJson(Map<String, dynamic> json) => GiftCardBox(
        id: json["\u0024id"],
        display: json["Display"],
        message: json["Message"],
        isApplied: json["IsApplied"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "Display": display,
        "Message": message,
        "IsApplied": isApplied,
        "CustomProperties": customProperties.toJson(),
      };
}

class CartItems {
  CartItems({
    required this.id,
    required this.sku,
    required this.picture,
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.unitPrice,
    required this.subTotal,
    required this.discount,
    this.maximumDiscountedQty,
    required this.quantity,
    required this.allowedQuantities,
    required this.attributeInfo,
    this.recurringInfo,
    this.rentalInfo,
    required this.allowItemEditing,
    required this.disableRemoval,
    required this.warnings,
    required this.itemId,
    required this.customProperties,
  });

  String id;
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
  bool disableRemoval;
  List<dynamic> warnings;
  int itemId;
  Custom customProperties;

  factory CartItems.fromJson(Map<String, dynamic> json) => CartItems(
        id: json["\u0024id"],
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
        disableRemoval: json["DisableRemoval"],
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        itemId: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
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
        "DisableRemoval": disableRemoval,
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "Id": itemId,
        "CustomProperties": customProperties.toJson(),
      };
}

class Picture {
  Picture({
    required this.id,
    required this.imageUrl,
    this.thumbImageUrl,
    this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.customProperties,
  });

  String id;
  String imageUrl;
  dynamic thumbImageUrl;
  dynamic fullSizeImageUrl;
  String title;
  String alternateText;
  Custom customProperties;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        id: json["\u0024id"],
        imageUrl: json["ImageUrl"],
        thumbImageUrl: json["ThumbImageUrl"],
        fullSizeImageUrl: json["FullSizeImageUrl"],
        title: json["Title"],
        alternateText: json["AlternateText"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "ImageUrl": imageUrl,
        "ThumbImageUrl": thumbImageUrl,
        "FullSizeImageUrl": fullSizeImageUrl,
        "Title": title,
        "AlternateText": alternateText,
        "CustomProperties": customProperties.toJson(),
      };
}

class OrderReviewData {
  OrderReviewData({
    required this.id,
    required this.display,
    required this.billingAddress,
    required this.isShippable,
    required this.shippingAddress,
    required this.selectedPickUpInStore,
    required this.pickupAddress,
    this.shippingMethod,
    this.paymentMethod,
    required this.customValues,
    required this.customProperties,
  });

  String id;
  bool display;
  Address billingAddress;
  bool isShippable;
  Address shippingAddress;
  bool selectedPickUpInStore;
  Address pickupAddress;
  dynamic shippingMethod;
  dynamic paymentMethod;
  Custom customValues;
  Custom customProperties;

  factory OrderReviewData.fromJson(Map<String, dynamic> json) =>
      OrderReviewData(
        id: json["\u0024id"],
        display: json["Display"],
        billingAddress: Address.fromJson(json["BillingAddress"]),
        isShippable: json["IsShippable"],
        shippingAddress: Address.fromJson(json["ShippingAddress"]),
        selectedPickUpInStore: json["SelectedPickUpInStore"],
        pickupAddress: Address.fromJson(json["PickupAddress"]),
        shippingMethod: json["ShippingMethod"],
        paymentMethod: json["PaymentMethod"],
        customValues: Custom.fromJson(json["CustomValues"]),
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "Display": display,
        "BillingAddress": billingAddress.toJson(),
        "IsShippable": isShippable,
        "ShippingAddress": shippingAddress.toJson(),
        "SelectedPickUpInStore": selectedPickUpInStore,
        "PickupAddress": pickupAddress.toJson(),
        "ShippingMethod": shippingMethod,
        "PaymentMethod": paymentMethod,
        "CustomValues": customValues.toJson(),
        "CustomProperties": customProperties.toJson(),
      };
}

class Address {
  Address({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.companyEnabled,
    required this.companyRequired,
    this.company,
    required this.countryEnabled,
    this.countryId,
    this.countryName,
    required this.stateProvinceEnabled,
    this.stateProvinceId,
    this.stateProvinceName,
    required this.cityEnabled,
    required this.cityRequired,
    this.city,
    required this.streetAddressEnabled,
    required this.streetAddressRequired,
    this.address1,
    required this.streetAddress2Enabled,
    required this.streetAddress2Required,
    this.address2,
    required this.zipPostalCodeEnabled,
    required this.zipPostalCodeRequired,
    this.zipPostalCode,
    required this.phoneEnabled,
    required this.phoneRequired,
    this.phoneNumber,
    required this.faxEnabled,
    required this.faxRequired,
    this.faxNumber,
    required this.availableCountries,
    required this.availableStates,
    this.formattedCustomAddressAttributes,
    required this.customAddressAttributes,
    required this.addressId,
    required this.customProperties,
  });

  String id;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  bool companyEnabled;
  bool companyRequired;
  dynamic company;
  bool countryEnabled;
  dynamic countryId;
  dynamic countryName;
  bool stateProvinceEnabled;
  dynamic stateProvinceId;
  dynamic stateProvinceName;
  bool cityEnabled;
  bool cityRequired;
  dynamic city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  dynamic address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  dynamic address2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  dynamic phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  List<dynamic> availableCountries;
  List<dynamic> availableStates;
  dynamic formattedCustomAddressAttributes;
  List<dynamic> customAddressAttributes;
  int addressId;
  Custom customProperties;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["\u0024id"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        companyEnabled: json["CompanyEnabled"],
        companyRequired: json["CompanyRequired"],
        company: json["Company"],
        countryEnabled: json["CountryEnabled"],
        countryId: json["CountryId"],
        countryName: json["CountryName"],
        stateProvinceEnabled: json["StateProvinceEnabled"],
        stateProvinceId: json["StateProvinceId"],
        stateProvinceName: json["StateProvinceName"],
        cityEnabled: json["CityEnabled"],
        cityRequired: json["CityRequired"],
        city: json["City"],
        streetAddressEnabled: json["StreetAddressEnabled"],
        streetAddressRequired: json["StreetAddressRequired"],
        address1: json["Address1"],
        streetAddress2Enabled: json["StreetAddress2Enabled"],
        streetAddress2Required: json["StreetAddress2Required"],
        address2: json["Address2"],
        zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
        zipPostalCodeRequired: json["ZipPostalCodeRequired"],
        zipPostalCode: json["ZipPostalCode"],
        phoneEnabled: json["PhoneEnabled"],
        phoneRequired: json["PhoneRequired"],
        phoneNumber: json["PhoneNumber"],
        faxEnabled: json["FaxEnabled"],
        faxRequired: json["FaxRequired"],
        faxNumber: json["FaxNumber"],
        availableCountries:
            List<dynamic>.from(json["AvailableCountries"].map((x) => x)),
        availableStates:
            List<dynamic>.from(json["AvailableStates"].map((x) => x)),
        formattedCustomAddressAttributes:
            json["FormattedCustomAddressAttributes"],
        customAddressAttributes:
            List<dynamic>.from(json["CustomAddressAttributes"].map((x) => x)),
        addressId: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "Company": company,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId,
        "CountryName": countryName,
        "StateProvinceEnabled": stateProvinceEnabled,
        "StateProvinceId": stateProvinceId,
        "StateProvinceName": stateProvinceName,
        "CityEnabled": cityEnabled,
        "CityRequired": cityRequired,
        "City": city,
        "StreetAddressEnabled": streetAddressEnabled,
        "StreetAddressRequired": streetAddressRequired,
        "Address1": address1,
        "StreetAddress2Enabled": streetAddress2Enabled,
        "StreetAddress2Required": streetAddress2Required,
        "Address2": address2,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "ZipPostalCode": zipPostalCode,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber,
        "AvailableCountries":
            List<dynamic>.from(availableCountries.map((x) => x)),
        "AvailableStates": List<dynamic>.from(availableStates.map((x) => x)),
        "FormattedCustomAddressAttributes": formattedCustomAddressAttributes,
        "CustomAddressAttributes":
            List<dynamic>.from(customAddressAttributes.map((x) => x)),
        "Id": addressId,
        "CustomProperties": customProperties.toJson(),
      };
}

class OrderTotalsModel {
  OrderTotalsModel({
    required this.id,
    required this.isEditable,
    required this.subTotal,
    required this.subTotalDiscount,
    required this.shipping,
    required this.requiresShipping,
    this.selectedShippingMethod,
    required this.hideShippingTotal,
    this.paymentMethodAdditionalFee,
    required this.tax,
    required this.taxRates,
    required this.displayTax,
    required this.displayTaxRates,
    required this.giftCards,
    this.orderTotalDiscount,
    required this.redeemedRewardPoints,
    this.redeemedRewardPointsAmount,
    required this.willEarnRewardPoints,
    required this.orderTotal,
    required this.customProperties,
  });

  String id;
  bool isEditable;
  String subTotal;
  String subTotalDiscount;
  String shipping;
  bool requiresShipping;
  dynamic selectedShippingMethod;
  bool hideShippingTotal;
  dynamic paymentMethodAdditionalFee;
  String tax;
  List<TaxRate> taxRates;
  bool displayTax;
  bool displayTaxRates;
  List<dynamic> giftCards;
  dynamic orderTotalDiscount;
  int redeemedRewardPoints;
  dynamic redeemedRewardPointsAmount;
  int willEarnRewardPoints;
  String orderTotal;
  Custom customProperties;

  factory OrderTotalsModel.fromJson(Map<String, dynamic> json) =>
      OrderTotalsModel(
        id: json["id"],
        isEditable: json["IsEditable"],
        subTotal: json["SubTotal"],
        subTotalDiscount: json["SubTotalDiscount"],
        shipping: json["Shipping"],
        requiresShipping: json["RequiresShipping"],
        selectedShippingMethod: json["SelectedShippingMethod"],
        hideShippingTotal: json["HideShippingTotal"],
        paymentMethodAdditionalFee: json["PaymentMethodAdditionalFee"],
        tax: json["Tax"],
        taxRates: List<TaxRate>.from(
            json["TaxRates"].map((x) => TaxRate.fromJson(x))),
        displayTax: json["DisplayTax"],
        displayTaxRates: json["DisplayTaxRates"],
        giftCards: List<dynamic>.from(json["GiftCards"].map((x) => x)),
        orderTotalDiscount: json["OrderTotalDiscount"],
        redeemedRewardPoints: json["RedeemedRewardPoints"],
        redeemedRewardPointsAmount: json["RedeemedRewardPointsAmount"],
        willEarnRewardPoints: json["WillEarnRewardPoints"],
        orderTotal:
            json["OrderTotal"] == null ? 'During Checkout' : json["OrderTotal"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "IsEditable": isEditable,
        "SubTotal": subTotal,
        "SubTotalDiscount": subTotalDiscount,
        "Shipping": shipping,
        "RequiresShipping": requiresShipping,
        "SelectedShippingMethod": selectedShippingMethod,
        "HideShippingTotal": hideShippingTotal,
        "PaymentMethodAdditionalFee": paymentMethodAdditionalFee,
        "Tax": tax,
        "TaxRates": List<dynamic>.from(taxRates.map((x) => x.toJson())),
        "DisplayTax": displayTax,
        "DisplayTaxRates": displayTaxRates,
        "GiftCards": List<dynamic>.from(giftCards.map((x) => x)),
        "OrderTotalDiscount": orderTotalDiscount,
        "RedeemedRewardPoints": redeemedRewardPoints,
        "RedeemedRewardPointsAmount": redeemedRewardPointsAmount,
        "WillEarnRewardPoints": willEarnRewardPoints,
        "OrderTotal": orderTotal == null ? "During Checkout" : orderTotal,
        "CustomProperties": customProperties.toJson(),
      };
}

class TaxRate {
  TaxRate({
    required this.id,
    required this.rate,
    required this.value,
    required this.customProperties,
  });

  String id;
  String rate;
  String value;
  Custom customProperties;

  factory TaxRate.fromJson(Map<String, dynamic> json) => TaxRate(
        id: json["\u0024id"],
        rate: json["Rate"],
        value: json["Value"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "Rate": rate,
        "Value": value,
        "CustomProperties": customProperties.toJson(),
      };
}
