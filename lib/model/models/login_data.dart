import 'package:quiver/core.dart';

class LoginData {
  final String hotId;
  final String username;
  final String password;

  LoginData({required this.hotId,required this.username, required this.password});

  @override
  String toString() {
    return '$runtimeType($hotId, $username, $password)';
  }

  @override
  bool operator ==(Object other) {
    if (other is LoginData) {
      return hotId == other.hotId && username == other.username && password == other.password;
    }
    return false;
  }

  @override
  int get hashCode => hash3(hotId, username, password);
}