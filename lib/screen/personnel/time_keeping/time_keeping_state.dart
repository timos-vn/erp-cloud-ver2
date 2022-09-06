import 'package:equatable/equatable.dart';

abstract class TimeKeepingState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTimeKeepingState extends TimeKeepingState {

  @override
  String toString() {
    return 'InitialTimeKeepingState{}';
  }
}

class GetPrefsSuccess extends TimeKeepingState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class TimeKeepingLoading extends TimeKeepingState {

  @override
  String toString() => 'TimeKeepingLoading';
}

class TimeKeepingFailure extends TimeKeepingState {
  final String error;

  TimeKeepingFailure(this.error);

  @override
  String toString() => 'TimeKeepingFailure { error: $error }';
}

class TimeKeepingSuccess extends TimeKeepingState {

  @override
  String toString() {
    return 'TimeKeepingSuccess{}';
  }
}

class GetLocationSuccess extends TimeKeepingState {

  @override
  String toString() {
    return 'GetLocationSuccess{}';
  }
}