import 'package:equatable/equatable.dart';

abstract class CheckInState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialCheckInState extends CheckInState {

  @override
  String toString() {
    return 'InitialCheckInState{}';
  }
}

class GetPrefsSuccess extends CheckInState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class GetListCheckInSuccess extends CheckInState{

  @override
  String toString() {
    return 'GetListCheckInSuccess{}';
  }
}

class CheckInLoading extends CheckInState {

  @override
  String toString() => 'CheckInLoading';
}

class CheckInFailure extends CheckInState {
  final String error;

  CheckInFailure(this.error);

  @override
  String toString() => 'CheckInFailure { error: $error }';
}

class GetListSCheckInEmpty extends CheckInState {

  @override
  String toString() {
    return 'GetListSCheckInEmpty{}';
  }
}
