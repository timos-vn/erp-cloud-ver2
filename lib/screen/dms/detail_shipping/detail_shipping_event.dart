import 'package:equatable/equatable.dart';

abstract class DetailShippingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetItemShippingEvent extends DetailShippingEvent {

  final String sstRec;

  GetItemShippingEvent(this.sstRec);

  @override
  String toString() => 'GetItemShippingEvent {}';
}

class ConfirmShippingEvent extends DetailShippingEvent {

  final String? sstRec;
  final int? typePayment;

  ConfirmShippingEvent({this.sstRec,this.typePayment});

  @override
  String toString() => 'ConfirmShippingEvent {}';
}
class GetPrefs extends DetailShippingEvent {
  @override
  String toString() => 'GetPrefs';
}