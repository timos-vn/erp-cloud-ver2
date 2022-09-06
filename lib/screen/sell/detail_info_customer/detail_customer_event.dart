import 'package:equatable/equatable.dart';

abstract class DetailCustomerEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class GetPrefs extends DetailCustomerEvent {
  @override
  String toString() => 'GetPrefs';
}

class GetDetailCustomerEvent extends DetailCustomerEvent {

  final String idCustomer;

  GetDetailCustomerEvent(this.idCustomer);

  @override
  String toString() => 'GetDetailCustomerEvent {idCustomer: $idCustomer}';
}