class SettingOptionsResponse{
  int? statusCode;
  String? message;
  List<SettingOptionsResponseData>? dataSettingOptions;

  SettingOptionsResponse({this.statusCode,this.message,this.dataSettingOptions});

  SettingOptionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      dataSettingOptions = <SettingOptionsResponseData>[];
      (json['data'] as List).forEach((v) { dataSettingOptions!.add(new SettingOptionsResponseData.fromJson(v)); });
    }
    statusCode = json['statusCode'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataSettingOptions != null) {
      data['data'] =  this.dataSettingOptions!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class SettingOptionsResponseData{
  String? inStockCheck;

  SettingOptionsResponseData({this.inStockCheck});

  SettingOptionsResponseData.fromJson(Map<String, dynamic> json) {
    inStockCheck = json['inStockCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inStockCheck'] = this.inStockCheck;
    return data;
  }
}
