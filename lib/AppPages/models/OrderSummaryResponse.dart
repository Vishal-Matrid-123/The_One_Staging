// To parse this JSON data, do
//
//     final orderSummaryResponse = orderSummaryResponseFromJson(jsonString);

import 'dart:convert';

OrderSummaryResponse orderSummaryResponseFromJson(String str) =>
    OrderSummaryResponse.fromJson(json.decode(str));

String orderSummaryResponseToJson(OrderSummaryResponse data) =>
    json.encode(data.toJson());

class OrderSummaryResponse {
  OrderSummaryResponse({
    required this.ordersummary,
    required this.ordertotals,
    required this.error,
  });

  Ordersummary ordersummary;
  Ordertotals ordertotals;
  dynamic error;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) =>
      OrderSummaryResponse(
        ordersummary: Ordersummary.fromJson(json["ordersummary"]),
        ordertotals: Ordertotals.fromJson(json["ordertotals"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "ordersummary": ordersummary.toJson(),
        "ordertotals": ordertotals.toJson(),
        "error": error,
      };
}

class Ordersummary {
  Ordersummary({
    required this.onePageCheckoutEnabled,
    required this.showSku,
    required this.showProductImages,
    required this.isEditable,
    required this.items,
    required this.checkoutAttributes,
    required this.warnings,
    required this.minOrderSubtotalWarning,
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

  bool onePageCheckoutEnabled;
  bool showSku;
  bool showProductImages;
  bool isEditable;
  List<OrderedItems> items;
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

  factory Ordersummary.fromJson(Map<String, dynamic> json) => Ordersummary(
        onePageCheckoutEnabled: json["OnePageCheckoutEnabled"],
        showSku: json["ShowSku"],
        showProductImages: json["ShowProductImages"],
        isEditable: json["IsEditable"],
        items: List<OrderedItems>.from(
            json["Items"].map((x) => OrderedItems.fromJson(x))),
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
  Custom();

  factory Custom.fromJson(Map<String, dynamic> json) => Custom();

  Map<String, dynamic> toJson() => {};
}

class DiscountBox {
  DiscountBox({
    required this.appliedDiscountsWithCodes,
    required this.display,
    required this.messages,
    required this.isApplied,
    required this.customProperties,
  });

  List<dynamic> appliedDiscountsWithCodes;
  bool display;
  List<dynamic> messages;
  bool isApplied;
  Custom customProperties;

  factory DiscountBox.fromJson(Map<String, dynamic> json) => DiscountBox(
        appliedDiscountsWithCodes:
            List<dynamic>.from(json["AppliedDiscountsWithCodes"].map((x) => x)),
        display: json["Display"],
        messages: List<dynamic>.from(json["Messages"].map((x) => x)),
        isApplied: json["IsApplied"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
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
    required this.display,
    required this.message,
    required this.isApplied,
    required this.customProperties,
  });

  bool display;
  dynamic message;
  bool isApplied;
  Custom customProperties;

  factory GiftCardBox.fromJson(Map<String, dynamic> json) => GiftCardBox(
        display: json["Display"],
        message: json["Message"],
        isApplied: json["IsApplied"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Display": display,
        "Message": message,
        "IsApplied": isApplied,
        "CustomProperties": customProperties.toJson(),
      };
}

class OrderedItems {
  OrderedItems({
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
    required this.disableRemoval,
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
  dynamic discount;
  dynamic maximumDiscountedQty;
  int quantity;
  List<dynamic> allowedQuantities;
  String attributeInfo;
  dynamic recurringInfo;
  dynamic rentalInfo;
  bool allowItemEditing;
  bool disableRemoval;
  List<dynamic> warnings;
  int id;
  Custom customProperties;

  factory OrderedItems.fromJson(Map<String, dynamic> json) => OrderedItems(
        sku: json["Sku"],
        picture: Picture.fromJson(json["Picture"]),
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        unitPrice: json["UnitPrice"],
        subTotal: json["SubTotal"],
        discount: json["Discount"],
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
        id: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Sku": sku,
        "Picture": picture.toJson(),
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "UnitPrice": unitPrice,
        "SubTotal": subTotal,
        "Discount": discount,
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
  Custom customProperties;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        imageUrl: json["ImageUrl"],
        thumbImageUrl: json["ThumbImageUrl"],
        fullSizeImageUrl: json["FullSizeImageUrl"],
        title: json["Title"],
        alternateText: json["AlternateText"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
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

class OrderReviewData {
  OrderReviewData({
    required this.display,
    required this.billingAddress,
    required this.isShippable,
    required this.shippingAddress,
    required this.selectedPickUpInStore,
    required this.pickupAddress,
    required this.shippingMethod,
    required this.paymentMethod,
    required this.customValues,
    required this.customProperties,
  });

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
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyEnabled,
    required this.companyRequired,
    required this.company,
    required this.countryEnabled,
    required this.countryId,
    required this.countryName,
    required this.stateProvinceEnabled,
    required this.stateProvinceId,
    required this.stateProvinceName,
    required this.cityEnabled,
    required this.cityRequired,
    required this.city,
    required this.streetAddressEnabled,
    required this.streetAddressRequired,
    required this.address1,
    required this.streetAddress2Enabled,
    required this.streetAddress2Required,
    required this.address2,
    required this.zipPostalCodeEnabled,
    required this.zipPostalCodeRequired,
    required this.zipPostalCode,
    required this.phoneEnabled,
    required this.phoneRequired,
    required this.phoneNumber,
    required this.faxEnabled,
    required this.faxRequired,
    required this.faxNumber,
    required this.availableCountries,
    required this.availableStates,
    required this.formattedCustomAddressAttributes,
    required this.customAddressAttributes,
    required this.id,
    required this.customProperties,
  });

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
  int id;
  Custom customProperties;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
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
        id: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
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
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class Ordertotals {
  Ordertotals({
    required this.isEditable,
    required this.subTotal,
    required this.subTotalDiscount,
    required this.shipping,
    required this.requiresShipping,
    required this.selectedShippingMethod,
    required this.hideShippingTotal,
    required this.paymentMethodAdditionalFee,
    required this.tax,
    required this.taxRates,
    required this.displayTax,
    required this.displayTaxRates,
    required this.giftCards,
    required this.orderTotalDiscount,
    required this.redeemedRewardPoints,
    required this.redeemedRewardPointsAmount,
    required this.willEarnRewardPoints,
    required this.orderTotal,
  });

  bool isEditable;
  String subTotal;
  dynamic subTotalDiscount;
  String shipping;
  bool requiresShipping;
  String selectedShippingMethod;
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

  factory Ordertotals.fromJson(Map<String, dynamic> json) => Ordertotals(
        isEditable: json["IsEditable"],
        subTotal: json["SubTotal"],
        subTotalDiscount: json["SubTotalDiscount"],
        shipping: json["Shipping"] ?? "",
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
        orderTotal: json["OrderTotal"] ?? "",
      );

  Map<String, dynamic> toJson() => {
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
        "OrderTotal": orderTotal,
      };
}

class TaxRate {
  TaxRate({
    required this.rate,
    required this.value,
    required this.customProperties,
  });

  String rate;
  String value;
  Custom customProperties;

  factory TaxRate.fromJson(Map<String, dynamic> json) => TaxRate(
        rate: json["Rate"],
        value: json["Value"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Rate": rate,
        "Value": value,
        "CustomProperties": customProperties.toJson(),
      };
}
