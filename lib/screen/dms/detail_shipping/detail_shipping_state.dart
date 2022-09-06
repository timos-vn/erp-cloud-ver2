import 'package:equatable/equatable.dart';

abstract class DetailShippingState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailShippingInitial extends DetailShippingState {
  @override
  String toString() => 'DetailShippingInitial';
}
class DetailShippingLoading extends DetailShippingState {
  @override
  String toString() => 'DetailShippingLoading';
}

class GetItemShippingSuccess extends DetailShippingState {

  @override
  String toString() {
    return 'GetItemShippingSuccess{}';
  }
}

class GetListShippingEmpty extends DetailShippingState {

  @override
  String toString() {
    return 'GetListShippingEmpty{}';
  }
}

class ConfirmShippingSuccess extends DetailShippingState {

  @override
  String toString() {
    return 'ConfirmShippingSuccess{}';
  }
}
class GetItemShippingFailure extends DetailShippingState {
  final String error;

  GetItemShippingFailure(this.error);

  @override
  String toString() => 'GetItemShippingFailure { error: $error }';
}

class GetPrefsSuccess extends DetailShippingState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}