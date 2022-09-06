import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/sell/sell_event.dart';
import 'package:sse/screen/sell/sell_state.dart';
import 'package:sse/utils/const.dart';

import '../../model/network/request/list_history_order_request.dart';
import '../../model/network/response/list_history_order_response.dart';
import '../../model/network/services/network_factory.dart';
import '../../utils/utils.dart';


class SellBloc extends Bloc<SellEvent,SellState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  late DateTime dateFrom;
  late DateTime dateTo;
  int valueChange = 0;
  bool isScroll = true;

  int _currentPage = 1;
  int _maxPage = 10;

  List<Values> _list = <Values>[];
  List<Values> get list => _list;
  int get maxPage => _maxPage;

  SellBloc(this.context) : super(InitialSellState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetListHistoryOrder>(_getListHistoryOrder);
    on<DeleteEvent>(_deleteEvent);
    on<ChangePageViewEvent>(_changePageViewEvent);

  }


  void _getPrefs(GetPrefs event, Emitter<SellState> emitter)async{
    emitter(InitialSellState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _deleteEvent(DeleteEvent event, Emitter<SellState> emitter)async{
    emitter(SellLoading());
    SellState state = _handleDeleteOrderHistory(await _networkFactory!.deleteOrderHistory(_accessToken!,event.sttRec));
    emitter(state);
  }

  void _changePageViewEvent(ChangePageViewEvent event, Emitter<SellState> emitter)async{
    emitter(InitialSellState());
    valueChange = event.valueChange;
    emitter(ChangePageViewSuccess(valueChange));
  }

  void _getListHistoryOrder(GetListHistoryOrder event, Emitter<SellState> emitter)async{
    emitter(InitialSellState());
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    emitter((!isRefresh && !isLoadMore)
        ? SellLoading()
        : InitialSellState()) ;
    if (isRefresh) {
      for (int i = 1; i <= _currentPage; i++) {
        SellState state = await handleCallApi(i,event.status,event.dateFrom,event.dateTo);
        if (!(state is GetListHistoryOrderSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      isScroll = false;
      _currentPage++;
    }
    SellState state = await handleCallApi(_currentPage,event.status,event.dateFrom,event.dateTo);
    emitter(state);
  }

  SellState _handleDeleteOrderHistory(Object data){
    if(data is String) return SellFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      return DeleteOrderSuccess();
    }catch(e){
      print(e.toString());
      return  SellFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  Future<SellState> handleCallApi(int pageIndex,int status, DateTime dateFrom,DateTime dateTo) async {
    ListHistoryOrderRequest request = ListHistoryOrderRequest(
        letterTypeId: 'ORDERLIST',
        pageIndex: pageIndex,
        status: status.toString(),
        dateFrom: dateFrom.toString(),
        dateTo: dateTo.toString(),
        firstElement: '',
        lastElement: '',
        totalRec: 0,
        timeFilter: ''
    );

    SellState state = _handleLoadList(await _networkFactory!.getListHistoryOrder(request,_accessToken!), pageIndex);
    return state;
  }

  SellState _handleLoadList(Object data, int pageIndex) {
    if (data is String) return SellFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      _list.clear();
      ListHistoryOrderResponse response = ListHistoryOrderResponse.fromJson(data as Map<String,dynamic>);
      _maxPage = 10;
      List<Values>? list = response.values;

      if (!Utils.isEmpty(list!) && _list.length >= (pageIndex - 1) * _maxPage + list.length) {
        _list.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list);
      } else {
        if (_currentPage == 1)
          _list = list;
        else
          _list.addAll(list);
      }
      if (Utils.isEmpty(_list))
        return GetListHistoryOrderEmpty();
      else
        isScroll = true;
      return GetListHistoryOrderSuccess();
    } catch (e) {
      return SellFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }
}