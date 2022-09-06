class ReportFieldLookupResponse {
  List<ReportFieldLookupResponseData>? data;
  int? statusCode;
  String? message;


  ReportFieldLookupResponse({this.data, this.statusCode, this.message});

  ReportFieldLookupResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReportFieldLookupResponseData>[];(json['data'] as List).forEach((v) { data!.add(new ReportFieldLookupResponseData.fromJson(v)); });
    }
    statusCode = json['statusCode'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.data != null) {
    //   data['data'] = this.data.toJson();
    // }
    if (this.data != null) {
      data['data'] =  this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ReportFieldLookupResponseData {
  String? code;
  String? name;
  bool isChecked = false;

  ReportFieldLookupResponseData({this.code,this.name});

  ReportFieldLookupResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}

class ReportResultResponseData {
  String? field;
  String? value;

  ReportResultResponseData({this.field,this.value,});

  ReportResultResponseData.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['value'] = this.value;
    return data;
  }
}
