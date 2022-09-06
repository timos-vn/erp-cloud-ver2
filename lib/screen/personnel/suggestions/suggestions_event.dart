import 'package:equatable/equatable.dart';

import '../../../model/network/request/create_dnc_request.dart';

abstract class SuggestionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsSuggestions extends SuggestionsEvent {
  @override
  String toString() => 'GetPrefsSuggestions';
}

class CreateDNC extends SuggestionsEvent {

  @override
  String toString() {
    return 'CreateDNC{}';
  }
}

class GetListDNC extends SuggestionsEvent {

  final bool isRefresh;
  final bool isLoadMore;
  final String dateFrom;
  final String dateTo;
  final String type;
  GetListDNC({this.isRefresh = false, this.isLoadMore = false,required this.dateFrom,required this.dateTo,required this.type});

  @override
  String toString() => 'GetListDNC {}';
}

class GetDetailDNC extends SuggestionsEvent {

  final String sttRec;

  GetDetailDNC({required this.sttRec});

  @override
  String toString() => 'GetDetailDNC {}';
}

class AddOrRemoveCoreWater extends SuggestionsEvent {

  final bool type;
  final ListDNCDataDetail2 item;
  final int? index;

  AddOrRemoveCoreWater({required this.type,required this.item, this.index});

  @override
  String toString() => 'AddOrRemoveCoreWater{item:$item}';
}

class CreateDNCEvent extends SuggestionsEvent {

  final String typePayment;
  final String typeTransaction;
  final String desc;
  final String departmentCode;
  final List<ListAttachFile> attachFile;

  CreateDNCEvent({required this.typePayment,required this.typeTransaction,required this.desc,required this.departmentCode,required this.attachFile});

  @override
  String toString() => 'CreateDNCEvent{}';
}

class ConfirmDNCEvent extends SuggestionsEvent {

  final String action;
  final String levelApproval;
  final String sttRec;

  ConfirmDNCEvent({required this.action,required this.levelApproval,required this.sttRec});

  @override
  String toString() => 'CreateDNCEvent{}';
}

