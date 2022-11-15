// To parse this JSON data, do
//
//     final myOrderDetailsResponse = myOrderDetailsResponseFromJson(jsonString);

import 'dart:convert';

MyOrderDetailsResponse myOrderDetailsResponseFromJson(String str) =>
    MyOrderDetailsResponse.fromJson(json.decode(str));

String myOrderDetailsResponseToJson(MyOrderDetailsResponse data) =>
    json.encode(data.toJson());

class MyOrderDetailsResponse {
  MyOrderDetailsResponse({
    required this.orderdetail,
    required this.error,
  });

  Orderdetail orderdetail;
  dynamic error;

  factory MyOrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      MyOrderDetailsResponse(
        orderdetail: Orderdetail.fromJson(json["orderdetail"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "orderdetail": orderdetail.toJson(),
        "error": error,
      };
}

class Orderdetail {
  Orderdetail({
    required this.orderDetailsModel,
    required this.pictureList,
  });

  OrderDetailsModel orderDetailsModel;
  PictureList pictureList;

  factory Orderdetail.fromJson(Map<String, dynamic> json) => Orderdetail(
        orderDetailsModel:
            OrderDetailsModel.fromJson(json["orderDetailsModel"]),
        pictureList: PictureList.fromJson(json["PictureList"]),
      );

  Map<String, dynamic> toJson() => {
        "orderDetailsModel": orderDetailsModel.toJson(),
        "PictureList": pictureList.toJson(),
      };
}

class OrderDetailsModel {
  OrderDetailsModel({
    required this.printMode,
    required this.pdfInvoiceDisabled,
    required this.customOrderNumber,
    required this.createdOn,
    required this.orderStatus,
    required this.isReOrderAllowed,
    required this.isReturnRequestAllowed,
    required this.isShippable,
    required this.pickUpInStore,
    required this.pickupAddress,
    required this.shippingStatus,
    required this.shippingAddress,
    required this.shippingMethod,
    required this.shipments,
    required this.billingAddress,
    required this.vatNumber,
    required this.paymentMethod,
    required this.paymentMethodStatus,
    required this.canRePostProcessPayment,
    required this.customValues,
    required this.orderSubtotal,
    required this.orderSubTotalDiscount,
    required this.orderShipping,
    required this.paymentMethodAdditionalFee,
    required this.checkoutAttributeInfo,
    required this.pricesIncludeTax,
    required this.displayTaxShippingInfo,
    required this.tax,
    required this.taxRates,
    required this.displayTax,
    required this.displayTaxRates,
    required this.orderTotalDiscount,
    required this.redeemedRewardPoints,
    required this.redeemedRewardPointsAmount,
    required this.orderTotal,
    required this.giftCards,
    required this.showSku,
    required this.items,
    required this.orderNotes,
    required this.id,
    required this.customProperties,
  });

  bool printMode;
  bool pdfInvoiceDisabled;
  String customOrderNumber;
  DateTime createdOn;
  String orderStatus;
  bool isReOrderAllowed;
  bool isReturnRequestAllowed;
  bool isShippable;
  bool pickUpInStore;
  Address pickupAddress;
  String shippingStatus;
  Address shippingAddress;
  String shippingMethod;
  List<dynamic> shipments;
  Address billingAddress;
  String vatNumber;
  String paymentMethod;
  String paymentMethodStatus;
  bool canRePostProcessPayment;
  Custom customValues;
  String orderSubtotal;
  dynamic orderSubTotalDiscount;
  String orderShipping;
  dynamic paymentMethodAdditionalFee;
  String checkoutAttributeInfo;
  bool pricesIncludeTax;
  bool displayTaxShippingInfo;
  String tax;
  List<TaxRate> taxRates;
  bool displayTax;
  bool displayTaxRates;
  dynamic orderTotalDiscount;
  int redeemedRewardPoints;
  dynamic redeemedRewardPointsAmount;
  String orderTotal;
  List<dynamic> giftCards;
  bool showSku;
  List<Item> items;
  List<dynamic> orderNotes;
  int id;
  Custom customProperties;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        printMode: json["PrintMode"],
        pdfInvoiceDisabled: json["PdfInvoiceDisabled"],
        customOrderNumber: json["CustomOrderNumber"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        orderStatus: json["OrderStatus"],
        isReOrderAllowed: json["IsReOrderAllowed"],
        isReturnRequestAllowed: json["IsReturnRequestAllowed"],
        isShippable: json["IsShippable"],
        pickUpInStore: json["PickUpInStore"],
        pickupAddress: Address.fromJson(json["PickupAddress"]),
        shippingStatus: json["ShippingStatus"],
        shippingAddress: Address.fromJson(json["ShippingAddress"]),
        shippingMethod: json["ShippingMethod"],
        shipments: List<dynamic>.from(json["Shipments"].map((x) => x)),
        billingAddress: Address.fromJson(json["BillingAddress"]),
        vatNumber: json["VatNumber"],
        paymentMethod: json["PaymentMethod"],
        paymentMethodStatus: json["PaymentMethodStatus"],
        canRePostProcessPayment: json["CanRePostProcessPayment"],
        customValues: Custom.fromJson(json["CustomValues"]),
        orderSubtotal: json["OrderSubtotal"],
        orderSubTotalDiscount: json["OrderSubTotalDiscount"],
        orderShipping: json["OrderShipping"],
        paymentMethodAdditionalFee: json["PaymentMethodAdditionalFee"],
        checkoutAttributeInfo: json["CheckoutAttributeInfo"],
        pricesIncludeTax: json["PricesIncludeTax"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        tax: json["Tax"],
        taxRates: List<TaxRate>.from(
            json["TaxRates"].map((x) => TaxRate.fromJson(x))),
        displayTax: json["DisplayTax"],
        displayTaxRates: json["DisplayTaxRates"],
        orderTotalDiscount: json["OrderTotalDiscount"],
        redeemedRewardPoints: json["RedeemedRewardPoints"],
        redeemedRewardPointsAmount: json["RedeemedRewardPointsAmount"],
        orderTotal: json["OrderTotal"],
        giftCards: List<dynamic>.from(json["GiftCards"].map((x) => x)),
        showSku: json["ShowSku"],
        items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
        orderNotes: List<dynamic>.from(json["OrderNotes"].map((x) => x)),
        id: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PrintMode": printMode,
        "PdfInvoiceDisabled": pdfInvoiceDisabled,
        "CustomOrderNumber": customOrderNumber,
        "CreatedOn": createdOn.toIso8601String(),
        "OrderStatus": orderStatus,
        "IsReOrderAllowed": isReOrderAllowed,
        "IsReturnRequestAllowed": isReturnRequestAllowed,
        "IsShippable": isShippable,
        "PickUpInStore": pickUpInStore,
        "PickupAddress": pickupAddress.toJson(),
        "ShippingStatus": shippingStatus,
        "ShippingAddress": shippingAddress.toJson(),
        "ShippingMethod": shippingMethod,
        "Shipments": List<dynamic>.from(shipments.map((x) => x)),
        "BillingAddress": billingAddress.toJson(),
        "VatNumber": vatNumber,
        "PaymentMethod": paymentMethod,
        "PaymentMethodStatus": paymentMethodStatus,
        "CanRePostProcessPayment": canRePostProcessPayment,
        "CustomValues": customValues.toJson(),
        "OrderSubtotal": orderSubtotal,
        "OrderSubTotalDiscount": orderSubTotalDiscount,
        "OrderShipping": orderShipping,
        "PaymentMethodAdditionalFee": paymentMethodAdditionalFee,
        "CheckoutAttributeInfo": checkoutAttributeInfo,
        "PricesIncludeTax": pricesIncludeTax,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "Tax": tax,
        "TaxRates": List<dynamic>.from(taxRates.map((x) => x.toJson())),
        "DisplayTax": displayTax,
        "DisplayTaxRates": displayTaxRates,
        "OrderTotalDiscount": orderTotalDiscount,
        "RedeemedRewardPoints": redeemedRewardPoints,
        "RedeemedRewardPointsAmount": redeemedRewardPointsAmount,
        "OrderTotal": orderTotal,
        "GiftCards": List<dynamic>.from(giftCards.map((x) => x)),
        "ShowSku": showSku,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "OrderNotes": List<dynamic>.from(orderNotes.map((x) => x)),
        "Id": id,
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

  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  dynamic company;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  dynamic stateProvinceId;
  dynamic stateProvinceName;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  dynamic address2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  List<dynamic> availableCountries;
  List<dynamic> availableStates;
  String formattedCustomAddressAttributes;
  List<dynamic> customAddressAttributes;
  int id;
  Custom customProperties;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        firstName: json["FirstName"] == null ? null : json["FirstName"],
        lastName: json["LastName"] == null ? null : json["LastName"],
        email: json["Email"] == null ? null : json["Email"],
        companyEnabled: json["CompanyEnabled"],
        companyRequired: json["CompanyRequired"],
        company: json["Company"],
        countryEnabled: json["CountryEnabled"],
        countryId: json["CountryId"] == null ? null : json["CountryId"],
        countryName: json["CountryName"] == null ? null : json["CountryName"],
        stateProvinceEnabled: json["StateProvinceEnabled"],
        stateProvinceId: json["StateProvinceId"],
        stateProvinceName: json["StateProvinceName"],
        cityEnabled: json["CityEnabled"],
        cityRequired: json["CityRequired"],
        city: json["City"] == null ? null : json["City"],
        streetAddressEnabled: json["StreetAddressEnabled"],
        streetAddressRequired: json["StreetAddressRequired"],
        address1: json["Address1"] == null ? null : json["Address1"],
        streetAddress2Enabled: json["StreetAddress2Enabled"],
        streetAddress2Required: json["StreetAddress2Required"],
        address2: json["Address2"],
        zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
        zipPostalCodeRequired: json["ZipPostalCodeRequired"],
        zipPostalCode: json["ZipPostalCode"],
        phoneEnabled: json["PhoneEnabled"],
        phoneRequired: json["PhoneRequired"],
        phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
        faxEnabled: json["FaxEnabled"],
        faxRequired: json["FaxRequired"],
        faxNumber: json["FaxNumber"],
        availableCountries:
            List<dynamic>.from(json["AvailableCountries"].map((x) => x)),
        availableStates:
            List<dynamic>.from(json["AvailableStates"].map((x) => x)),
        formattedCustomAddressAttributes:
            json["FormattedCustomAddressAttributes"] == null
                ? null
                : json["FormattedCustomAddressAttributes"],
        customAddressAttributes:
            List<dynamic>.from(json["CustomAddressAttributes"].map((x) => x)),
        id: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName == null ? null : firstName,
        "LastName": lastName == null ? null : lastName,
        "Email": email == null ? null : email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "Company": company,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId == null ? null : countryId,
        "CountryName": countryName == null ? null : countryName,
        "StateProvinceEnabled": stateProvinceEnabled,
        "StateProvinceId": stateProvinceId,
        "StateProvinceName": stateProvinceName,
        "CityEnabled": cityEnabled,
        "CityRequired": cityRequired,
        "City": city == null ? null : city,
        "StreetAddressEnabled": streetAddressEnabled,
        "StreetAddressRequired": streetAddressRequired,
        "Address1": address1 == null ? null : address1,
        "StreetAddress2Enabled": streetAddress2Enabled,
        "StreetAddress2Required": streetAddress2Required,
        "Address2": address2,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "ZipPostalCode": zipPostalCode,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber == null ? null : phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber,
        "AvailableCountries":
            List<dynamic>.from(availableCountries.map((x) => x)),
        "AvailableStates": List<dynamic>.from(availableStates.map((x) => x)),
        "FormattedCustomAddressAttributes":
            formattedCustomAddressAttributes == null
                ? null
                : formattedCustomAddressAttributes,
        "CustomAddressAttributes":
            List<dynamic>.from(customAddressAttributes.map((x) => x)),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class Custom {
  Custom();

  factory Custom.fromJson(Map<String, dynamic> json) => Custom();

  Map<String, dynamic> toJson() => {};
}

class Item {
  Item({
    required this.orderItemGuid,
    required this.sku,
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.unitPrice,
    required this.subTotal,
    required this.quantity,
    required this.attributeInfo,
    required this.rentalInfo,
    required this.downloadId,
    required this.licenseId,
    required this.id,
    required this.customProperties,
  });

  String orderItemGuid;
  String sku;
  int productId;
  String productName;
  String productSeName;
  String unitPrice;
  String subTotal;
  int quantity;
  String attributeInfo;
  dynamic rentalInfo;
  int downloadId;
  int licenseId;
  int id;
  Custom customProperties;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        orderItemGuid: json["OrderItemGuid"],
        sku: json["Sku"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        unitPrice: json["UnitPrice"],
        subTotal: json["SubTotal"],
        quantity: json["Quantity"],
        attributeInfo: json["AttributeInfo"],
        rentalInfo: json["RentalInfo"],
        downloadId: json["DownloadId"],
        licenseId: json["LicenseId"],
        id: json["Id"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderItemGuid": orderItemGuid,
        "Sku": sku,
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "UnitPrice": unitPrice,
        "SubTotal": subTotal,
        "Quantity": quantity,
        "AttributeInfo": attributeInfo,
        "RentalInfo": rentalInfo,
        "DownloadId": downloadId,
        "LicenseId": licenseId,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
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

class PictureList {
  PictureList({
    required this.the35661,
  });

  String the35661;

  factory PictureList.fromJson(Map<String, dynamic> json) => PictureList(
        the35661: json["35661"],
      );

  Map<String, dynamic> toJson() => {
        "35661": the35661,
      };
}
