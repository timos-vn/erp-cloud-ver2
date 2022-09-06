class DetailCustomerResponse {
  DetailCustomerResponseData? data;
  int? statusCode;
  String? message;

  DetailCustomerResponse({this.data, this.statusCode, this.message});

  DetailCustomerResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DetailCustomerResponseData.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class DetailCustomerResponseData {
  String? customerCode;
  String? customerName;
  String? customerName2;
  String? birthday;
  String? phone;
  String? address;
  int? gender;
  String? email;
  String? imageUrl;
  List<OtherData>? otherData;

  DetailCustomerResponseData(
      {this.customerCode,
        this.customerName,
        this.customerName2,
        this.birthday,
        this.phone,
        this.address,
        this.gender,
        this.email,
        this.imageUrl,
        this.otherData});

  DetailCustomerResponseData.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    customerName2 = json['customerName2'];
    birthday = json['birthday'];
    phone = json['phone'];
    address = json['address'];
    gender = json['gender'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    if (json['otherData'] != null) {
      otherData = <OtherData>[];
      json['otherData'].forEach((v) {
        otherData?.add(new OtherData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['customerName2'] = this.customerName2;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    if (this.otherData != null) {
      data['otherData'] = this.otherData?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class OtherData {
  String? name;
  String? text;
  double? value;
  String? iconUrl;
  String? formatString;

  OtherData({this.name, this.text, this.value, this.iconUrl});

  OtherData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    value = json['value'];
    iconUrl = json['iconUrl'];
    formatString = json['formatString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['text'] = this.text;
    data['value'] = this.value;
    data['iconUrl'] = this.iconUrl;
    data['formatString'] = this.formatString;
    return data;
  }
}