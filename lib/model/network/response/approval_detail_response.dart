class ResultReportResponse {
  String? message;
  int? statusCode;
  int? pageIndex;
  int? totalCount;
  int? totalPage;
  List<HeaderData>? headerDesc;
  List<StatusData>? statusData;

  ResultReportResponse({this.message, this.statusCode, this.headerDesc, this.pageIndex,this.totalCount,this.totalPage});

  ResultReportResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.pageIndex = json['pageIndex'];
    this.totalCount = json['totalCount'];
    this.statusCode = json['statusCode'];this.totalPage = json['totalPage'];

    if (json['headerDesc'] != null) {
      headerDesc = <HeaderData>[];
      (json['headerDesc'] as List).forEach((v) {
        headerDesc!.add(new HeaderData.fromJson(v));
      });
    }
    if (json['status'] != null) {
      statusData = <StatusData>[];
      (json['status'] as List).forEach((v) {
        statusData!.add(new StatusData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['pageIndex'] = this.pageIndex;
    data['totalCount'] = this.totalCount;
    data['statusCode'] = this.statusCode;data['totalPage'] = this.totalPage;
    if (this.headerDesc != null) {
      data['headerDesc'] = this.headerDesc!.map((v) => v.toJson()).toList();
    }
    if (this.statusData != null) {
      data['status'] = this.statusData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HeaderData {
  String? field;
  String? name;
  String? name2;
  int? type;
  String? format;

  HeaderData({this.field, this.name, this.name2, this.type,this.format});

  HeaderData.fromJson(Map<String, dynamic> json) {
    this.field = json['field'];
    this.name = json['name'];
    this.name2 = json['name2'];
    this.type = json['type'];
    this.format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['name'] = this.name;
    data['name2'] = this.name2;
    data['type'] = this.type;
    data['format'] = this.format;

    return data;
  }
}

class StatusData {
  String? status;
  String? statusName;
  String? statusName2;

  StatusData({this.status, this.statusName, this.statusName2});

  StatusData.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.statusName = json['statusName'];
    this.statusName2 = json['statusName2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    data['statusName2'] = this.statusName2;

    return data;
  }
}
