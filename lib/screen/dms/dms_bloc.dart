import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';

import 'dms_event.dart';
import 'dms_state.dart';


class DMSBloc extends Bloc<DMSEvent,DMSState>{

  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  int indexBanner = 0;

  DMSBloc() : super(InitialDMSState()){
    on<GetPrefs>(_getPrefs);

  }


  void _getPrefs(GetPrefs event, Emitter<DMSState> emitter)async{
    emitter(InitialDMSState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }
}