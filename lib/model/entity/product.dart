import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Product extends Equatable {
  String? code;
  String? name;
  String? name2;
  String? dvt;
  String? description;
  double? price;
  double? discountPercent;
  double? priceAfter;
  double? stockAmount;
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
  String? dsCKLineItem;


  Product({this.code, this.name, this.name2, this.dvt, this.description, this.price,
    this.discountPercent, this.imageUrl, this.priceAfter, this.stockAmount,this.count,this.isMark,
    this.discountMoney,this.discountProduct,this.budgetForItem,this.budgetForProduct,this.residualValueProduct,this.residualValue,
    this.unit,this.unitProduct,this.dsCKLineItem, this.taxPercent});


  Product.fromDb(Map<String, dynamic> map) :
        code = map['code'],
        name = map['name'],
        name2 = map['name2'],
        dvt = map['dvt'],

        description = map['description'],
        price = map['price'],
        discountPercent = map['discountPercent'],
        imageUrl = map['imageUrl'],
        priceAfter = map['priceAfter'],
        stockAmount = map['stockAmount'],
        taxPercent = map['taxPercent'],
        count = map['count'],
        budgetForItem = map['budgetForItem'],
        residualValueProduct = map['residualValueProduct'],
        residualValue = map['residualValue'],
        unit = map['unit'],
        dsCKLineItem = map['dsCKLineItem'],
        budgetForProduct = map['budgetForProduct'],
        unitProduct = map['unitProduct'];

  Map<String, dynamic> toMapForDb() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['name2'] = this.name2;
    data['dvt'] = this.dvt;

    data['description'] = this.description;
    data['price'] = this.price;
    data['discountPercent'] = this.discountPercent;
    data['imageUrl'] = this.imageUrl;
    data['priceAfter'] = this.priceAfter;
    data['stockAmount'] = this.stockAmount;
    data['count'] = this.count;
    data['budgetForItem'] = this.budgetForItem;
    data['residualValueProduct'] = this.residualValueProduct;
    data['residualValue'] = this.residualValue;
    data['unit'] = this.unit;
    if(this.dsCKLineItem!=null){
      data['dsCKLineItem'] = this.dsCKLineItem;
    }else {
      data['dsCKLineItem'] = [];
    }
    data['budgetForProduct'] = this.budgetForProduct;
    data['unitProduct'] = this.unitProduct;
    return data;
  }


  @override
  List<Object> get props => [
   code!,
   name!,
   name2!,
   dvt!,
   description!,
   price!,
   discountPercent!,
   priceAfter!,
   stockAmount!,
   taxPercent!,
   imageUrl!,
   count!,
   isMark!,
   discountMoney!,
   discountProduct!,
   budgetForItem!,
   budgetForProduct!,
   residualValueProduct!,
   residualValue!,
   unit!,
   unitProduct!,
   dsCKLineItem!
   ];
}
