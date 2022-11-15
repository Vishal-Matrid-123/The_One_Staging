// To parse this JSON data, do
//
//     final myOrdersResponse = myOrdersResponseFromJson(jsonString);

import 'dart:convert';

MyOrdersResponse myOrdersResponseFromJson(String str) =>
    MyOrdersResponse.fromJson(json.decode(str));

String myOrdersResponseToJson(MyOrdersResponse data) =>
    json.encode(data.toJson());

class MyOrdersResponse {
  MyOrdersResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final dynamic message;
  final ResponseData responseData;
  final int storeId;

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) =>
      MyOrdersResponse(
        status: json["status"] ?? "",
        message: json["Message"] ?? null,
        responseData: ResponseData.fromJson(json["ResponseData"]),
        storeId: json["StoreId"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "ResponseData": responseData.toJson(),
        "StoreId": storeId,
      };
}

class ResponseData {
  ResponseData({
    required this.orders,
    required this.recurringOrders,
    required this.recurringPaymentErrors,
    required this.customProperties,
  });

  final List<Order> orders;
  final List<dynamic> recurringOrders;
  final List<dynamic> recurringPaymentErrors;
  final CustomProperties customProperties;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
        recurringOrders:
            List<dynamic>.from(json["RecurringOrders"].map((x) => x)),
        recurringPaymentErrors:
            List<dynamic>.from(json["RecurringPaymentErrors"].map((x) => x)),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "RecurringOrders": List<dynamic>.from(recurringOrders.map((x) => x)),
        "RecurringPaymentErrors":
            List<dynamic>.from(recurringPaymentErrors.map((x) => x)),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class Order {
  Order({
    required this.customOrderNumber,
    required this.orderTotal,
    required this.isReturnRequestAllowed,
    required this.orderStatusEnum,
    required this.orderStatus,
    required this.paymentStatus,
    required this.shippingStatus,
    required this.createdOn,
    required this.id,
    required this.customProperties,
  });

  final String customOrderNumber;
  final String orderTotal;
  final bool isReturnRequestAllowed;
  final int orderStatusEnum;
  final String orderStatus;
  final String paymentStatus;
  final String shippingStatus;
  final DateTime createdOn;
  final int id;
  final CustomProperties customProperties;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        customOrderNumber: json["CustomOrderNumber"],
        orderTotal: json["OrderTotal"],
        isReturnRequestAllowed: json["IsReturnRequestAllowed"],
        orderStatusEnum: json["OrderStatusEnum"],
        orderStatus: json["OrderStatus"],
        paymentStatus: json["PaymentStatus"],
        shippingStatus: json["ShippingStatus"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomOrderNumber": customOrderNumber,
        "OrderTotal": orderTotal,
        "IsReturnRequestAllowed": isReturnRequestAllowed,
        "OrderStatusEnum": orderStatusEnum,
        "OrderStatus": orderStatus,
        "PaymentStatus": paymentStatus,
        "ShippingStatus": shippingStatus,
        "CreatedOn": createdOn.toIso8601String(),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}
