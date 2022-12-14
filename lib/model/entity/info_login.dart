import 'dart:convert';

import 'package:equatable/equatable.dart';

class InfoLogin extends Equatable {
  final String code;
  final String name;
  final String hotURL;
  final String id;
  final String pass;

  InfoLogin(
      this.code,
      this.name,
      this.hotURL,
      this.id,
      this.pass
     );

  InfoLogin.fromDb(Map<String, dynamic> map)
      :
        code = map['code'],
        name = map['name'],
        hotURL = map['hot'],
        id = map['id'],
        pass = map['pass'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['code'] = code;
    map['name'] = name;
    map['hot'] = hotURL;
    map['id'] = id;
    map['pass'] = pass;
    return map;
  }

  @override
  List<Object> get props => [
    code,
    name,
    hotURL,
    id,
    pass,
  ];
}
