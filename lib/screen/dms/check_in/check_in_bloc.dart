import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/network/request/get_list_checkin_request.dart';
import 'package:sse/model/network/response/list_checkin_response.dart';
import 'package:sse/model/network/services/network_factory.dart';
import 'package:sse/utils/const.dart';

import 'check_in_event.dart';
import 'check_in_state.dart';


class CheckInBloc extends Bloc<CheckInEvent,CheckInState>{
  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  int indexBanner = 0;

  List<ListCheckIn> listCheckInToDay = <ListCheckIn>[];
  List<ListCheckIn> listCheckInOther = <ListCheckIn>[];

  CheckInBloc(this.context) : super(InitialCheckInState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefsCheckIn>(_getPrefs);
    on<GetListCheckIn>(_getListCheckIn);
  }


  void _getPrefs(GetPrefsCheckIn event, Emitter<CheckInState> emitter)async{
    emitter(InitialCheckInState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListCheckIn(GetListCheckIn event, Emitter<CheckInState> emitter)async{
    emitter(CheckInLoading());
    ListCheckInRequest request = ListCheckInRequest(
      datetime: '2022-09-02'// event.dateTime.toString()
    );

    CheckInState state = _handleGetListCheckIn(await _networkFactory!.getListCheckIn(request,_accessToken!));
    emitter(state);
  }

  CheckInState _handleGetListCheckIn(Object data){
    if(data is String) return CheckInFailure('Úi, Đại Vương ơi '+ ": ${data.toString()}");
    try{
      ListCheckInResponse response = ListCheckInResponse.fromJson(data as Map<String,dynamic>);
      listCheckInToDay = response.listCheckInToDay!;
      listCheckInOther = response.listCheckInOther!;
      if(listCheckInToDay.isEmpty && listCheckInOther.isEmpty){
        return GetListSCheckInEmpty();
      }else{
        return GetListCheckInSuccess();
      }
    }catch(e){
      print(e.toString());
      return CheckInFailure('Úi, Đại Vương ơi '+ ": ${e.toString()}");
    }
  }
}