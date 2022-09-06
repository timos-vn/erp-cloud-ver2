import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefsCheckIn extends CheckInEvent {
  @override
  String toString() => 'GetPrefsCheckIn';
}

class GetListCheckIn extends CheckInEvent {
  final DateTime dateTime;

  GetListCheckIn({required this.dateTime});
  @override
  String toString() => 'GetListCheckIn: $dateTime';
}

