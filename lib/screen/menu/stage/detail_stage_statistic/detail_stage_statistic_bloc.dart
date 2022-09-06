import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../../model/network/request/create_tkcd_request.dart';
import '../../../../model/network/request/store_list_request.dart';
import '../../../../model/network/response/detail_stage_statistic_response.dart';
import '../../../../model/network/response/list_store_response.dart';
import '../../../../model/network/services/network_factory.dart';
import 'detail_stage_statistic_state.dart';
import 'detail_stage_statistic_event.dart';

class DetailStageStatisticBloc extends Bloc<DetailStageStatisticEvent,DetailStageStatisticState>{
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
  String? unitId;
  String? userId;

  List<DetailStageStatisticResponseData> _listDetailStage =  <DetailStageStatisticResponseData>[];
  List<DetailStageStatisticResponseData> get listDetailStage => _listDetailStage;

  List<ListStoreResponseData> listStore = <ListStoreResponseData>[];

  int valueChange = 0;

  String? idStore;
  String? nameStore;
  DateTime? dateOrder;

  DetailStageStatisticBloc(this.context) : super(DetailStageStatisticInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<ChooseStore>(_chooseStore);
    on<GetStoreList>(_getStoreList);
    on<CreateTKCD>(_createTKCD);
    on<GetListDetailStageStatistic>(_getListDetailStageStatistic);
  }

  void _getPrefs(GetPrefs event, Emitter<DetailStageStatisticState> emitter)async{
    emitter(DetailStageStatisticInitial());
    _prefs = await SharedPreferences.getInstance();
    userName = _prefs!.getString(Const.USER_NAME) ?? "";
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    unitId = _prefs!.getString(Const.unitId) ?? "";
    userId = _prefs!.getString(Const.USER_ID) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _chooseStore(ChooseStore event, Emitter<DetailStageStatisticState> emitter)async{
    emitter(DetailStageStatisticLoading());
    nameStore = event.nameStore;
    idStore = event.idStore;
    emitter(ChooseStoreSuccess());
  }

  void _getStoreList(GetStoreList event, Emitter<DetailStageStatisticState> emitter)async{
    emitter(DetailStageStatisticLoading());
    StoreListRequest request = StoreListRequest(
        unitId: unitId,
        pageIndex: 1,
        pageCount: 20
    );
    DetailStageStatisticState state = _handleGetStoreList(await _networkFactory!.getStoreList(request,_accessToken!),event.idStage);
    emitter(state);
  }

  void _createTKCD(CreateTKCD event, Emitter<DetailStageStatisticState> emitter)async{
    emitter(DetailStageStatisticLoading());
    CreateTKCDRequest request = CreateTKCDRequest(
        unitId: unitId,
        userId: int.parse(userId!),
        storeId: '',
        lang: 'v',
        admin: 1,
        data: CreateTKCDRequestData(
            sttRec: event.sttRec,
            to: event.idStage.toString(),
            orderDate: dateOrder != null ? DateFormat('yyyy-MM-dd').format(dateOrder!) : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            detail: event.listDetailStage
        )
    );

    DetailStageStatisticState state = _handleCreateTKCD(await _networkFactory!.createTKCD(request,_accessToken!));
    emitter(state);
  }

  void _updateTKCDDraft(UpdateTKCDDraft event, Emitter<DetailStageStatisticState> emitter)async{
    emitter(DetailStageStatisticLoading());
    CreateTKCDRequest request = CreateTKCDRequest(
        unitId: unitId,
        userId: int.parse(userId!),
        storeId: '',
        lang: 'v',
        admin: 1,
        data: CreateTKCDRequestData(
            sttRec: event.sttRec,
            to: event.idStage.toString(),
            orderDate: dateOrder != null ? DateFormat('yyyy-MM-dd').format(dateOrder!) : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            detail: event.listDetailStage
        )
    );
    DetailStageStatisticState state = _handleUpdateTKCDDraft(await _networkFactory!.updateTKCDDraft(request,_accessToken!));
    emitter(state);
  }

  void _getListDetailStageStatistic(GetListDetailStageStatistic event, Emitter<DetailStageStatisticState> emitter)async{
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    emitter((!isRefresh && !isLoadMore)
        ? DetailStageStatisticLoading()
        : DetailStageStatisticInitial());
    if (isRefresh) {
      for (int i = 1; i <= _currentPage; i++) {
        DetailStageStatisticState state = await handleCallApi(i,event.soCt);
        if (!(state is GetListDetailStageSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      isScroll = false;
      _currentPage++;
    }
    DetailStageStatisticState state = await handleCallApi(_currentPage,event.soCt);
    emitter(state);
  }

  Future<DetailStageStatisticState> handleCallApi(int pageIndex,String soCt) async {

    DetailStageStatisticState state = _handleLoadList(
        await _networkFactory!.getDetailListStageStatistic(_accessToken!,soCt), pageIndex);
    return state;
  }

  DetailStageStatisticState _handleLoadList(Object data, int pageIndex) {
    if (data is String) return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      _listDetailStage.clear();
      DetailStageStatisticResponse response = DetailStageStatisticResponse.fromJson(data as Map<String,dynamic>);
      _maxPage = 10;
      List<DetailStageStatisticResponseData>? list = response.data;

      if (!Utils.isEmpty(list!) && _listDetailStage.length >= (pageIndex - 1) * _maxPage + list.length) {
        _listDetailStage.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list);
      } else {
        if (_currentPage == 1)
          _listDetailStage = list;
        else
          _listDetailStage.addAll(list);
      }
      if (Utils.isEmpty(_listDetailStage))
        return GetListDetailStageEmpty();
      else
        isScroll = true;
      return GetListDetailStageSuccess();
    } catch (e) {
      print(e.toString());
      return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  DetailStageStatisticState _handleGetStoreList(Object data, int idStage) {
    if (data is String) return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      ListStoreResponse response = ListStoreResponse.fromJson(data as Map<String,dynamic>);
      listStore = response.data!;
      if(idStage == 1 && unitId == '04'){
        idStore = '404';
        nameStore = 'Kho bán thành phẩm';
      }else if(idStage == 1 && unitId == '05'){
        idStore = '504';
        nameStore = 'Kho bán thành phẩm HY';
      }else if(idStage == 5 && unitId == '04'){
        idStore = '403';
        nameStore = 'Kho thành phẩm Hải Dương';
      }else if(idStage == 5 && unitId == '05'){
        idStore = '503';
        nameStore = 'Kho thành phẩm Hưng Yên';
      }
      return GetListStoreSuccess();
    } catch (e) {
      print(e.toString());
      return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  DetailStageStatisticState _handleCreateTKCD(Object data,) {
    if (data is String) return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      return CreateTKCDSuccess();
    } catch (e) {
      return CreateTKCDFailed('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  DetailStageStatisticState _handleUpdateTKCDDraft(Object data,) {
    if (data is String) return DetailStageStatisticFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      return UpdateTKCDDraftSuccess();
    } catch (e) {
      return UpdateTKCDDraftFailed('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

}