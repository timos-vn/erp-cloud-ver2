import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsSuccess extends CartState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class GetListProductFromDBSuccess extends CartState{

  final bool reGetList;

  GetListProductFromDBSuccess(this.reGetList);

  @override
  String toString() {
    return 'GetListProductFromDBSuccess{}';
  }
}

class CartInitial extends CartState {

  @override
  String toString() => 'CartInitial';
}

class CartFailure extends CartState {
  final String error;

  CartFailure(this.error);

  @override
  String toString() => 'CartFailure { error: $error }';
}

class CartLoading extends CartState {
  @override
  String toString() => 'CartLoading';
}

class TotalMoneyForAppSuccess extends CartState {

  final bool reCalculator;

  TotalMoneyForAppSuccess(this.reCalculator);

  @override
  String toString() => 'TotalMoneyForAppSuccess{} }';
}

class TotalMoneyUpdateOrderSuccess extends CartState {

  @override
  String toString() => 'TotalMoneyForAppSuccess{} }';
}

class TotalMoneyForServerSuccess extends CartState {
  @override
  String toString() => 'TotalMoneyForServerSuccess }';
}

class GetListItemUpdateOrderSuccess extends CartState {
  @override
  String toString() => 'GetListItemUpdateOrderSuccess }';
}

/// search product
///
///

class AddCartSuccess extends CartState {

  @override
  String toString() {
    return 'AddCartSuccess{}';
  }
}

class SearchProductSuccess extends CartState {

  @override
  String toString() => 'SearchProductSuccess';
}
class EmptySearchProductState extends CartState {
  @override
  String toString() {
    // TODO: implement toString
    return 'EmptySearchProductState{}';
  }
}
class RequiredText extends CartState {
  @override
  String toString() {
    // TODO: implement toString
    return 'RequiredText{}';
  }
}
class LoadMoreFinish extends CartState {
  @override
  String toString() {
    // TODO: implement toString
    return 'LoadMoreFinish{}';
  }
}