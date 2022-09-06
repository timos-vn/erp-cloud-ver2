import 'package:equatable/equatable.dart';
import 'package:sse/model/entity/product.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends OrderEvent {
  @override
  String toString() => 'GetPrefs';
}

class GetListOderEvent extends OrderEvent {

  final String? searchValues;
  final String? codeCurrency;
  final int idGroup;
  final int? pageIndex;
  final bool? isRefresh;
  final bool? isLoadMore;
  final bool? isReLoad;
  final bool? isScroll;

  GetListOderEvent({this.searchValues,this.codeCurrency,required this.idGroup,this.pageIndex,this.isRefresh = false, this.isLoadMore = false,this.isReLoad,this.isScroll});

  @override
  String toString() => 'GetListOderEvent {idApproval: $searchValues,codeCurrency : $codeCurrency,idGroup: $idGroup,isLoadMore: $isLoadMore, isRefresh: $isRefresh, }';
}

class PickCurrencyName extends OrderEvent {

  final String currencyName;
  final String currencyCode;

  PickCurrencyName({required this.currencyName,required this.currencyCode});

  @override
  String toString() {
    return 'PickCurrencyName{ currencyName: $currencyName,currencyCode: $currencyCode}';
  }
}

class PickGroupProduct extends OrderEvent {

  final String codeGroup;
  final String nameGroup;

  PickGroupProduct({required this.codeGroup,required this.nameGroup});

  @override
  String toString() {
    return 'PickGroupProduct{ codeGroup: $codeGroup,nameGroup: $nameGroup}';
  }
}

class GetListGroupProductEvent extends OrderEvent {

  @override
  String toString() {
    return 'GetListGroupProductEvent{}';
  }
}

class GetListItemGroupEvent extends OrderEvent {

  final int? codeGroup;
  final bool isRefresh;
  final bool isLoadMore;

  GetListItemGroupEvent({this.codeGroup,this.isRefresh = false, this.isLoadMore = false});

  @override
  String toString() {
    return 'GetListItemGroupEvent{codeGroup: $codeGroup}';
  }
}

class AddCartEvent extends OrderEvent {

  final Product? productItem;

  AddCartEvent({this.productItem});

  @override
  String toString() {
    return 'AddCartEvent{productItem: $productItem}';
  }
}

class ScanItemEvent extends OrderEvent {

  final String codeItem;
  final String currencyCode;

  ScanItemEvent(this.codeItem,this.currencyCode);

  @override
  String toString() {
    return 'ScanItemEvent{codeItem: $codeItem, currencyCode:$currencyCode}';
  }
}
class SearchItemGroupEvent extends OrderEvent {

  final String keysText;

  SearchItemGroupEvent(this.keysText);

  @override
  String toString() {
    return 'SearchItemGroupEvent{keysText: $keysText}';
  }
}

class GetCountProductEvent extends OrderEvent{

  final bool firstLoad;

  GetCountProductEvent(this.firstLoad);

  @override
  String toString() {
    return 'GetCountProductEvent{}';
  }
}