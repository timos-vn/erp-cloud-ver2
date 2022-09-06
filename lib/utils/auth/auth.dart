import 'package:flutter/material.dart';
import 'package:sse/model/models/info_cpn_data.dart';
import 'package:sse/model/models/login_data.dart';

enum AuthMode {hintStore,showStore }

/// The callback triggered after login
/// The result is an error message, callback successes if message is null
typedef LoginCallback = Future<bool?>? Function(LoginData);

typedef InfoCPNCallback = Future<bool?>? Function(InfoCPNData);

class Auth with ChangeNotifier {
  Auth(
      {
        String hotId = '',
        String username = '',
        String password = '',
        String confirmPassword = '',
        this.onLogin,
        this.onInfoCPN,
        AuthMode initialAuthMode = AuthMode.hintStore,
      })
      : _username = username,
        _password = password,
        _mode = initialAuthMode;

  final LoginCallback? onLogin;
  final InfoCPNCallback? onInfoCPN;

  // bool get isLogin => _mode == AuthMode.login;
  bool get isInfoCPN => _mode == AuthMode.hintStore;

  AuthMode _mode = AuthMode.hintStore;
  AuthMode get mode => _mode;
  set mode(AuthMode value) {
    _mode = value;
    notifyListeners();
  }

  AuthMode switchAuth() {
    if (mode == AuthMode.hintStore) {
      mode = AuthMode.showStore;
    } else if (mode == AuthMode.showStore) {
      mode = AuthMode.hintStore;
    }
    return mode;
  }

  String _hotId = '';
  String get hotId => _hotId;
  set hotId(String hotId) {
    _hotId = hotId;
    notifyListeners();
  }

  String _username = '';
  String get username => _username;
  set username(String username) {
    _username = username;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  AuthMode opposite() {
    return AuthMode.hintStore;
  }
}