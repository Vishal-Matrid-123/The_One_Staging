// To parse this JSON data, do
//
//     final searchSuggestionResponse = searchSuggestionResponseFromJson(jsonString);

import 'dart:convert';

SearchSuggestionResponseNew searchSuggestionResponseFromJson(String str) =>
    SearchSuggestionResponseNew.fromJson(json.decode(str));

String searchSuggestionResponseToJson(SearchSuggestionResponseNew data) =>
    json.encode(data.toJson());

class SearchSuggestionResponseNew {
  SearchSuggestionResponseNew({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<String> responseData;

  factory SearchSuggestionResponseNew.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionResponseNew(
        status: json["Status"],
        message: json["Message"],
        responseData: List<String>.from(json["ResponseData"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x)),
      };
}
