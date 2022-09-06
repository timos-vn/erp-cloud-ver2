import 'package:equatable/equatable.dart';
import 'package:sse/model/entity/product.dart';

import '../../../model/network/response/search_list_item_response.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends CartEvent {
  @override
  String toString() => 'GetPrefs';
}

class TotalDiscountAndMoneyForAppEvent extends CartEvent {

  final List<Product> listProduct;
  final bool viewUpdateOrder;
  final bool reCalculator;

  TotalDiscountAndMoneyForAppEvent({required this.listProduct,required this.viewUpdateOrder,required this.reCalculator});

  @override
  String toString() => 'TotalDiscountAndMoneyForAppEvent {listProduct: $listProduct,}';
}

class CheckDisCountWhenUpdateEvent extends CartEvent {

  final String sttRec;
  final bool viewUpdateOrder;
  final bool addNewItem;
  final String codeCustomer;
  final String codeStore;

  CheckDisCountWhenUpdateEvent(this.sttRec,this.viewUpdateOrder,
      {this.addNewItem = false,required this.codeCustomer,required this.codeStore,});

  @override
  String toString() => 'CheckDisCountWhenUpdateEvent {sttRec$sttRec}';
}


class GetListItemUpdateOrderEvent extends CartEvent {

  final String sttRec;

  GetListItemUpdateOrderEvent(this.sttRec);

  @override
  String toString() => 'GetListItemUpdateOrderEvent {sttRec: $sttRec,}';
}

class GetListProductFromDB extends CartEvent {

  @override
  String toString() => 'GetListProductFromDB{}';
}

class DeleteProductFromDB extends CartEvent {
  final bool viewUpdateOrder;
  final int index;
  final Product itemProduct;

  DeleteProductFromDB(this.viewUpdateOrder,this.index,this.itemProduct);

  @override
  String toString() => 'DeleteProductFromDB{}';
}

class Decrement extends CartEvent{
  final int index;
  Decrement(this.index);
  @override
  String toString() {
    return 'Decrement{}';
  }
}

class Increment extends CartEvent{
  final int index;
  Increment(this.index);
  @override
  String toString() {
    return 'Increment{}';
  }
}

/// search product
///
///

class AddCartEvent extends CartEvent {

  final Product? productItem;

  AddCartEvent({this.productItem});

  @override
  String toString() {
    return 'AddCartEvent{productItem: $productItem}';
  }
}

class SearchProduct extends CartEvent {
  final String searchText;
  final int idGroup;
  final String selected;
  final bool isLoadMore;
  final bool isRefresh;

  SearchProduct(this.searchText, this.idGroup,this.selected,{this.isLoadMore = false, this.isRefresh = false});

  @override
  String toString() {
    return 'SearchProduct{searchText: $searchText, isLoadMore: $isLoadMore, isRefresh: $isRefresh}';
  }
}
class CheckShowCloseEvent extends CartEvent {
  final String text;
  CheckShowCloseEvent(this.text);

  @override
  String toString() {
    // TODO: implement toString
    return 'CheckShowCloseEvent{}';
  }
}
