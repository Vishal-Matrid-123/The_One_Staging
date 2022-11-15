// To parse this JSON data, do
//
//     final myAddressResponse = myAddressResponseFromJson(jsonString);

import 'dart:convert';

MyAddressResponse myAddressResponseFromJson(String str) =>
    MyAddressResponse.fromJson(json.decode(str));

String myAddressResponseToJson(MyAddressResponse data) =>
    json.encode(data.toJson());

class MyAddressResponse {
  MyAddressResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final ResponseData responseData;
  final int storeId;

  factory MyAddressResponse.fromJson(Map<String, dynamic> json) =>
      MyAddressResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: ResponseData.fromJson(json["ResponseData"]),
        storeId: json["StoreId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData.toJson(),
        "StoreId": storeId,
      };
}

class ResponseData {
  ResponseData({
    required this.addresses,
  });

  final List<AddressList> addresses;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        addresses: List<AddressList>.from(
            json["Addresses"].map((x) => AddressList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}

class AddressList {
  AddressList({
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
  });

  final String firstName;
  final String lastName;
  final String email;
  final bool companyEnabled;
  final bool companyRequired;
  final dynamic company;
  final bool countryEnabled;
  final dynamic countryId;
  final dynamic countryName;
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
  final dynamic zipPostalCode;
  final bool phoneEnabled;
  final bool phoneRequired;
  final String phoneNumber;
  final bool faxEnabled;
  final bool faxRequired;
  final dynamic faxNumber;
  final List<Available> availableCountries;
  final List<Available> availableStates;
  final String formattedCustomAddressAttributes;
  final List<dynamic> customAddressAttributes;
  final int id;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
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
        availableCountries: List<Available>.from(
            json["AvailableCountries"].map((x) => Available.fromJson(x))),
        availableStates: List<Available>.from(
            json["AvailableStates"].map((x) => Available.fromJson(x))),
        formattedCustomAddressAttributes:
            json["FormattedCustomAddressAttributes"],
        customAddressAttributes:
            List<dynamic>.from(json["CustomAddressAttributes"].map((x) => x)),
        id: json["Id"],
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
            List<dynamic>.from(availableCountries.map((x) => x.toJson())),
        "AvailableStates":
            List<dynamic>.from(availableStates.map((x) => x.toJson())),
        "FormattedCustomAddressAttributes": formattedCustomAddressAttributes,
        "CustomAddressAttributes":
            List<dynamic>.from(customAddressAttributes.map((x) => x)),
        "Id": id,
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
