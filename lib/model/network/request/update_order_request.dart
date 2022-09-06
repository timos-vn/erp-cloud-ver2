import 'package:sse/model/entity/product.dart';

import '../response/search_list_item_response.dart';

class UpdateOrderRequest{
  UpdateOrderRequestBody? requestData;

  UpdateOrderRequest({this.requestData});

  UpdateOrderRequest.fromJson(Map<String, dynamic> json) {
    requestData = json['Data'] != null ? new UpdateOrderRequestBody.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestData != null) {
      data['Data'] = this.requestData?.toJson();
    }
    return data;
  }
}

class UpdateOrderRequestBody {
  String? sstRec;
  String? customerCode;
  String? saleCode;
  String? orderDate;
  String? currency;
  String? stockCode;
  String? descript;
  List<String>? dsCk;
  List<Product>? listStore ;
  ItemTotalMoneyUpdateRequestData? listTotalUpdate;

  UpdateOrderRequestBody({ this.sstRec,this.customerCode, this.saleCode,this.orderDate,this.currency,this.stockCode,this.descript,this.dsCk,this.listStore,this.listTotalUpdate});

  UpdateOrderRequestBody.fromJson(Map<String, dynamic> json) {
    sstRec = json['stt_rec'];
    customerCode = json['CustomerCode'];
    saleCode = json['SaleCode'];
    orderDate = json['OrderDate'];
    currency = json['Currency'];
    stockCode = json['StockCode'];
    descript = json['Descript'];
    if(this.dsCk!=null){
      this.dsCk = json['ds_ck'];
    }else{
      this.dsCk = [];
    }
    listStore = json['Detail'];
    listTotalUpdate = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sstRec;
    data['CustomerCode'] = this.customerCode;
    data['SaleCode'] = this.saleCode;
    data['OrderDate'] = this.orderDate;
    data['Currency'] = this.currency;
    data['StockCode'] = this.stockCode;
    data['Descript'] = this.descript;
    if(this.dsCk != null){
      data['ds_ck'] = this.dsCk;
    }else {
      data['ds_ck'] = [];
    }
    data['Detail'] = this.listStore;
    data['Total'] = this.listTotalUpdate;
    return data;
  }
}


class ItemTotalMoneyUpdateRequestData {
  String? totalMNProduct;
  String? totalMNDiscount;
  String? totalMNPayment;
  String? preAmount;
  String? discount;

  ItemTotalMoneyUpdateRequestData({ this.totalMNProduct, this.totalMNDiscount, this.totalMNPayment,this.preAmount,this.discount});

  ItemTotalMoneyUpdateRequestData.fromJson(Map<String, dynamic> json) {
    this.totalMNProduct = json['TotalMNProduct'];
    this.totalMNDiscount = json['TotalMNDiscount'];
    this.totalMNPayment = json['TotalMnPayment'];
    this.preAmount = json['PreAmount'];
    this.discount = json['Discount'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalMNProduct'] = this.totalMNProduct;
    data['TotalMNDiscount'] = this.totalMNDiscount;
    data['TotalMnPayment'] = this.totalMNPayment;
    data['PreAmount'] = this.preAmount;
    data['Discount'] = this.discount;
    return data;
  }
}