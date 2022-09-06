import 'package:sse/model/entity/product.dart';

import '../response/search_list_item_response.dart';

class CreateOrderRequest{
  CreateOrderRequestBody? requestData;

  CreateOrderRequest({this.requestData});

  CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    requestData = json['Data'] != null ? new CreateOrderRequestBody.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestData != null) {
      data['Data'] = this.requestData?.toJson();
    }
    return data;
  }
}

class CreateOrderRequestBody {
  String? customerCode;
  String? saleCode;
  String? orderDate;
  String? currency;
  String? stockCode;
  String? descript;
  List<String>? dsCk;
  List<Product>? listStore ;
  ItemTotalMoneyRequestData? listTotal;

  CreateOrderRequestBody({ this.customerCode, this.saleCode,this.orderDate,this.currency,this.stockCode,this.descript,this.dsCk,this.listStore,this.listTotal});

  CreateOrderRequestBody.fromJson(Map<String, dynamic> json) {

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
    listTotal = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['Total'] = this.listTotal;
    return data;
  }
}


class ItemTotalMoneyRequestData {
  String? totalMNProduct;
  String? totalMNDiscount;
  String? totalMNPayment;
  String? preAmount;
  String? discount;

  ItemTotalMoneyRequestData({ this.totalMNProduct, this.totalMNDiscount, this.totalMNPayment,this.preAmount,this.discount});

  ItemTotalMoneyRequestData.fromJson(Map<String, dynamic> json) {
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