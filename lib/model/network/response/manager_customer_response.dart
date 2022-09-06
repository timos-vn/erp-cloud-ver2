class ManagerCustomerResponse {
  String? message;
  int? statusCode;
  List<ManagerCustomerResponseData>? data;
  int? pageIndex;

  ManagerCustomerResponse({ this.message,  this.statusCode, this.data,this.pageIndex});

  ManagerCustomerResponse.fromJson(Map<String, dynamic> json) {

    this.message = json['message'];

    this.statusCode = json['statusCode'];
    this.pageIndex = json['pageIndex'];

    if (json['data'] != null) {
      data = <ManagerCustomerResponseData>[];
      (json['data'] as List).forEach((v) { data?.add(new ManagerCustomerResponseData.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['message'] = this.message;
    data['pageIndex'] = this.pageIndex;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] =  this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class ManagerCustomerResponseData {
  String? customerCode;
  String? customerName;
  String? customerName2;
  String? birthday;
  String? phone;
  String? address;
  String? email;
  String? imageUrl;

  ManagerCustomerResponseData({this.customerCode,this.customerName,this.customerName2,this.birthday,this.phone,this.address,this.email,this.imageUrl});

  ManagerCustomerResponseData.fromJson(Map<String, dynamic> json) {
    this.customerCode = json['customerCode'];
    this.customerName = json['customerName'];
    this.customerName2 = json['customerName2'];
    this.birthday = json['birthday'];
    this.phone = json['phone'];
    this.address = json['address'];
    this.email = json['email'];
    this.imageUrl = json['imageUrl'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['customerName2'] = this.customerName2;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
