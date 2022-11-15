// To parse this JSON data, do
//
//     final topicPageResponse = topicPageResponseFromJson(jsonString);

import 'dart:convert';

TopicPageResponse topicPageResponseFromJson(String str) =>
    TopicPageResponse.fromJson(json.decode(str));

String topicPageResponseToJson(TopicPageResponse data) =>
    json.encode(data.toJson());

class TopicPageResponse {
  TopicPageResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<TopicItems> responseData;

  factory TopicPageResponse.fromJson(Map<String, dynamic> json) =>
      TopicPageResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: List<TopicItems>.from(
            json["ResponseData"].map((x) => TopicItems.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
      };
}

class TopicItems {
  TopicItems({
    required this.topicId,
    required this.textToDisplay,
    required this.imagePath,
    required this.url,
    required this.displayOrder,
  });

  String topicId;
  String textToDisplay;
  String imagePath;
  String url;
  int displayOrder;

  factory TopicItems.fromJson(Map<String, dynamic> json) => TopicItems(
        topicId: json["TopicId"].toString().isEmpty
            ? ''
            : json["TopicId"].toString(),
        textToDisplay: json["TextToDisplay"].toString().isEmpty
            ? ''
            : json["TextToDisplay"].toString(),
        imagePath: json["ImagePath"].toString().isEmpty
            ? ''
            : json["ImagePath"].toString(),
        url: json["Url"].toString().isEmpty ? '' : json["Url"].toString(),
        displayOrder: json["DisplayOrder"],
      );

  Map<String, dynamic> toJson() => {
        "TopicId": topicId,
        "TextToDisplay": textToDisplay,
        "ImagePath": imagePath,
        "Url": url,
        "DisplayOrder": displayOrder,
      };
}
