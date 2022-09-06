class GroupProductResponse{
  int? pageIndex;
  int? statusCode;
  String? message;
  List<GroupProductResponseData>? data;


  GroupProductResponse({this.data,this.pageIndex,this.statusCode,this.message});

  GroupProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GroupProductResponseData>[];(json['data'] as List).forEach((v) { data!.add(new GroupProductResponseData.fromJson(v)); });
    }
    this.message = json['message'];
    this.statusCode = json['statusCode'];
    this.pageIndex = json['pageIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] =  this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['pageIndex'] = this.pageIndex;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class GroupProductResponseData{
  int? groupType;
  String? groupCode;
  String? groupName;
  String? iconUrl;


  GroupProductResponseData({this.groupType,this.groupCode,this.groupName,this.iconUrl});

  GroupProductResponseData.fromJson(Map<String, dynamic> json) {
    groupType = json['groupType'];
    groupCode = json['groupCode'];
    groupName = json['groupName'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupType'] = this.groupType;
    data['groupCode'] = this.groupCode;
    data['groupName'] = this.groupName;
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}

