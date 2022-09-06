// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../model/database/data_local.dart';
import '../../../model/database/dbhelper.dart';
import '../../../model/entity/product.dart';
import '../../../model/network/request/discount_request.dart';
import '../../../model/network/request/search_list_item_request.dart';
import '../../../model/network/response/cart_response.dart';
import '../../../model/network/response/search_list_item_response.dart';
import '../../../model/network/response/update_order_reponse.dart';
import '../../../model/network/services/network_factory.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent,CartState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String get accessToken => _accessToken!;
  String? _refreshToken;
  String get refreshToken => _refreshToken!;
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  final db = DatabaseHelper();

  // List<SearchItemResponseData> listOrder = [];
  List<Product> listProductOrder = [];
  List<Product> listProductOrderAndUpdate = [];
  double? totalMNProduct = 0;
  double? totalMNDiscount = 0;
  double? totalMNVAT = 0;
  double? totalMNPayment = 0;
  bool isChecked = true;

  List<String>? listCodeDisCount = [];
  List<DsCk>? listDiscountName = [];

  List<Product> _lineItemOrder = <Product>[];
  List<Product> get lineItemOrder => _lineItemOrder;

  List<SearchItemResponseData> _searchResults = <SearchItemResponseData>[];
  List<SearchItemResponseData> get searchResults => _searchResults;

  int _currentPage = 1;
  int _maxPage = Const.MAX_COUNT_ITEM;
  int get maxPage => _maxPage;
  int get currentPage => _currentPage;

  String? _currentSearchText;
  bool isShowCancelButton = false;
  bool isScroll = true;

  Future<List<Product>> getListFromDb() {
    return db.fetchAllProduct();
  }


  void reset() {
    _currentSearchText = "";
    _currentPage = 1;
    _searchResults.clear();
  }

  CartBloc(this.context) : super(CartInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<TotalDiscountAndMoneyForAppEvent>(_totalDiscountAndMoneyForAppEvent);
    on<GetListItemUpdateOrderEvent>(_getListItemUpdateOrderEvent);
    on<CheckDisCountWhenUpdateEvent>(_checkDisCountWhenUpdateEvent);
    on<GetListProductFromDB>(_getListProductFromDB);
    on<DeleteProductFromDB>(_deleteProductFromDB);
    on<Decrement>(_decrement);
    on<Increment>(_increment);
    on<SearchProduct>(_searchProduct);
    on<CheckShowCloseEvent>(_checkShowCloseEvent);
    on<AddCartEvent>(_addCartEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<CartState> emitter)async{
    emitter(CartInitial());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListProductFromDB(GetListProductFromDB event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    listProductOrderAndUpdate  = await db.fetchAllProduct();
    emitter(GetListProductFromDBSuccess(true));
  }

  void _decrement(Decrement event, Emitter<CartState> emitter)async{
    emitter(CartInitial());
    if (listProductOrderAndUpdate.elementAt(event.index).count! >= 2) {
      await db.decreaseProduct(listProductOrderAndUpdate.elementAt(event.index));
    }
    listProductOrderAndUpdate  = await db.fetchAllProduct();
    emitter(GetListProductFromDBSuccess(false));
  }

  void _increment(Increment event, Emitter<CartState> emitter)async{
    emitter(CartInitial());
    await db.increaseProduct(listProductOrderAndUpdate.elementAt(event.index));
    listProductOrderAndUpdate  = await db.fetchAllProduct();
    emitter(GetListProductFromDBSuccess(false));
  }

  void _deleteProductFromDB(DeleteProductFromDB event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    if(event.viewUpdateOrder == false){
      listProductOrderAndUpdate.removeAt(event.index);
      db.removeProduct(event.itemProduct.code.toString());
      emitter(TotalMoneyForAppSuccess(true));
    }else {
      listProductOrderAndUpdate.removeAt(event.index);
      emitter(GetListItemUpdateOrderSuccess());
    }
  }

  void _totalDiscountAndMoneyForAppEvent(TotalDiscountAndMoneyForAppEvent event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    if(event.listProduct.length > 0){
      DiscountRequest requestBody = DiscountRequest(
          maKh: '',
          maKho: '',
          lineItem: event.listProduct
      );
      CartState state = _handleCalculator(await _networkFactory!.calculatorPayment(requestBody,_accessToken!),event.viewUpdateOrder,false,event.reCalculator);
      emitter(state);
    }
    else{
      totalMNProduct = 0;
      totalMNDiscount = 0;
      totalMNPayment = 0;
      emitter(CartInitial());
    }
  }

  void _getListItemUpdateOrderEvent(GetListItemUpdateOrderEvent event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    CartState state = _handleGetOrder(await _networkFactory!.getItemDetailOrder(_accessToken!,event.sttRec));
    emitter(state);
  }

  void _checkDisCountWhenUpdateEvent(CheckDisCountWhenUpdateEvent event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    DiscountRequest requestBody = DiscountRequest(
        sttRec: event.sttRec,
        maKh: event.codeCustomer,
        maKho: event.codeStore,
        lineItem: listProductOrderAndUpdate
    );
    CartState state = _handleCalculator(await _networkFactory!.getDiscountWhenUpdate(requestBody,_accessToken!),event.viewUpdateOrder,event.addNewItem,true);
    emitter(state);
  }

  CartState _handleCalculator(Object data, bool viewUpdateOrder,bool addNewItem,bool reCalculator){
    if (data is String) return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      if(listCodeDisCount?.isNotEmpty == true){
        listCodeDisCount?.clear();
      }
      CartResponse response = CartResponse.fromJson(data as Map<String,dynamic>);
      List<LineItem>? lineItem = response.data?.lineItem;
      listDiscountName = response.data?.order?.dsCk!;
      listDiscountName?.forEach((element) {
        if(listCodeDisCount?.length == 0){
          listCodeDisCount?.add(element.maCk.toString());
        }
        else {
          listCodeDisCount?.add(element.maCk.toString());
        }
      });
      if(viewUpdateOrder == false){
        for(int i = 0; i < lineItem!.length; i++){
          List<String> itemCodeDiscountInLine = [];
          if(listProductOrder.isNotEmpty){
            final valueItem = listProductOrder.firstWhere((item) => item.code ==  lineItem[i].maVt,);
            if (valueItem != null) {
              final indexWithStart =  listProductOrder.indexOf(valueItem);
              itemCodeDiscountInLine.clear();
              if(!Utils.isEmpty(lineItem[i].maCk.toString())){
                itemCodeDiscountInLine.add(lineItem[i].maCk.toString());
              }
              if(!Utils.isEmpty(lineItem[i].discountProductCode.toString())){
                itemCodeDiscountInLine.add(lineItem[i].discountProductCode.toString());
              }
              Product production = Product(
                  code: listProductOrder[indexWithStart].code,
                  name: listProductOrder[indexWithStart].name,
                  name2:listProductOrder[indexWithStart].name2,
                  dvt: listProductOrder[indexWithStart].dvt,
                  description: listProductOrder[indexWithStart].description,
                  price: listProductOrder[indexWithStart].price,
                  discountPercent: listProductOrder[indexWithStart].discountPercent,
                  priceAfter: listProductOrder[indexWithStart].priceAfter,
                  stockAmount: listProductOrder[indexWithStart].stockAmount,
                  taxPercent: listProductOrder[indexWithStart].taxPercent,
                  imageUrl: listProductOrder[indexWithStart].imageUrl,
                  count: listProductOrder[indexWithStart].count,
                  isMark:0,
                  discountMoney: lineItem[i].tenCk,
                  discountProduct: lineItem[i].discountProduct,
                  budgetForItem: lineItem[i].nganSach,
                  budgetForProduct: lineItem[i].nganSachSp,
                  residualValueProduct: lineItem[i].nganSachProduct,
                  residualValue: lineItem[i].residualValue,
                  unit: lineItem[i].unit,
                  unitProduct: lineItem[i].unitProduct,
                  dsCKLineItem: itemCodeDiscountInLine.join(',')
              );
              db.updateProduct(production);
            }
          }
        }
      }
      else{
        for(int i = 0; i < lineItem!.length; i++){
          List<String> itemCodeDiscountInLine = [];
          if(_lineItemOrder.isNotEmpty){
            final valueItem = _lineItemOrder.firstWhere((item) => item.code ==  lineItem[i].maVt,);
            if (valueItem != null) {
              final indexWithStart = _lineItemOrder.indexOf(valueItem);
              listProductOrderAndUpdate[indexWithStart].discountMoney = lineItem[i].tenCk;
              listProductOrderAndUpdate[indexWithStart].discountProduct = lineItem[i].discountProduct;
              listProductOrderAndUpdate[indexWithStart].budgetForItem = lineItem[i].nganSach;
              listProductOrderAndUpdate[indexWithStart].residualValueProduct = lineItem[i].nganSachProduct;
              listProductOrderAndUpdate[indexWithStart].residualValue = lineItem[i].residualValue;
              listProductOrderAndUpdate[indexWithStart].unit = lineItem[i].unit;
              listProductOrderAndUpdate[indexWithStart].budgetForProduct = lineItem[i].nganSachSp;
              listProductOrderAndUpdate[indexWithStart].unitProduct = lineItem[i].unitProduct;
              itemCodeDiscountInLine.clear();
              if(!Utils.isEmpty(lineItem[i].maCk.toString())){
                itemCodeDiscountInLine.add(lineItem[i].maCk.toString());
              }
              if(!Utils.isEmpty(lineItem[i].discountProductCode.toString())){
                itemCodeDiscountInLine.add(lineItem[i].discountProductCode.toString());
              }
              listProductOrderAndUpdate[indexWithStart].dsCKLineItem = itemCodeDiscountInLine.join(',');
            }
          }
        }
      }
      totalMNProduct = response.data?.order?.tTien;
      totalMNDiscount = response.data?.order?.ck;
      totalMNPayment = response.data?.order?.tTt;
      if(viewUpdateOrder == false && addNewItem == false){
        return TotalMoneyForAppSuccess(reCalculator);
      }else {
        return TotalMoneyUpdateOrderSuccess();
      }
    }catch(e){
      return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  CartState _handleGetOrder(Object data) {
    if (data is String) return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      UpdateOrderResponse response = UpdateOrderResponse.fromJson(data as Map<String,dynamic>);

      List<LineItems>? lineItem = response.data?.lineItems;
      lineItem?.forEach((element) {
        Product production = Product(
            code: element.maVt,
            name: element.tenVt,
            name2: element.name2,
            dvt: element.dvt,
            description: '',
            price: element.gia,
            discountPercent: element.discountPercent,
            priceAfter: element.priceAfter,
            stockAmount: element.stockAmount,
            imageUrl: element.imageUrl,
            count: element.soLuong,
            isMark:0,

        );
        _lineItemOrder.add(production);
      });
      listProductOrderAndUpdate = _lineItemOrder;
      return GetListItemUpdateOrderSuccess();
    } catch (e) {
      print(e.toString());
      return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  /// search production
  ///
  ///

  void _addCartEvent(AddCartEvent event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    await db.addProduct(event.productItem!);
    emitter(AddCartSuccess());
  }

  void _searchProduct(SearchProduct event, Emitter<CartState> emitter)async{
    emitter(CartInitial());
    bool isRefresh = event.isRefresh;
    bool isLoadMore = event.isLoadMore;
    String searchText = event.searchText;
    emitter((!isRefresh && !isLoadMore)
        ? CartLoading()
        : CartInitial());
    if (_currentSearchText != searchText) {
      _currentSearchText = searchText;
      _currentPage = 1;
      _searchResults.clear();
    }
    if (isRefresh) {
      for (int i = 1; i <= _currentPage; i++) {
        CartState state = await handleCallApi(searchText, i,event.idGroup,event.selected);
        if (!(state is SearchProductSuccess)) return;
      }
      return;
    }
    if (isLoadMore) {
      isScroll = false;
      _currentPage++;
    }
    if (event.searchText != null && event.searchText != '') {
      if (event.searchText.length > 0) {
        CartState state = await handleCallApi(searchText, _currentPage,event.idGroup,event.selected);
        emitter(state);
      } else {
        emitter(EmptySearchProductState());
      }
    } else {
      emitter(CartInitial());
      emitter(RequiredText());
    }
  }

  void _checkShowCloseEvent(CheckShowCloseEvent event, Emitter<CartState> emitter)async{
    emitter(CartLoading());
    isShowCancelButton = !Utils.isEmpty(event.text);
    emitter(CartInitial());
  }

  Future<CartState> handleCallApi(String searchText, int pageIndex,int idGroup,String selectedId) async {
    String input='';
    if(!Utils.isEmpty(selectedId) && selectedId != 'null'){
      input = selectedId;
    }
    SearchListItemRequest request = SearchListItemRequest(
        searchValue: searchText,
        pageIndex: pageIndex,
        currency: "VND",
        itemGroup: idGroup == 1 ? input:'',
        itemGroup2: idGroup == 2 ? input : '',
        itemGroup3: idGroup == 3 ? input: '',
        itemGroup4: idGroup == 4 ? input: '',
        itemGroup5: idGroup == 5 ? input: ''
    );
    CartState state = _handleSearch(await _networkFactory!.getItemListSearchOrder(request, _accessToken!),pageIndex);
    return state;
  }

  CartState _handleSearch(Object data,int pageIndex){
    if(data is String) return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      SearchListItemResponse response = SearchListItemResponse.fromJson(data as Map<String,dynamic>);
      _maxPage = 20;
      List<SearchItemResponseData> list = response.data ?? [];
      if (!Utils.isEmpty(list) && _searchResults.length >= (pageIndex - 1) * _maxPage + list.length) {
        _searchResults.replaceRange((pageIndex - 1) * maxPage, pageIndex * maxPage, list); /// delete list cũ -> add data mới vào list đó.
      } else {
        if (_currentPage == 1) {
          _searchResults = list;
        } else
          _searchResults.addAll(list);
      }
      if (_searchResults.length > 0) {
        isScroll = true;
        return SearchProductSuccess();
      } else {
        return EmptySearchProductState();
      }
    }
    catch(e){
      print(e);
      return CartFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }
}