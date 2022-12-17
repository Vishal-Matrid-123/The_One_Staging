// To parse this JSON data, do
//
//     final orderReturnStatusResponse = orderReturnStatusResponseFromJson(jsonString);

import 'dart:convert';

OrderReturnStatusResponse orderReturnStatusResponseFromJson(String str) =>
    OrderReturnStatusResponse.fromJson(json.decode(str));

String orderReturnStatusResponseToJson(OrderReturnStatusResponse data) =>
    json.encode(data.toJson());

class OrderReturnStatusResponse {
  OrderReturnStatusResponse({
    required this.returnrequests,
    required this.error,
  });

  Returnrequests returnrequests;
  dynamic error;

  factory OrderReturnStatusResponse.fromJson(Map<String, dynamic> json) =>
      OrderReturnStatusResponse(
        returnrequests: Returnrequests.fromJson(json["returnrequests"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "returnrequests": returnrequests.toJson(),
        "error": error,
      };
}

class Returnrequests {
  Returnrequests({
    required this.items,
    required this.customProperties,
  });

  List<ReturnedItem> items;
  CustomProperties customProperties;

  factory Returnrequests.fromJson(Map<String, dynamic> json) => Returnrequests(
        items: List<ReturnedItem>.from(
            json["Items"].map((x) => ReturnedItem.fromJson(x))),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class ReturnedItem {
  ReturnedItem({
    required this.customNumber,
    required this.returnRequestStatus,
    required this.productId,
    required this.productName,
    // required this.productSeName,
    required this.quantity,
    required this.returnReason,
    required this.returnAction,
    required this.comments,
    // required this.uploadedFileGuid,
    required this.createdOn,
    required this.id,
    // required this.customProperties,
  });

  String customNumber;
  String returnRequestStatus;
  int productId;
  String productName;
  int quantity;
  String returnReason;
  String returnAction;
  String comments;
  DateTime createdOn;
  int id;

  factory ReturnedItem.fromJson(Map<String, dynamic> json) => ReturnedItem(
        customNumber: json["CustomNumber"],
        returnRequestStatus: json["ReturnRequestStatus"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        // productSeName: json["ProductSeName"],
        quantity: json["Quantity"],
        returnReason: json["ReturnReason"],
        returnAction: json["ReturnAction"],
        comments: json["Comments"] == null ? null : json["Comments"],
        // uploadedFileGuid: json["UploadedFileGuid"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        id: json["Id"],
        // customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomNumber": customNumber,
        "ReturnRequestStatus": returnRequestStatus,
        "ProductId": productId,
        "ProductName": productName,
        // "ProductSeName": productSeName,
        "Quantity": quantity,
        "ReturnReason": returnReason,
        "ReturnAction": returnAction,
        "Comments": comments == null ? null : comments,
        // "UploadedFileGuid": uploadedFileGuid,
        "CreatedOn": createdOn.toIso8601String(),
        "Id": id,
        // "CustomProperties": customProperties.toJson(),
      };
}
