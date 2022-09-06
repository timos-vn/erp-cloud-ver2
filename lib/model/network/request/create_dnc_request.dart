import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class CreateDNCRequest {
  String? deptId;
  CreateDNCData? data;
  CreateDNCRequest({this.data,this.deptId});

  CreateDNCRequest.fromJson(Map<String, dynamic> json) {
    deptId = json['deptId'];
    data = json['data'] != null ? new CreateDNCData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deptId'] = this.deptId;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class CreateDNCData {
  String? customerCode;
  String? dienGiai;
  String? loaiTt;
  String? maGd;
  String? orderDate;
  List<ListAttachFile>? attachFile;
  List<ListDNCDataDetail>? detail;

  CreateDNCData(
      {this.customerCode,
        this.dienGiai,
        this.loaiTt,
        this.maGd,
        this.orderDate,this.attachFile,
        this.detail});

  CreateDNCData.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    dienGiai = json['dien_giai'];
    loaiTt = json['loai_tt'];
    maGd = json['ma_gd'];
    orderDate = json['orderDate'];
    if (json['atachFiles'] != null) {
      attachFile = <ListAttachFile>[];
      json['atachFiles'].forEach((v) {
        attachFile!.add(new ListAttachFile.fromJson(v));
      });
    }
    if (json['detail'] != null) {
      detail = <ListDNCDataDetail>[];
      json['detail'].forEach((v) {
        detail!.add(new ListDNCDataDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCode'] = this.customerCode;
    data['dien_giai'] = this.dienGiai;
    data['loai_tt'] = this.loaiTt;
    data['ma_gd'] = this.maGd;
    data['orderDate'] = this.orderDate;
    if (this.attachFile != null) {
      data['atachFiles'] = this.attachFile!.map((v) => v.toJson()).toList();
    }
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListAttachFile {
  String? fileName;
  String? fileExt;
  String? fileSize;
  var fileData;

  ListAttachFile({this.fileName, this.fileExt,this.fileSize,this.fileData});

  ListAttachFile.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    fileExt = json['file_ext'];
    fileSize = json['file_size'];
    fileData = json['file_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['file_ext'] = this.fileExt;
    data['file_size'] = this.fileSize;
    data['file_data'] = this.fileData;
    return data;
  }
}

class ListDNCDataDetail {
  double? tienNt;
  String? dienGiai;

  ListDNCDataDetail({this.tienNt, this.dienGiai});

  ListDNCDataDetail.fromJson(Map<String, dynamic> json) {
    tienNt = json['tien_nt'];
    dienGiai = json['dien_giai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tien_nt'] = this.tienNt;
    data['dien_giai'] = this.dienGiai;
    return data;
  }
}

class ListDNCDataDetail2 {
  TextEditingController textEditingController ;
  double tienNt;
  String dienGiai;

  ListDNCDataDetail2({required this.textEditingController,required this.tienNt, required this.dienGiai});
}