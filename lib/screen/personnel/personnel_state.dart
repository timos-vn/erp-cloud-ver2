import 'package:equatable/equatable.dart';

abstract class PersonnelState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialPersonnelState extends PersonnelState {

  @override
  String toString() {
    return 'InitialPersonnelState{}';
  }
}

class GetPrefsSuccess extends PersonnelState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class PersonnelLoading extends PersonnelState {

  @override
  String toString() => 'PersonnelLoading';
}

class GetLocationSuccess extends PersonnelState {

  @override
  String toString() {
    return 'GetLocationSuccess{}';
  }
}

class PersonnelFailure extends PersonnelState {
  final String error;

  PersonnelFailure(this.error);

  @override
  String toString() => 'PersonnelFailure { error: $error }';
}

class TimeKeepingFailure extends PersonnelState {
  final String error;

  TimeKeepingFailure(this.error);

  @override
  String toString() => 'TimeKeepingFailure { error: $error }';
}
class TimeKeepingSuccess extends PersonnelState {

  @override
  String toString() {
    return 'TimeKeepingSuccess{}';
  }
}