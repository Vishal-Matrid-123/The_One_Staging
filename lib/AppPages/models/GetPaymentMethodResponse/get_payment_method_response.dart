import 'dart:convert';

GetPaymentMethodResponse getPaymentMethodResponseFromJson(String str) =>
    GetPaymentMethodResponse.fromJson(json.decode(str));

String getPaymentMethodResponseToJson(GetPaymentMethodResponse data) =>
    json.encode(data.toJson());

class GetPaymentMethodResponse {
  GetPaymentMethodResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final String message;
  final ResponseData responseData;
  final int storeId;

  GetPaymentMethodResponse copyWith({
    required String status,
    required String message,
    required ResponseData responseData,
    required int storeId,
  }) =>
      GetPaymentMethodResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        responseData: responseData ?? this.responseData,
        storeId: storeId ?? this.storeId,
      );

  factory GetPaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      GetPaymentMethodResponse(
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
    required this.paymentMethods,
    required this.displayRewardPoints,
    required this.rewardPointsBalance,
    required this.rewardPointsAmount,
    required this.rewardPointsEnoughToPayForOrder,
    required this.useRewardPoints,
    required this.customProperties,
  });

  final List<PaymentMethod> paymentMethods;
  final bool displayRewardPoints;
  final int rewardPointsBalance;
  final dynamic rewardPointsAmount;
  final bool rewardPointsEnoughToPayForOrder;
  final bool useRewardPoints;
  final CustomProperties customProperties;

  ResponseData copyWith({
    required List<PaymentMethod> paymentMethods,
    required bool displayRewardPoints,
    required int rewardPointsBalance,
    dynamic rewardPointsAmount,
    required bool rewardPointsEnoughToPayForOrder,
    required bool useRewardPoints,
    required CustomProperties customProperties,
  }) =>
      ResponseData(
        paymentMethods: paymentMethods ?? this.paymentMethods,
        displayRewardPoints: displayRewardPoints ?? this.displayRewardPoints,
        rewardPointsBalance: rewardPointsBalance ?? this.rewardPointsBalance,
        rewardPointsAmount: rewardPointsAmount ?? this.rewardPointsAmount,
        rewardPointsEnoughToPayForOrder: rewardPointsEnoughToPayForOrder ??
            this.rewardPointsEnoughToPayForOrder,
        useRewardPoints: useRewardPoints ?? this.useRewardPoints,
        customProperties: customProperties ?? this.customProperties,
      );

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        paymentMethods: List<PaymentMethod>.from(
            json["PaymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        displayRewardPoints: json["DisplayRewardPoints"],
        rewardPointsBalance: json["RewardPointsBalance"],
        rewardPointsAmount: json["RewardPointsAmount"],
        rewardPointsEnoughToPayForOrder:
            json["RewardPointsEnoughToPayForOrder"],
        useRewardPoints: json["UseRewardPoints"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PaymentMethods":
            List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "DisplayRewardPoints": displayRewardPoints,
        "RewardPointsBalance": rewardPointsBalance,
        "RewardPointsAmount": rewardPointsAmount,
        "RewardPointsEnoughToPayForOrder": rewardPointsEnoughToPayForOrder,
        "UseRewardPoints": useRewardPoints,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class PaymentMethod {
  PaymentMethod({
    required this.paymentMethodSystemName,
    required this.name,
    required this.description,
    required this.fee,
    required this.selected,
    required this.logoUrl,
    required this.customProperties,
  });

  final String paymentMethodSystemName;
  final String name;
  final String description;
  final dynamic fee;
  final bool selected;
  final String logoUrl;
  final CustomProperties customProperties;

  PaymentMethod copyWith({
    required String paymentMethodSystemName,
    required String name,
    required String description,
    dynamic fee,
    required bool selected,
    required String logoUrl,
    required CustomProperties customProperties,
  }) =>
      PaymentMethod(
        paymentMethodSystemName:
            paymentMethodSystemName ?? this.paymentMethodSystemName,
        name: name ?? this.name,
        description: description ?? this.description,
        fee: fee ?? this.fee,
        selected: selected ?? this.selected,
        logoUrl: logoUrl ?? this.logoUrl,
        customProperties: customProperties ?? this.customProperties,
      );

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        paymentMethodSystemName: json["PaymentMethodSystemName"],
        name: json["Name"],
        description: json["Description"],
        fee: json["Fee"],
        selected: json["Selected"],
        logoUrl: json["LogoUrl"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PaymentMethodSystemName": paymentMethodSystemName,
        "Name": name,
        "Description": description,
        "Fee": fee,
        "Selected": selected,
        "LogoUrl": logoUrl,
        "CustomProperties": customProperties.toJson(),
      };
}
