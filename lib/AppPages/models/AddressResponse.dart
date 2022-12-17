import 'dart:convert';

AddressResponse addressModelFromJson(String str) =>
    AddressResponse.fromJson(json.decode(str));

String addressModelToJson(AddressResponse data) => json.encode(data.toJson());

class AddressResponse {
  Billingaddresses billingaddresses;
  dynamic error;

  AddressResponse({required this.billingaddresses, required this.error});

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
          billingaddresses: Billingaddresses.fromJson(json["billingaddresses"]),
          error: json["Message"] ?? null);

  Map<String, dynamic> toJson() =>
      {"billingaddresses": billingaddresses, "Message": error};
}

class Billingaddresses {
  dynamic form;
  List<ExistingBillingAddresses> existingAddresses = [];
  BillingNewAddress billingNewAddress;
  bool shipToSameAddress;
  bool shipToSameAddressAllowed;
  bool newAddressPreselected;

  Billingaddresses(
      {this.form,
      required this.existingAddresses,
      required this.billingNewAddress,
      required this.shipToSameAddress,
      required this.shipToSameAddressAllowed,
      required this.newAddressPreselected});

  factory Billingaddresses.fromJson(Map<String, dynamic> json) =>
      Billingaddresses(
          billingNewAddress:
              BillingNewAddress.fromJson(json["BillingNewAddress"]),
          existingAddresses: List<ExistingBillingAddresses>.from(
              json["ExistingAddresses"]
                  .map((x) => ExistingBillingAddresses.fromJson(x))),
          shipToSameAddress: json["ShipToSameAddress"],
          shipToSameAddressAllowed: json["ShipToSameAddressAllowed"],
          newAddressPreselected: json["NewAddressPreselected"]);

  Map<String, dynamic> toJson() => {
        "BillingNewAddress": billingNewAddress.toJson(),
        "ExistingAddresses": List<ExistingBillingAddresses>.from(
            existingAddresses.map((x) => x.toJson())),
        "ShipToSameAddress": shipToSameAddress,
        "ShipToSameAddressAllowed": shipToSameAddressAllowed,
        "NewAddressPreselected": newAddressPreselected
      };
}

class ExistingBillingAddresses {
  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  String companyName;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  int id;

  ExistingBillingAddresses(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.companyEnabled,
      required this.companyRequired,
      required this.companyName,
      required this.countryEnabled,
      required this.countryId,
      required this.countryName,
      required this.stateProvinceEnabled,
      required this.cityEnabled,
      required this.cityRequired,
      required this.city,
      required this.streetAddressEnabled,
      required this.streetAddressRequired,
      required this.address1,
      required this.streetAddress2Enabled,
      required this.streetAddress2Required,
      required this.zipPostalCodeEnabled,
      required this.zipPostalCodeRequired,
      this.zipPostalCode,
      required this.phoneEnabled,
      required this.phoneRequired,
      required this.phoneNumber,
      required this.faxEnabled,
      required this.faxRequired,
      required this.faxNumber,
      required this.id});

  factory ExistingBillingAddresses.fromJson(Map<String, dynamic> json) =>
      ExistingBillingAddresses(
          firstName: json["FirstName"],
          lastName: json["LastName"],
          email: json["Email"],
          companyEnabled: json["CompanyEnabled"],
          companyRequired: json["CompanyRequired"],
          countryEnabled: json["CountryEnabled"],
          countryId: json["CountryId"],
          countryName: json["CountryName"],
          stateProvinceEnabled: json["StateProvinceEnabled"],
          cityEnabled: json["CityEnabled"],
          cityRequired: json["CityRequired"],
          city: json["City"],
          streetAddressEnabled: json["StreetAddressEnabled"],
          streetAddressRequired: json["StreetAddressRequired"],
          address1: json["Address1"],
          streetAddress2Enabled: json["StreetAddress2Enabled"],
          streetAddress2Required: json["StreetAddress2Required"],
          zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
          zipPostalCodeRequired: json["ZipPostalCodeRequired"],
          zipPostalCode: json["ZipPostalCode"],
          phoneEnabled: json["PhoneEnabled"],
          phoneRequired: json["PhoneRequired"],
          phoneNumber: json["PhoneNumber"],
          faxEnabled: json["FaxEnabled"],
          faxRequired: json["FaxRequired"],
          faxNumber: json["FaxNumber"],
          id: json["Id"],
          companyName: json["Company"]);

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId,
        "CountryName": countryName,
        "StateProvinceEnabled": stateProvinceEnabled,
        "CityEnabled": cityEnabled,
        "CityRequired": cityRequired,
        "City": city,
        "StreetAddressEnabled": streetAddressEnabled,
        "StreetAddressRequired": streetAddressRequired,
        "Address1": address1,
        "StreetAddress2Enabled": streetAddress2Enabled,
        "StreetAddress2Required": streetAddress2Required,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber,
        "Id": id

        // return data;
      };
}

class BillingNewAddress {
  String firstName;
  String lastName;
  String email;
  String city;
  String address1;
  int id;

  BillingNewAddress(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.city,
      required this.address1,
      required this.id});

  factory BillingNewAddress.fromJson(Map<String, dynamic> json) =>
      BillingNewAddress(
          firstName: json["FirstName"],
          lastName: json["LastName"],
          email: json["Email"],
          city: json["City"],
          address1: json["Address1"],
          id: json["id"]);

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        // "CompanyEnabled": companyEnabled,
        // "CompanyRequired": companyRequired,
        // "CountryEnabled": countryEnabled,
        // "StateProvinceEnabled": stateProvinceEnabled,
        // "CityEnabled": cityEnabled,
        // "CityRequired": cityRequired,
        "City": city,
        // "StreetAddressEnabled": streetAddressEnabled,
        // "StreetAddressRequired": streetAddressRequired,
        "Address1": address1,
        // "StreetAddress2Enabled": streetAddress2Enabled,
        // "StreetAddress2Required": streetAddress2Required,
        // "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        // "ZipPostalCodeRequired": zipPostalCodeRequired,
        // "PhoneEnabled": phoneEnabled,
        // "PhoneRequired": phoneRequired,
        // "PhoneNumber": phoneNumber,
        // "FaxEnabled": faxEnabled,
        // "FaxRequired": faxRequired,
        "Id": id
      };
}

class AvailableCountries {
  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;

  AvailableCountries(
      {required this.disabled,
      required this.group,
      required this.selected,
      required this.text,
      required this.value});

  factory AvailableCountries.fromJson(Map<String, dynamic> json) =>
      AvailableCountries(
          disabled: json["Disabled"],
          group: json["Group"],
          selected: json["Selected"],
          text: json["Text"],
          value: json["Value"]);

  Map<String, dynamic> toJson() => {
        "Disabled": disabled,
        "Group": group,
        "Selected": selected,
        "Text": text,
        "Value": value,
      };
}
