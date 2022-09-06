import 'package:equatable/equatable.dart';

abstract class TimeKeepingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsTimeKeeping extends TimeKeepingEvent {
  @override
  String toString() => 'GetPrefsTimeKeeping';
}

class LoadingTimeKeeping extends TimeKeepingEvent {

  final String uId;

  LoadingTimeKeeping({required this.uId});

  @override
  String toString() {
    return 'LoadingTimeKeeping{}';
  }
}

class TimeKeepingFromUserEvent extends TimeKeepingEvent {
  final String datetime;
  final String qrCode;
  final String uId;

  TimeKeepingFromUserEvent(this.datetime, this.qrCode,this.uId);

  @override
  String toString() {
    return 'TimeKeepingFromUserEvent{datetime: $datetime ,qrCode :$qrCode}';
  }
}