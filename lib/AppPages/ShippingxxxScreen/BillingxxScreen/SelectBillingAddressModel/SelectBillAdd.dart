// To parse this JSON data, do
//
//     final selectBillingAddress = selectBillingAddressFromJson(jsonString);

// import 'dart:convert';
//
// SelectBillingAddress selectBillingAddressFromJson(String str) =>
//     SelectBillingAddress.fromJson(json.decode(str));
//
// String selectBillingAddressToJson(SelectBillingAddress data) =>
//     json.encode(data.toJson());
//
// class SelectBillingAddress {
//   SelectBillingAddress({
//     required this.selectedaddress,
//     required this.error,
//   });
//
//   Selectedaddress selectedaddress;
//   dynamic error;
//
//   factory SelectBillingAddress.fromJson(Map<String, dynamic> json) =>
//       SelectBillingAddress(
//         selectedaddress: Selectedaddress.fromJson(json["selectedaddress"])!,
//         error: json["Message"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "selectedaddress": selectedaddress.toJson(),
//         "Message": error,
//       };
// }
//
// class Selectedaddress {
//   Selectedaddress({
//     required this.country,
//     required this.stateProvince,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.company,
//     required this.countryId,
//     required this.stateProvinceId,
//     required this.city,
//     required this.address1,
//     required this.address2,
//     required this.zipPostalCode,
//     required this.phoneNumber,
//     required this.faxNumber,
//     required this.customAttributes,
//     required this.createdOnUtc,
//     required this.id,
//   });
//
//   Country? country;
//   dynamic stateProvince;
//   String firstName;
//   String lastName;
//   String email;
//   dynamic company;
//   int countryId;
//   dynamic stateProvinceId;
//   String city;
//   String address1;
//   dynamic address2;
//   dynamic zipPostalCode;
//   String phoneNumber;
//   dynamic faxNumber;
//   dynamic customAttributes;
//   DateTime createdOnUtc;
//   int id;
//
//   factory Selectedaddress.fromJson(Map<String, dynamic> json) =>
//       Selectedaddress(
//         country: Country.fromJson(json["Country"] ?? null) ,
//         stateProvince: json["StateProvince"],
//         firstName: json["FirstName"] ?? '',
//         lastName: json["LastName"],
//         email: json["Email"],
//         company: json["Company"],
//         countryId: json["CountryId"],
//         stateProvinceId: json["StateProvinceId"],
//         city: json["City"],
//         address1: json["Address1"],
//         address2: json["Address2"],
//         zipPostalCode: json["ZipPostalCode"],
//         phoneNumber: json["PhoneNumber"],
//         faxNumber: json["FaxNumber"],
//         customAttributes: json["CustomAttributes"],
//         createdOnUtc: DateTime.parse(json["CreatedOnUtc"]),
//         id: json["Id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "Country": country!.toJson(),
//         "StateProvince": stateProvince,
//         "FirstName": firstName,
//         "LastName": lastName,
//         "Email": email,
//         "Company": company,
//         "CountryId": countryId,
//         "StateProvinceId": stateProvinceId,
//         "City": city,
//         "Address1": address1,
//         "Address2": address2,
//         "ZipPostalCode": zipPostalCode,
//         "PhoneNumber": phoneNumber,
//         "FaxNumber": faxNumber,
//         "CustomAttributes": customAttributes,
//         "CreatedOnUtc": createdOnUtc.toIso8601String(),
//         "Id": id,
//       };
// }
//
// class Country {
//   Country({
//     required this.restrictedShippingMethods,
//     required this.stateProvinces,
//     required this.name,
//     required this.allowsBilling,
//     required this.allowsShipping,
//     required this.twoLetterIsoCode,
//     required this.threeLetterIsoCode,
//     required this.numericIsoCode,
//     required this.subjectToVat,
//     required this.published,
//     required this.displayOrder,
//     required this.limitedToStores,
//     required this.id,
//   });
//
//   List<dynamic>? restrictedShippingMethods;
//   List<dynamic>? stateProvinces;
//   String name;
//   bool allowsBilling;
//   bool allowsShipping;
//   String twoLetterIsoCode;
//   String threeLetterIsoCode;
//   int numericIsoCode;
//   bool subjectToVat;
//   bool published;
//   int displayOrder;
//   bool limitedToStores;
//   int id;
//
//   factory Country.fromJson(Map<String, dynamic> json) => Country(
//         restrictedShippingMethods:
//             List<dynamic>.from(json["RestrictedShippingMethods"].map((x) => x)) ?? [],
//         stateProvinces:
//             List<dynamic>.from(json["StateProvinces"].map((x) => x)),
//         name: json["Name"],
//         allowsBilling: json["AllowsBilling"],
//         allowsShipping: json["AllowsShipping"],
//         twoLetterIsoCode: json["TwoLetterIsoCode"],
//         threeLetterIsoCode: json["ThreeLetterIsoCode"],
//         numericIsoCode: json["NumericIsoCode"],
//         subjectToVat: json["SubjectToVat"],
//         published: json["Published"],
//         displayOrder: json["DisplayOrder"],
//         limitedToStores: json["LimitedToStores"],
//         id: json["Id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "RestrictedShippingMethods":
//             List<dynamic>.from(restrictedShippingMethods!.map((x) => x)),
//         "StateProvinces": List<dynamic>.from(stateProvinces!.map((x) => x)),
//         "Name": name,
//         "AllowsBilling": allowsBilling,
//         "AllowsShipping": allowsShipping,
//         "TwoLetterIsoCode": twoLetterIsoCode,
//         "ThreeLetterIsoCode": threeLetterIsoCode,
//         "NumericIsoCode": numericIsoCode,
//         "SubjectToVat": subjectToVat,
//         "Published": published,
//         "DisplayOrder": displayOrder,
//         "LimitedToStores": limitedToStores,
//         "Id": id,
//       };
// }


