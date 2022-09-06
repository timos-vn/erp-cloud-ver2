import 'package:equatable/equatable.dart';

abstract class DetailCustomerState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsSuccess extends DetailCustomerState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class DetailCustomerInitial extends DetailCustomerState {

  @override
  String toString() => 'DetailCustomerInitial';
}

class DetailCustomerFailure extends DetailCustomerState {
  final String error;

  DetailCustomerFailure(this.error);

  @override
  String toString() => 'DetailCustomerFailure { error: $error }';
}

class DetailCustomerLoading extends DetailCustomerState {
  @override
  String toString() => 'DetailCustomerLoading';
}

class GetDetailCustomerSuccess extends DetailCustomerState {
  @override
  String toString() => 'GetDetailCustomerSuccess }';
}

class DetailCustomerEmpty extends DetailCustomerState {

  @override
  String toString() {
    return 'DetailCustomerEmpty{}';
  }
}

