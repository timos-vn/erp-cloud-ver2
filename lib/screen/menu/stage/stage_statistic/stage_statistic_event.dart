import 'package:equatable/equatable.dart';

abstract class StageStatisticEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetListStageStatistic extends StageStatisticEvent {

  final bool isRefresh;
  final bool isLoadMore;
  final String idStageStatistic;
  final String unitId;
  GetListStageStatistic({this.isRefresh = false, this.isLoadMore = false,required this.idStageStatistic,required this.unitId});

  @override
  String toString() => 'GetListStageStatistic {}';
}

class GetDetailStageStatistic extends StageStatisticEvent {
  final String soCt;
  GetDetailStageStatistic({required this.soCt});

  @override
  String toString() => 'GetDetailStageStatistic {}';
}

class GetPrefs extends StageStatisticEvent {
  @override
  String toString() => 'GetPrefs';
}