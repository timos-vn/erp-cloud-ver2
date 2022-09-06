import 'package:equatable/equatable.dart';

abstract class SellEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends SellEvent {
  @override
  String toString() => 'GetPrefs';
}

class GetListHistoryOrder extends SellEvent {

  final bool isRefresh;
  final bool isLoadMore;
  final int status;
  final DateTime dateFrom;
  final DateTime dateTo;

  GetListHistoryOrder({this.isRefresh = false, this.isLoadMore = false,required this.status,required this.dateFrom,required this.dateTo});

  @override
  String toString() => 'GetListHistoryOrder {}';
}

class ChangePageViewEvent extends SellEvent {

  final int valueChange;

  ChangePageViewEvent(this.valueChange);

  @override
  String toString() => 'ChangePageViewEvent{valueChange:$valueChange}';
}

class DeleteEvent extends SellEvent {

  final String sttRec;

  DeleteEvent({required this.sttRec});

  @override
  String toString() {
    return 'DeleteEvent{sttRec:$sttRec}';
  }
}