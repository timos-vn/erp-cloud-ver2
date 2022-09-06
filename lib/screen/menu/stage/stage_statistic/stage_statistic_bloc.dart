import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/network/response/stage_statistic_response.dart';
import 'package:sse/screen/menu/stage/stage_statistic/stage_statistic_event.dart';
import 'package:sse/screen/menu/stage/stage_statistic/stage_statistic_state.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../../model/network/request/stage_statistic_request.dart';
import '../../../../model/network/services/network_factory.dart';

class StageStatisticBloc extends Bloc<StageStatisticEvent,StageStatisticState>{
  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _prefs;
  SharedPreferences? get pref => _prefs;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  int _currentPage = 1;
  int _maxPage = 10;
  bool isScroll = true;
  int get maxPage => _maxPage;

  List<StageStatisticResponseData> _listStage =  <StageStatisticResponseData>[];
  List<StageStatisticResponseData> get listStage => _listStage;

  int valueChange = 0;

  StageStatisticBloc(this.context) : super(StageStatisticInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetListStageStatistic>(_getListStageStatistic);
  }

  void _getPrefs(GetPrefs event, Emitter<StageStatisticState> emitter)async{
    emitter(StageStatisticInitial());
    _prefs = await SharedPreferences.getInstance();
    userName = _prefs!.getString(Const.USER_NAME) ?? "";
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListStageStatistic(GetListStageStatistic event, Emitter<StageStatisticState> emitter)async{
    emitter(StageStatisticInitial());
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    emitter( (!isRefresh && !isLoadMore)
        ? StageStatisticLoading()
        : StageStatisticInitial());
    if (isRefresh) {
      for (int i = 1; i <= _currentPage; i++) {
        StageStatisticState state = await handleCallApi(i,event.idStageStatistic,event.unitId);
        if (!(state is GetListStageSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      isScroll = false;
      _currentPage++;
    }
    StageStatisticState state = await handleCallApi(_currentPage,event.idStageStatistic,event.unitId,);
    emitter(state);
  }

  Future<StageStatisticState> handleCallApi(int pageIndex,String idStageStatistic, String unitId) async {
    StageStatisticRequest request = StageStatisticRequest(
        to: idStageStatistic,
      unitId: unitId,
      pageIndex: pageIndex,
      pageCount: 10
    );

    StageStatisticState state = _handleLoadList(
        await _networkFactory!.getListStageStatistic(request,_accessToken!), pageIndex);
    return state;
  }

  StageStatisticState _handleLoadList(Object data, int pageIndex) {
    if (data is String) return StageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      StageStatisticResponse response = StageStatisticResponse.fromJson(data as Map<String,dynamic>);
      _maxPage = 10;
      List<StageStatisticResponseData>? list = response.data;

      if (!Utils.isEmpty(list!) && _listStage.length >= (pageIndex - 1) * _maxPage + list.length) {
        _listStage.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list);
      } else {
        if (_currentPage == 1)
          _listStage = list;
        else
          _listStage.addAll(list);
      }
      if (Utils.isEmpty(_listStage))
        return GetListStageEmpty();
      else
        isScroll = true;
      return GetListStageSuccess();
    } catch (e) {
      return StageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

}