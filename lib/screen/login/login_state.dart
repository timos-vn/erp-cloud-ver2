import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {

  @override
  String toString() {
    return 'InitialLoginState{}';
  }
}

class GetPrefsSuccess extends LoginState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class LoginLoading extends LoginState {

  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class LoginSuccess extends LoginState {

  @override
  String toString() {
    return 'LoginSuccess{}';
  }
}