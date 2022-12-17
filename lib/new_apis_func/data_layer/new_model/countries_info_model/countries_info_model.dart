// To parse this JSON data, do
//
//     final countriesDataResponse = countriesDataResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CountriesDataResponse> countriesDataResponseFromJson(String str) => List<CountriesDataResponse>.from(json.decode(str).map((x) => CountriesDataResponse.fromJson(x)));

String countriesDataResponseToJson(List<CountriesDataResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountriesDataResponse {
  CountriesDataResponse({
    required this.id,
    required this.name,
    required this.twoLetterIsoCode,
    required this.threeLetterIsoCode,
    required this.numericIsoCode,
    required this.phnCode,
    required this.phoneNumberLimit,
  });

  final int id;
  final String name;
  final String twoLetterIsoCode;
  final String threeLetterIsoCode;
  final int numericIsoCode;
  final int phnCode;
  final int phoneNumberLimit;

  factory CountriesDataResponse.fromJson(Map<String, dynamic> json) => CountriesDataResponse(
    id: json["Id"]??0,
    name: json["Name"]??'',
    twoLetterIsoCode: json["TwoLetterIsoCode"]??'',
    threeLetterIsoCode: json["ThreeLetterIsoCode"]??'',
    numericIsoCode: json["NumericIsoCode"]??'',
    phnCode: json["Phn_Code"]??00,
    phoneNumberLimit: json["Phone_Number_Limit"]??'',
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "TwoLetterIsoCode": twoLetterIsoCode,
    "ThreeLetterIsoCode": threeLetterIsoCode,
    "NumericIsoCode": numericIsoCode,
    "Phn_Code": phnCode,
    "Phone_Number_Limit": phoneNumberLimit,
  };
}
