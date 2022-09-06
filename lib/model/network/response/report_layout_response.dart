import 'package:flutter/cupertino.dart';
import 'package:sse/model/network/response/report_field_lookup_response.dart';

class ReportLayoutResponse {
  String? message;
  int? statusCode;
  List<DataReportLayout>? reportLayoutData;

  ReportLayoutResponse({ this.message,  this.statusCode, this.reportLayoutData});

  ReportLayoutResponse.fromJson(Map<String, dynamic> json) {

    this.message = json['message'];

    this.statusCode = json['statusCode'];

    if (json['data'] != null) {
      reportLayoutData =  <DataReportLayout>[];(json['data'] as List).forEach((v) { reportLayoutData?.add(new DataReportLayout.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['message'] = this.message;

    data['statusCode'] = this.statusCode;
    if (this.reportLayoutData != null) {
      data['data'] =  this.reportLayoutData?.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class DataReportLayout {
  String? field;
  String? name;
  String? name2;
  int? type;
  String? controller;
  bool? isNull;
  String? defaultValue;
  List<DropDownList>? dropDownList;
  ReportFieldLookupResponseData? selectValue;
  List<ReportFieldLookupResponseData>? listItem;
  TextEditingController? textEditingController ;
  String? listItemPush;
  bool c = false;

  DataReportLayout({required this.textEditingController,this.selectValue,this.field,this.name,this.name2,this.type,this.controller,this.isNull,this.defaultValue,this.dropDownList});

  DataReportLayout.fromJson(Map<String, dynamic> json) {
    this.field = json['field'];
    this.name = json['name'];
    this.name2 = json['name2'];
    this.type = json['type'];
    this.controller = json['controller'];
    this.isNull = json['isNull'];
    this.defaultValue = json['defaultValue'];
    // ignore: unnecessary_null_comparison
    if ((json['dropDownList'] as List)!=null) {
      this.dropDownList = (json['dropDownList'] as List).map((i) => DropDownList.fromJson(i)).toList();
    } else {
      this.dropDownList = null;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['name'] = this.name;
    data['name2'] = this.name2;
    data['type'] = this.type;
    data['isNull'] = this.isNull;
    data['defaultValue'] = this.defaultValue;
    data['controller'] = this.controller;
    data['dropDownList'] = this.dropDownList != null?this.dropDownList?.map((i) => i.toJson()).toList():null;

    return data;
  }
}


class DropDownList {
  String? field;
  String? value;
  String? text;
  String? name2;
  double? desc;


  DropDownList({this.field, this.value, this.text, this.name2, this.desc,});

  DropDownList.fromJson(Map<String, dynamic> json) {
    this.field = json['field'];
    this.value = json['value'];
    this.text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}