// To parse this JSON data, do
//
//     final selectBillingAddress = selectBillingAddressFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SelectBillingAddress selectBillingAddressFromJson(String str) => SelectBillingAddress.fromJson(json.decode(str));

String selectBillingAddressToJson(SelectBillingAddress data) => json.encode(data.toJson());

class SelectBillingAddress {
  SelectBillingAddress({
    required this.status,
    required this.message,
    required this.selectedaddress,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final Selectedaddress selectedaddress;
  final int storeId;

  factory SelectBillingAddress.fromJson(Map<String, dynamic> json) => SelectBillingAddress(
    status: json["status"],
    message: json["Message"],
    selectedaddress: Selectedaddress.fromJson(json["selectedaddress"]),
    storeId: json["StoreId"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "selectedaddress": selectedaddress.toJson(),
    "StoreId": storeId,
  };
}

class Selectedaddress {
  Selectedaddress({
    required this.country,
    required this.stateProvince,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.company,
    required this.countryId,
    required this.stateProvinceId,
    required this.city,
    required this.address1,
    required this.address2,
    required this.zipPostalCode,
    required this.phoneNumber,
    required this.faxNumber,
    required this.customAttributes,
    required this.createdOnUtc,
    required this.id,
  });

  final dynamic country;
  final dynamic stateProvince;
  final String firstName;
  final String lastName;
  final String email;
  final dynamic company;
  final dynamic countryId;
  final dynamic stateProvinceId;
  final String city;
  final String address1;
  final String address2;
  final dynamic zipPostalCode;
  final String phoneNumber;
  final dynamic faxNumber;
  final dynamic customAttributes;
  final DateTime createdOnUtc;
  final int id;

  factory Selectedaddress.fromJson(Map<String, dynamic> json) => Selectedaddress(
    country: json["Country"],
    stateProvince: json["StateProvince"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
    company: json["Company"],
    countryId: json["CountryId"],
    stateProvinceId: json["StateProvinceId"],
    city: json["City"],
    address1: json["Address1"],
    address2: json["Address2"],
    zipPostalCode: json["ZipPostalCode"],
    phoneNumber: json["PhoneNumber"],
    faxNumber: json["FaxNumber"],
    customAttributes: json["CustomAttributes"],
    createdOnUtc: DateTime.parse(json["CreatedOnUtc"]),
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "Country": country,
    "StateProvince": stateProvince,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "Company": company,
    "CountryId": countryId,
    "StateProvinceId": stateProvinceId,
    "City": city,
    "Address1": address1,
    "Address2": address2,
    "ZipPostalCode": zipPostalCode,
    "PhoneNumber": phoneNumber,
    "FaxNumber": faxNumber,
    "CustomAttributes": customAttributes,
    "CreatedOnUtc": createdOnUtc.toIso8601String(),
    "Id": id,
  };
}
