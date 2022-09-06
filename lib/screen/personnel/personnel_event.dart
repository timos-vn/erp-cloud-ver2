import 'package:equatable/equatable.dart';

abstract class PersonnelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends PersonnelEvent {
  @override
  String toString() => 'GetPrefs';
}

class LoadingTimeKeeping extends PersonnelEvent {

  final String uId;

  LoadingTimeKeeping({required this.uId});

  @override
  String toString() {
    return 'LoadingTimeKeeping{}';
  }
}

class TimeKeepingFromUserEvent extends PersonnelEvent {
  final String datetime;
  final String qrCode;
  final String uId;

  TimeKeepingFromUserEvent(this.datetime, this.qrCode,this.uId);

  @override
  String toString() {
    return 'TimeKeepingFromUserEvent{datetime: $datetime ,qrCode :$qrCode}';
  }
}