import 'dart:convert';

GetShippingZonesResponse getShippingZonesResponseFromJson(String str) => GetShippingZonesResponse.fromJson(json.decode(str));

String getShippingZonesResponseToJson(GetShippingZonesResponse data) => json.encode(data.toJson());

class GetShippingZonesResponse {
  GetShippingZonesResponse({
    required this.status,
    required this.message,
    required this.responseData,
    required this.storeId,
  });

  final String status;
  final String message;
  final List<ShippingZoneResponseDatum> responseData;
  final int storeId;

  GetShippingZonesResponse copyWith({
    required String status,
    required String message,
    required List<ShippingZoneResponseDatum> responseData,
    required int storeId,
  }) =>
      GetShippingZonesResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        responseData: responseData ?? this.responseData,
        storeId: storeId ?? this.storeId,
      );

  factory GetShippingZonesResponse.fromJson(Map<String, dynamic> json) => GetShippingZonesResponse(
    status: json["Status"],
    message: json["Message"],
    responseData: List<ShippingZoneResponseDatum>.from(json["ResponseData"].map((x) => ShippingZoneResponseDatum.fromJson(x))),
    storeId: json["StoreId"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
    "StoreId": storeId,
  };
}

class ShippingZoneResponseDatum {
  ShippingZoneResponseDatum({
    required this.id,
    required this.name,
    required this.shipping,
  });

  final String id;
  final String name;
  final String shipping;

  ShippingZoneResponseDatum copyWith({
    required String id,
    required String name,
    required String shipping,
  }) =>
      ShippingZoneResponseDatum(
        id: id ?? this.id,
        name: name ?? this.name,
        shipping: shipping ?? this.shipping,
      );

  factory ShippingZoneResponseDatum.fromJson(Map<String, dynamic> json) => ShippingZoneResponseDatum(
    id: json["id"],
    name: json["name"],
    shipping: json["shipping"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shipping": shipping,
  };
}
