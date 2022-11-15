// To parse this JSON data, do
//
//     final shippingMethodsResponse = shippingMethodsResponseFromJson(jsonString);

import 'dart:convert';

ShippingMethodsResponse shippingMethodsResponseFromJson(String str) =>
    ShippingMethodsResponse.fromJson(json.decode(str));

String shippingMethodsResponseToJson(ShippingMethodsResponse data) =>
    json.encode(data.toJson());

class ShippingMethodsResponse {
  ShippingMethodsResponse({
    required this.shippingmethods,
    required this.status,
    required this.message,
    required this.storeId,
  });

  final Shippingmethods shippingmethods;
  final String status;
  final dynamic message;

  final int storeId;

  factory ShippingMethodsResponse.fromJson(Map<String, dynamic> json) =>
      ShippingMethodsResponse(
        shippingmethods: Shippingmethods.fromJson(json["shippingmethods"]),
        status: json["Status"],
        message: json["Message"],
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "shippingmethods": shippingmethods.toJson(),
        "Status": status,
        "Message": message,
        "StoreId": storeId,
      };
}

class Shippingmethods {
  Shippingmethods({
    required this.shippingMethods,
    required this.notifyCustomerAboutShippingFromMultipleLocations,
  });

  final List<ShippingMethod> shippingMethods;
  final bool notifyCustomerAboutShippingFromMultipleLocations;

  factory Shippingmethods.fromJson(Map<String, dynamic> json) =>
      Shippingmethods(
        shippingMethods: List<ShippingMethod>.from(
            json["ShippingMethods"].map((x) => ShippingMethod.fromJson(x))),
        notifyCustomerAboutShippingFromMultipleLocations:
            json["NotifyCustomerAboutShippingFromMultipleLocations"],
      );

  Map<String, dynamic> toJson() => {
        "ShippingMethods":
            List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
        "NotifyCustomerAboutShippingFromMultipleLocations":
            notifyCustomerAboutShippingFromMultipleLocations,
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class ShippingMethod {
  ShippingMethod({
    required this.shippingRateComputationMethodSystemName,
    required this.name,
    required this.description,
    required this.fee,
    required this.selected,
    required this.shippingOption,
    required this.customProperties,
  });

  final String shippingRateComputationMethodSystemName;
  final String name;
  final String description;
  final String fee;
  final bool selected;
  final String shippingOption;
  final CustomProperties customProperties;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        shippingRateComputationMethodSystemName:
            json["ShippingRateComputationMethodSystemName"],
        name: json["Name"],
        description: json["Description"],
        fee: json["Fee"],
        selected: json["Selected"],
        shippingOption: json["ShippingOption"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ShippingRateComputationMethodSystemName":
            shippingRateComputationMethodSystemName,
        "Name": name,
        "Description": description,
        "Fee": fee,
        "Selected": selected,
        "ShippingOption": shippingOption,
        "CustomProperties": customProperties.toJson(),
      };
}
