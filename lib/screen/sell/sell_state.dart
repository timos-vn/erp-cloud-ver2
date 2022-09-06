import 'package:equatable/equatable.dart';

abstract class SellState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialSellState extends SellState {

  @override
  String toString() {
    return 'InitialSellState{}';
  }
}

class GetPrefsSuccess extends SellState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class SellLoading extends SellState {

  @override
  String toString() => 'SellLoading';
}

class GetListHistoryOrderEmpty extends SellState {

  @override
  String toString() {
    return 'GetListHistoryOrderEmpty{}';
  }
}


class DeleteOrderSuccess extends SellState {

  @override
  String toString() {
    return 'DeleteOrderSuccess{}';
  }
}

class GetListHistoryOrderSuccess extends SellState {

  @override
  String toString() {
    return 'GetListHistoryOrderSuccess{}';
  }
}

class ChangePageViewSuccess extends SellState{

  final int valueChange;

  ChangePageViewSuccess(this.valueChange);

  @override
  String toString() {
    return 'ChangePageViewSuccess{valueChange:$valueChange}';
  }
}

class SellFailure extends SellState {
  final String error;

  SellFailure(this.error);

  @override
  String toString() => 'SellFailure { error: $error }';
}