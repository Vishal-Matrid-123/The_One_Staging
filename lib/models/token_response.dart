class TokenResponse {
  String tokenId = '';
  String expiryTime = '';
  Null cutomer;

  TokenResponse(
      {required this.tokenId, required this.expiryTime, this.cutomer});

  TokenResponse.fromJson(Map<String, dynamic> json) {
    tokenId = json['tokenId'];
    expiryTime = json['ExpiryTime'];
    cutomer = json['cutomer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenId'] = this.tokenId;
    data['ExpiryTime'] = this.expiryTime;
    data['cutomer'] = this.cutomer;
    return data;
  }
}
