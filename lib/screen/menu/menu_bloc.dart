import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';

import 'menu_event.dart';
import 'menu_state.dart';


class MenuBloc extends Bloc<MenuEvent,MenuState>{
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  int indexBanner = 0;

  MenuBloc(this.context) : super(InitialMenuState()){
    on<GetPrefs>(_getPrefs);

  }


  void _getPrefs(GetPrefs event, Emitter<MenuState> emitter)async{
    emitter(InitialMenuState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }
}