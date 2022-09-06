// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sse/model/database/data_local.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';
import '../../../model/database/dbhelper.dart';
import '../../../model/entity/product.dart';
import '../../../model/network/request/search_list_item_request.dart';
import '../../../model/network/response/group_product_response.dart';
import '../../../model/network/response/list_item_scan_reponse.dart';
import '../../../model/network/response/search_list_item_response.dart';
import '../../../model/network/services/network_factory.dart';

import 'order_event.dart';
import 'order_sate.dart';

class OrderBloc extends Bloc<OrderEvent,OrderState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String get accessToken => _accessToken!;
  String? _refreshToken;
  String get refreshToken => _refreshToken!;
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;
  DatabaseHelper db = DatabaseHelper();
  List<Product> listProduct = <Product>[];

  late List<SearchItemResponseData> listItemOrder = <SearchItemResponseData>[];
  late List<SearchItemResponseData> listItemOrderFixColor = <SearchItemResponseData>[];

  List<GroupProductResponseData>? listGroupProduct = <GroupProductResponseData>[];

  List<GroupProductResponseData>? _listItemGroupProduct = <GroupProductResponseData>[];
  List<GroupProductResponseData> get listItemGroupProduct => _listItemGroupProduct!;

  List<GroupProductResponseData> listItemReSearch = <GroupProductResponseData>[];

  int _currentPage = 1;
  int _maxPage = Const.MAX_COUNT_ITEM;
  int get maxPage => _maxPage;
  int get currentPage => _currentPage;

  int _currentPage2 = 1;
  int _maxPage2 = Const.MAX_COUNT_ITEM;
  int get maxPage2 => _maxPage2;
  int get currentPage2 => _currentPage2;
  bool isScroll = true;
  String currencyName ='VNĐ';
  String groupProductName='Loại nhóm 1';
  List<int> listSelectedAttr = [];

  int countProductCart = 0;
  int totalPager = 0;

  Future<List<Product>> getListFromDb() {
    return db.fetchAllProduct();
  }

  OrderBloc(this.context) : super(OrderInitialState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<PickCurrencyName>(_pickCurrencyName);
    on<SearchItemGroupEvent>(_searchItemGroup);
    on<PickGroupProduct>(_pickGroupProduct);
    on<GetListItemGroupEvent>(_getListItemGroupEvent);
    on<GetListOderEvent>(_getListOderEvent);
    on<GetListGroupProductEvent>(_getListGroupProductEvent);
    on<ScanItemEvent>(_scanItemEvent);
    on<AddCartEvent>(_addCartEvent);
    on<GetCountProductEvent>(_getCountProductEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<OrderState> emitter)async{
    emitter(OrderInitialState());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _searchItemGroup(SearchItemGroupEvent event, Emitter<OrderState> emitter){
    emitter(OrderLoading());
    listItemReSearch = getSuggestions(event.keysText);
    print(listItemReSearch.length);
    emitter(SearchItemGroupSuccess());
  }

  List<GroupProductResponseData> getSuggestions(String query) {
    List<GroupProductResponseData> matches = [];
    matches.addAll(listItemGroupProduct);
    matches.retainWhere((s) => s.groupName.toString().toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void _pickCurrencyName(PickCurrencyName event, Emitter<OrderState> emitter){
    emitter(OrderLoading());
    currencyName = event.currencyName;
    emitter(PickCurrencyNameSuccess(event.currencyCode));
  }

  void _pickGroupProduct(PickGroupProduct event, Emitter<OrderState> emitter){
    emitter(OrderLoading());
    groupProductName = event.nameGroup;
    emitter(PickupGroupProductSuccess());
  }

  void _getListItemGroupEvent(GetListItemGroupEvent event, Emitter<OrderState> emitter)async{
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    emitter((!isRefresh && !isLoadMore)
        ? OrderLoading()
        : OrderInitialState());
    if (isRefresh) {
      for (int i = 1; i <= _currentPage2; i++) {
        OrderState state = await _handleCallApiItemProduct(event.codeGroup!,i);
        if (!(state is GetListItemGroupSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      _currentPage2++;
    }
    OrderState state = await _handleCallApiItemProduct(event.codeGroup!,_currentPage2);
    emitter(state);
  }

  void _getListOderEvent(GetListOderEvent event, Emitter<OrderState> emitter)async{
    emitter(OrderLoading());
    OrderState state = await handleCallApi(event.searchValues!,event.pageIndex!,event.codeCurrency!,event.idGroup);
    emitter(state);
  }

  void _getListGroupProductEvent(GetListGroupProductEvent event, Emitter<OrderState> emitter)async{
    emitter(OrderLoading());
    OrderState state = _handleGetListGroupProduct(await _networkFactory!.getItemMainGroup(_accessToken!));
    emitter(state);
  }

  void _scanItemEvent(ScanItemEvent event, Emitter<OrderState> emitter)async{
    // emitter(OrderLoading());
    // OrderState state = _handleScanItem(await _networkFactory!.getListItemScanRequest(_accessToken!,event.codeItem,event.currencyCode));
    // emitter(state);
  }

  void _addCartEvent(AddCartEvent event, Emitter<OrderState> emitter)async{
    emitter(OrderLoading());
    // if (DataLocal.listStore.isNotEmpty) {
    //   DataLocal.listStore.removeWhere((element) => element.code == event.item?.code);
    //   DataLocal.listStore.add(event.item!);
    // }else{
    //   DataLocal.listStore.add(event.item!);
    // }
    // if (event.item?.count == 0) {
    //   DataLocal.listStore.removeWhere((element) => element.code == event.item?.code);
    // }
    await db.addProduct(event.productItem!);
    emitter(AddCartSuccess());
  }

  void _getCountProductEvent(GetCountProductEvent event, Emitter<OrderState> emitter)async{
    emitter(OrderLoading());
    listProduct = await getListFromDb();
    emitter(GetCountProductSuccess(event.firstLoad));
  }

  // OrderState _handleScanItem(Object data){
  //   if (data is String) return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!' + ' :${data.toString()}');
  //   try{
  //     ListItemScanResponse response = ListItemScanResponse.fromJson(data as Map<String,dynamic>);
  //     DataScan? itemScan = response.data;
  //     final valueItemScan = DataLocal.listStore.firstWhere((item) => item.code == itemScan?.code);
  //     // ignore: unnecessary_null_comparison
  //     if (valueItemScan != null) {
  //       double countItem = valueItemScan.count! + 1;
  //       DataLocal.listStore.removeWhere((element) => element.code == itemScan?.code);
  //       SearchItemResponseData itemData =new  SearchItemResponseData(
  //           code: itemScan?.code,
  //           name: itemScan?.name,
  //           name2: itemScan?.name2,
  //           dvt: itemScan?.dvt,
  //           descript: itemScan?.descript,
  //           price: itemScan?.price,
  //           discountPercent: itemScan?.discountPercent,
  //           imageUrl: itemScan?.imageUrl,
  //           priceAfter: itemScan?.priceAfter,
  //           stockAmount: itemScan?.stockAmount,
  //           count: countItem
  //       );
  //       DataLocal.listStore.add(itemData);
  //     } else {
  //       SearchItemResponseData itemData =new  SearchItemResponseData(
  //           code: itemScan?.code,
  //           name: itemScan?.name,
  //           name2: itemScan?.name2,
  //           dvt: itemScan?.dvt,
  //           descript: itemScan?.descript,
  //           price: itemScan?.price,
  //           discountPercent: itemScan?.discountPercent,
  //           imageUrl: itemScan?.imageUrl,
  //           priceAfter: itemScan?.priceAfter,
  //           stockAmount: itemScan?.stockAmount,
  //           count: 1
  //       );
  //       DataLocal.listStore.add(itemData);
  //     }
  //     return ItemScanSuccess();
  //   }catch(e){
  //     return OrderFailure(e.toString());
  //   }
  // }

  OrderState _handleGetListGroupProduct(Object data){
    if (data is String) return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      GroupProductResponse response = GroupProductResponse.fromJson(data as Map<String,dynamic>);
      listGroupProduct = response.data;
      return GetListGroupProductSuccess();
    }
    catch(e){
      print(e);
      return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  Future<OrderState> handleCallApi(String textSearch,int pageIndex,String codeCurrency,int idGroup) async {
    String input='';
    print(textSearch.toString());
    if(textSearch.isNotEmpty == true && textSearch.toString() != 'null'){
      input = textSearch.toString();
    }
    SearchListItemRequest request = SearchListItemRequest(
      searchValue: '',
      pageIndex: pageIndex,
      currency: codeCurrency,
      itemGroup: idGroup == 1 ? input:'',
      itemGroup2: idGroup == 2 ? input : '',
      itemGroup3: idGroup == 3 ? input: '',
      itemGroup4: idGroup == 4 ? input: '',
      itemGroup5: idGroup == 5 ? input: ''
    );
    OrderState state = _handlerGetListOrder(await _networkFactory!.getItemListSearchOrder(request, _accessToken!),pageIndex);
    return state;
  }

  Future<OrderState> _handleCallApiItemProduct(int codeGroup,int pageIndex) async {

    OrderState state = _handlerGetListItemProduct(await _networkFactory!.getItemGroup(_accessToken!,codeGroup,1),pageIndex);
    return state;
  }

  OrderState _handlerGetListItemProduct(Object data,int pageIndex){
    if(data is String) return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      GroupProductResponse response = GroupProductResponse.fromJson(data as Map<String,dynamic>);
      List<GroupProductResponseData> list = response.data ?? [];
      _listItemGroupProduct = list;
      GroupProductResponseData itemAll = GroupProductResponseData(
        groupType: 1,
        groupCode: '',
        groupName: 'Tất cả sản phẩm',
        iconUrl: ''
      );
      _listItemGroupProduct?.insert(0, itemAll);
      return Success();
    }
    catch(e){
      print(e);
      return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  OrderState _handlerGetListOrder(Object data,int pageIndex){
    if(data is String) return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      if(listItemOrder.length > 0)
        listItemOrder.clear();
      if(listItemOrderFixColor.length > 0)
        listItemOrderFixColor.clear();
      SearchListItemResponse response = SearchListItemResponse.fromJson(data as Map<String,dynamic>);
      _maxPage =  20;//Const.MAX_COUNT_ITEM
      totalPager = response.totalCount!;
      List<SearchItemResponseData> list = response.data ?? [];
      if (!Utils.isEmpty(list) && listItemOrderFixColor.length >= (pageIndex - 1) * _maxPage + list.length) {
        listItemOrderFixColor.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list);
      } else {
        if (_currentPage == 1) {
          listItemOrderFixColor = list;
        } else
          listItemOrderFixColor.addAll(list);
      }
      if (Utils.isEmpty(list))
        return EmptyDataState();
      else
        isScroll = true;
        listItemOrderFixColor.forEach((element) {
          if(element.name!.isNotEmpty){
            var itemCheck = Const.kColorForAlphaB.firstWhere((item) => item.keyText == element.name?.substring(0,1).toUpperCase());
            if(itemCheck != null){
              element.kColorFormatAlphaB = itemCheck.color;
              listItemOrder.add(element);
            }
          }
        });
        print(listItemOrder.length);
        return GetListOrderSuccess();
    }
    catch(e){
      print(e);
      return OrderFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  Future<void> updateCount() async {
    List<Map> listCount = await db.countProduct();
    countProductCart = listCount[0]['COUNT (code)'];
    print('updateCount: $countProductCart');
  }

}