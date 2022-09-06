import 'package:flutter/material.dart';

class SearchListItemResponse {
  String? message;
  int? statusCode;
  List<SearchItemResponseData>? data;
  int? pageIndex;
  int? totalCount;

  SearchListItemResponse({this.message, this.statusCode, this.data, this.pageIndex});

  SearchListItemResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];

    this.statusCode = json['statusCode'];
    this.pageIndex = json['pageIndex'];
    this.totalCount = json['totalCount'];

    if (json['data'] != null) {
      data = <SearchItemResponseData>[];
      (json['data'] as List).forEach((v) {
        data!.add(new SearchItemResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['message'] = this.message;
    data['pageIndex'] = this.pageIndex;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchItemResponseData {
  String? code;
  String? name;
  String? name2;
  String? dvt;
  String? descript;
  double? price;
  double? discountPercent;
  double? priceAfter;
  double? stockAmount;
  double? totalMoneyProduct = 0;
  double? totalMoneyDiscount = 0;
  double? taxPercent;
  String? imageUrl;
  double? count = 0;
  int? isMark = 0;
  String? discountMoney;
  String? discountProduct;
  String? budgetForItem;
  String? budgetForProduct;
  double? residualValueProduct;
  double? residualValue;
  String? unit;
  String? unitProduct;
  List<String>? dsCKLineItem;
  bool ?allowDvt;
  String? contentDvt;
  Color? kColorFormatAlphaB;

  SearchItemResponseData({ this.code, this.name, this.name2, this.dvt, this.descript, this.price,
    this.discountPercent, this.imageUrl, this.priceAfter, this.stockAmount,this.count,this.isMark,
    this.discountMoney,this.discountProduct,this.budgetForItem,this.budgetForProduct,this.residualValueProduct,this.residualValue,
    this.unit,this.unitProduct,this.dsCKLineItem, this.allowDvt, this.contentDvt,this.kColorFormatAlphaB
  });

  SearchItemResponseData.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.name = json['name'];
    this.name2 = json['name2'];
    this.dvt = json['dvt'];

    this.descript = json['descript'];
    this.price = json['price'];
    this.discountPercent = json['discountPercent'];
    this.imageUrl = json['imageUrl'];
    this.priceAfter = json['priceAfter'];
    this.stockAmount = json['stockAmount'];
    this.taxPercent = json['taxPercent'];
    this.taxPercent = json['taxPercent'];
    this.count = json['count'];
    this.budgetForItem = json['ten_ns'];
    this.residualValueProduct = json['gt_cl_product'];
    this.residualValue = json['gt_cl'];
    this.unit = json['loai_ct'];
    if(this.dsCKLineItem!=null){
      this.dsCKLineItem = json['ds_ck'];
    }else{
      this.dsCKLineItem = [];
    }
    this.budgetForProduct = json['ten_ns_product'];
    this.unitProduct = json['loai_ct_product'];
    this.allowDvt = json['nhieu_dvt'];
    this.contentDvt = json['ndvt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['name2'] = this.name2;
    data['dvt'] = this.dvt;

    data['descript'] = this.descript;
    data['price'] = this.price;
    data['discountPercent'] = this.discountPercent;
    data['imageUrl'] = this.imageUrl;
    data['priceAfter'] = this.priceAfter;
    data['stockAmount'] = this.stockAmount;
    data['count'] = this.count;
    data['ten_ns'] = this.budgetForItem;
    data['gt_cl_product'] = this.residualValueProduct;
    data['gt_cl'] = this.residualValue;
    data['loai_ct'] = this.unit;
    if(this.dsCKLineItem!=null){
      data['ds_ck'] = this.dsCKLineItem;
    }else {
      data['ds_ck'] = [];
    }
    data['ten_ns_product'] = this.budgetForProduct;
    data['loai_ct_product'] = this.unitProduct;
    data['nhieu_dvt'] = this.allowDvt;
    data['ndvt'] = this.contentDvt;
    return data;
  }
}
