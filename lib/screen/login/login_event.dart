import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String hostURL;
  final String username;
  final String password;

  Login(this.hostURL,this.username, this.password);

  @override
  String toString() => 'Login {hostURL: $hostURL, username: $username, password: $password}';
}

class GetPrefs extends LoginEvent {

  @override
  String toString() => 'GetPrefs';
}
