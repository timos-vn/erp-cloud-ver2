import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends HomeEvent {
  @override
  String toString() => 'GetPrefs';
}

class SetStateEvent extends HomeEvent {
  @override
  String toString() => 'SetStateEvent';
}

class GetDataDefault extends HomeEvent {
  @override
  String toString() => 'GetDataDefault {}';
}

class ChangeValueTime extends HomeEvent {
  final String timeId;

  ChangeValueTime({required this.timeId});
  @override
  String toString() => 'ChangeValueTime {timeId:$timeId}';
}

class GetReportData extends HomeEvent {

  final String reportId;
  final String timeId;
  final String? unitId;
  final String? storeId;

  GetReportData({required this.reportId, required this.timeId, this.unitId, this.storeId});

  @override
  String toString() => 'GetReportData {reportId: {$reportId}, timeId: {$timeId},unitId: {$unitId},storeId: {$storeId},}';
}
