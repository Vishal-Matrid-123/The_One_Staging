// To parse this JSON data, do
//
//     final retrunOrderResponse = retrunOrderResponseFromJson(jsonString);

import 'dart:convert';

RetrunOrderResponse retrunOrderResponseFromJson(String str) =>
    RetrunOrderResponse.fromJson(json.decode(str));

String retrunOrderResponseToJson(RetrunOrderResponse data) =>
    json.encode(data.toJson());

class RetrunOrderResponse {
  RetrunOrderResponse({
    required this.returnrequestform,
    required this.error,
  });

  Returnrequestform returnrequestform;
  dynamic error;

  factory RetrunOrderResponse.fromJson(Map<String, dynamic> json) =>
      RetrunOrderResponse(
        returnrequestform:
            Returnrequestform.fromJson(json["returnrequestform"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "returnrequestform": returnrequestform.toJson(),
        "error": error,
      };
}

class Returnrequestform {
  Returnrequestform({
    required this.orderId,
    required this.customOrderNumber,
    required this.items,
    required this.returnRequestReasonId,
    required this.availableReturnReasons,
    required this.returnRequestActionId,
    required this.availableReturnActions,
    required this.comments,
    required this.allowFiles,
    required this.uploadedFileGuid,
    required this.result,
    required this.customProperties,
  });

  int orderId;
  String customOrderNumber;
  List<ReturnableItem> items;
  int returnRequestReasonId;
  List<AvailableReturn> availableReturnReasons;
  int returnRequestActionId;
  List<AvailableReturn> availableReturnActions;
  dynamic comments;
  bool allowFiles;
  String uploadedFileGuid;
  dynamic result;
  CustomProperties customProperties;

  factory Returnrequestform.fromJson(Map<String, dynamic> json) =>
      Returnrequestform(
        orderId: json["OrderId"],
        customOrderNumber: json["CustomOrderNumber"],
        items: List<ReturnableItem>.from(
            json["Items"].map((x) => ReturnableItem.fromJson(x))),
        returnRequestReasonId: json["ReturnRequestReasonId"],
        availableReturnReasons: List<AvailableReturn>.from(
            json["AvailableReturnReasons"]
                .map((x) => AvailableReturn.fromJson(x))),
        returnRequestActionId: json["ReturnRequestActionId"],
        availableReturnActions: List<AvailableReturn>.from(
            json["AvailableReturnActions"]
                .map((x) => AvailableReturn.fromJson(x))),
        comments: json["Comments"],
        allowFiles: json["AllowFiles"],
        uploadedFileGuid: json["UploadedFileGuid"],
        result: json["Result"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "CustomOrderNumber": customOrderNumber,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "ReturnRequestReasonId": returnRequestReasonId,
        "AvailableReturnReasons":
            List<dynamic>.from(availableReturnReasons.map((x) => x.toJson())),
        "ReturnRequestActionId": returnRequestActionId,
        "AvailableReturnActions":
            List<dynamic>.from(availableReturnActions.map((x) => x.toJson())),
        "Comments": comments,
        "AllowFiles": allowFiles,
        "UploadedFileGuid": uploadedFileGuid,
        "Result": result,
        "CustomProperties": customProperties.toJson(),
      };
}

class AvailableReturn {
  AvailableReturn({
    required this.name,
    required this.id,
    required this.customProperties,
  });

  String name;
  int id;
  CustomProperties customProperties;

  factory AvailableReturn.fromJson(Map<String, dynamic> json) =>
      AvailableReturn(
        name: json["Name"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class ReturnableItem {
  ReturnableItem({
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.attributeInfo,
    required this.unitPrice,
    required this.quantity,
    required this.id,
  });

  int productId;
  String productName;
  String productSeName;
  String attributeInfo;
  String unitPrice;
  int quantity;
  int id;

  factory ReturnableItem.fromJson(Map<String, dynamic> json) => ReturnableItem(
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        attributeInfo: json["AttributeInfo"],
        unitPrice: json["UnitPrice"],
        quantity: json["Quantity"],
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "AttributeInfo": attributeInfo,
        "UnitPrice": unitPrice,
        "Quantity": quantity,
        "Id": id,
      };
}
