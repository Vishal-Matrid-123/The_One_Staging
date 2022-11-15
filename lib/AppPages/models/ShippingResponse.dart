// To parse this JSON data, do
//
//     final shippingResponse = shippingResponseFromJson(jsonString);

import 'dart:convert';

ShippingResponse shippingResponseFromJson(String str) =>
    ShippingResponse.fromJson(json.decode(str));

String shippingResponseToJson(ShippingResponse data) =>
    json.encode(data.toJson());

class ShippingResponse {
  ShippingResponse({
    required this.status,
    required this.message,
    required this.shippingaddresses,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final Shippingaddresses shippingaddresses;
  final int storeId;

  factory ShippingResponse.fromJson(Map<String, dynamic> json) =>
      ShippingResponse(
        status: json["status"],
        message: json["Message"],
        shippingaddresses:
            Shippingaddresses.fromJson(json["shippingaddresses"]),
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "shippingaddresses": shippingaddresses.toJson(),
        "StoreId": storeId,
      };
}

class Shippingaddresses {
  Shippingaddresses({
    required this.form,
    required this.warnings,
    required this.existingAddresses,
    required this.shippingNewAddress,
    required this.newAddressPreselected,
    required this.pickupPoints,
    required this.allowPickUpInStore,
    required this.pickUpInStore,
    required this.pickUpInStoreOnly,
    required this.displayPickupPointsOnMap,
    required this.googleMapsApiKey,
    required this.customProperties,
  });

  final dynamic form;
  final List<dynamic> warnings;
  final List<ExistingShippingAddress> existingAddresses;
  final ExistingShippingAddress shippingNewAddress;
  final bool newAddressPreselected;
  final List<PickupPoint> pickupPoints;
  final bool allowPickUpInStore;
  final bool pickUpInStore;
  final bool pickUpInStoreOnly;
  final bool displayPickupPointsOnMap;
  final String googleMapsApiKey;
  final CustomProperties customProperties;

  factory Shippingaddresses.fromJson(Map<String, dynamic> json) =>
      Shippingaddresses(
        form: json["Form"],
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        existingAddresses: List<ExistingShippingAddress>.from(
            json["ExistingAddresses"]
                .map((x) => ExistingShippingAddress.fromJson(x))),
        shippingNewAddress:
            ExistingShippingAddress.fromJson(json["ShippingNewAddress"]),
        newAddressPreselected: json["NewAddressPreselected"],
        pickupPoints: List<PickupPoint>.from(
            json["PickupPoints"].map((x) => PickupPoint.fromJson(x))),
        allowPickUpInStore: json["AllowPickUpInStore"],
        pickUpInStore: json["PickUpInStore"],
        pickUpInStoreOnly: json["PickUpInStoreOnly"],
        displayPickupPointsOnMap: json["DisplayPickupPointsOnMap"],
        googleMapsApiKey: json["GoogleMapsApiKey"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Form": form,
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "ExistingAddresses":
            List<dynamic>.from(existingAddresses.map((x) => x.toJson())),
        "ShippingNewAddress": shippingNewAddress.toJson(),
        "NewAddressPreselected": newAddressPreselected,
        "PickupPoints": List<dynamic>.from(pickupPoints.map((x) => x.toJson())),
        "AllowPickUpInStore": allowPickUpInStore,
        "PickUpInStore": pickUpInStore,
        "PickUpInStoreOnly": pickUpInStoreOnly,
        "DisplayPickupPointsOnMap": displayPickupPointsOnMap,
        "GoogleMapsApiKey": googleMapsApiKey,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class ExistingShippingAddress {
  ExistingShippingAddress({
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

  final String firstName;
  final String lastName;
  final String email;
  final bool companyEnabled;
  final bool companyRequired;
  final String company;
  final bool countryEnabled;
  final int countryId;
  final String countryName;
  final bool stateProvinceEnabled;
  final dynamic stateProvinceId;
  final dynamic stateProvinceName;
  final bool cityEnabled;
  final bool cityRequired;
  final String city;
  final bool streetAddressEnabled;
  final bool streetAddressRequired;
  final String address1;
  final bool streetAddress2Enabled;
  final bool streetAddress2Required;
  final String address2;
  final bool zipPostalCodeEnabled;
  final bool zipPostalCodeRequired;
  final String zipPostalCode;
  final bool phoneEnabled;
  final bool phoneRequired;
  final String phoneNumber;
  final bool faxEnabled;
  final bool faxRequired;
  final String faxNumber;
  final List<Available> availableCountries;
  final List<Available> availableStates;
  final String formattedCustomAddressAttributes;
  final List<dynamic> customAddressAttributes;
  final int id;
  final CustomProperties customProperties;

  factory ExistingShippingAddress.fromJson(Map<String, dynamic> json) =>
      ExistingShippingAddress(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        companyEnabled: json["CompanyEnabled"],
        companyRequired: json["CompanyRequired"],
        company: json["Company"] == null ? null : json["Company"],
        countryEnabled: json["CountryEnabled"],
        countryId: json["CountryId"] == null ? null : json["CountryId"],
        countryName: json["CountryName"] == null ? null : json["CountryName"],
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
        address2: json["Address2"] == null ? null : json["Address2"],
        zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
        zipPostalCodeRequired: json["ZipPostalCodeRequired"],
        zipPostalCode:
            json["ZipPostalCode"] == null ? null : json["ZipPostalCode"],
        phoneEnabled: json["PhoneEnabled"],
        phoneRequired: json["PhoneRequired"],
        phoneNumber: json["PhoneNumber"],
        faxEnabled: json["FaxEnabled"],
        faxRequired: json["FaxRequired"],
        faxNumber: json["FaxNumber"] == null ? null : json["FaxNumber"],
        availableCountries: List<Available>.from(
            json["AvailableCountries"].map((x) => Available.fromJson(x))),
        availableStates: List<Available>.from(
            json["AvailableStates"].map((x) => Available.fromJson(x))),
        formattedCustomAddressAttributes:
            json["FormattedCustomAddressAttributes"] == null
                ? null
                : json["FormattedCustomAddressAttributes"],
        customAddressAttributes:
            List<dynamic>.from(json["CustomAddressAttributes"].map((x) => x)),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "Company": company == null ? null : company,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId == null ? null : countryId,
        "CountryName": countryName == null ? null : countryName,
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
        "Address2": address2 == null ? null : address2,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "ZipPostalCode": zipPostalCode == null ? null : zipPostalCode,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber == null ? null : faxNumber,
        "AvailableCountries":
            List<dynamic>.from(availableCountries.map((x) => x.toJson())),
        "AvailableStates":
            List<dynamic>.from(availableStates.map((x) => x.toJson())),
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

class Available {
  Available({
    required this.disabled,
    required this.group,
    required this.selected,
    required this.text,
    required this.value,
  });

  final bool disabled;
  final dynamic group;
  final bool selected;
  final String text;
  final String value;

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

class PickupPoint {
  PickupPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.providerSystemName,
    required this.address,
    required this.city,
    required this.stateName,
    required this.countryName,
    required this.zipPostalCode,
    required this.latitude,
    required this.longitude,
    required this.pickupFee,
    required this.openingHours,
    required this.customProperties,
  });

  final String id;
  final String name;
  final String description;
  final String providerSystemName;
  final dynamic address;
  final dynamic city;
  final String stateName;
  final String countryName;
  final dynamic zipPostalCode;
  final double latitude;
  final double longitude;
  final dynamic pickupFee;
  final String openingHours;
  final CustomProperties customProperties;

  factory PickupPoint.fromJson(Map<String, dynamic> json) => PickupPoint(
        id: json["Id"],
        name: json["Name"],
        description: json["Description"],
        providerSystemName: json["ProviderSystemName"],
        address: json["Address"],
        city: json["City"],
        stateName: json["StateName"],
        countryName: json["CountryName"],
        zipPostalCode: json["ZipPostalCode"],
        latitude: json["Latitude"].toDouble(),
        longitude: json["Longitude"].toDouble(),
        pickupFee: json["PickupFee"],
        openingHours: json["OpeningHours"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Description": description,
        "ProviderSystemName": providerSystemName,
        "Address": address,
        "City": city,
        "StateName": stateName,
        "CountryName": countryName,
        "ZipPostalCode": zipPostalCode,
        "Latitude": latitude,
        "Longitude": longitude,
        "PickupFee": pickupFee,
        "OpeningHours": openingHours,
        "CustomProperties": customProperties.toJson(),
      };
}
