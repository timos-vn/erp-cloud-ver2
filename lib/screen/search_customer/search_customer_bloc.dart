// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/search_customer/search_customer_event.dart';
import 'package:sse/screen/search_customer/search_customer_state.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../model/network/request/manager_customer_request.dart';
import '../../model/network/response/manager_customer_response.dart';
import '../../model/network/services/network_factory.dart';

class SearchCustomerBloc extends Bloc<SearchCustomerEvent, SearchCustomerState> {
  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String get accessToken => _accessToken!;
  String? _refreshToken;
  String get refreshToken => _refreshToken!;
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  List<ManagerCustomerResponseData> _searchResults = <ManagerCustomerResponseData>[];
  bool isScroll = true;
  bool isShowCancelButton = false;
  int _currentPage = 1;
  int _maxPage = Const.MAX_COUNT_ITEM;
  String? _currentSearchText;

  int get maxPage => _maxPage;

  List<ManagerCustomerResponseData> get searchResults => _searchResults;

  int get currentPage => _currentPage;


  void reset() {
    _currentSearchText = "";
    _currentPage = 1;
    _searchResults.clear();
  }

  SearchCustomerBloc(this.context) : super(InitialSearchState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<SearchCustomer>(_searchCustomer);
    on<CheckShowCloseEvent>(_checkShowCloseEvent);

  }

  void _getPrefs(GetPrefs event, Emitter<SearchCustomerState> emitter)async{
    emitter(InitialSearchState());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _searchCustomer(SearchCustomer event, Emitter<SearchCustomerState> emitter)async{
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    String searchText = event.searchText;
    emitter((!isRefresh && !isLoadMore)
        ? SearchLoading()
        : InitialSearchState());
    if (_currentSearchText != searchText) {
      _currentSearchText = searchText;
      _currentPage = 1;
      _searchResults.clear();
    }
    if (isRefresh) {
      for (int i = 1; i <= _currentPage; i++) {
        SearchCustomerState state = await handleCallApi(searchText, i);
        if (!(state is SearchSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      isScroll = false;
      _currentPage++;
    }
    if (event.searchText != null && event.searchText != '') {
      if (event.searchText.length > 0) {
        SearchCustomerState state = await handleCallApi(searchText, _currentPage);
        emitter(state);
      } else {
        emitter(EmptySearchState());
      }
    } else {
      emitter(InitialSearchState());
      emitter(RequiredText());
    }
  }

  void _checkShowCloseEvent(CheckShowCloseEvent event, Emitter<SearchCustomerState> emitter)async{
    emitter(SearchLoading());
    isShowCancelButton = !Utils.isEmpty(event.text);
    emitter(InitialSearchState());
  }

  Future<SearchCustomerState> handleCallApi(String searchText, int pageIndex) async {
    ManagerCustomerRequestBody request = new ManagerCustomerRequestBody(
        type: 1,
        searchValue: searchText,
        pageIndex: pageIndex);
    SearchCustomerState state = _handleSearch(await _networkFactory!.getListCustomer(request,_accessToken!), pageIndex);
    return state;
  }

  SearchCustomerState _handleSearch(Object data, int pageIndex) {
    if (data is String) return SearchFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      ManagerCustomerResponse response = ManagerCustomerResponse.fromJson(data as Map<String,dynamic>);
      _maxPage = 20;//response.pageIndex ?? Const.MAX_COUNT_ITEM;
      List<ManagerCustomerResponseData> list = response.data ?? [];
      if (!Utils.isEmpty(list) && _searchResults.length >= (pageIndex - 1) * _maxPage + list.length) {
        _searchResults.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list); /// delete list cũ -> add data mới vào list đó.
        var xpe = _searchResults.toList();
        print(xpe);
      } else {
        if (_currentPage == 1) {
          _searchResults = list;
        } else
          _searchResults.addAll(list);
      }
      if (_searchResults.length > 0) {
        isScroll = true;
        return SearchSuccess();
      } else {
        return EmptySearchState();
      }
    } catch (e) {
      print(e.toString());
      return SearchFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }
}
