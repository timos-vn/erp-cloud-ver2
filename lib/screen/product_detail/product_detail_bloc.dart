import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/product_detail/product_detail_event.dart';
import 'package:sse/screen/product_detail/product_detail_state.dart';
import 'package:sse/utils/const.dart';

import '../../model/network/response/product_detail_reponse.dart';
import '../../model/network/services/network_factory.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent,ProductDetailState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String get accessToken => _accessToken!;
  String? _refreshToken;
  String get refreshToken => _refreshToken!;
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  List<String> listImage = <String>[];

  List<ProducDetailReponseData> _listProductDetail = <ProducDetailReponseData>[];
  List<ProducDetailReponseData> get listProductDetail => _listProductDetail;


  ProductDetailBloc(this.context) : super(ProductDetailInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetProductDetailEvent>(_getProductDetailEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<ProductDetailState> emitter)async{
    emitter(ProductDetailInitial());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getProductDetailEvent(GetProductDetailEvent event, Emitter<ProductDetailState> emitter)async{
    emitter(ProductDetailLoading());
    ProductDetailState state = _handlerGetProductDetail(await _networkFactory!.getProductDetail(_accessToken!, event.itemCode, event.currency));
    emitter(state);
  }

  ProductDetailState _handlerGetProductDetail(Object data){
    if(data is String) return ProductDetailFailure('Có lỗi xảy ra'+ ": ${data.toString()}");
    try{
      ProducDetailReponse response = ProducDetailReponse.fromJson(data as Map<String,dynamic>);
      _listProductDetail = response.data!;
      if(_listProductDetail[0].imageUrl!.isNotEmpty){
        listImage.add(_listProductDetail[0].imageUrl.toString().split(';')[0].toString().trim());
      }
      return GetProductDetailSuccess();
    }catch(e){
      return ProductDetailFailure('Có lỗi xảy ra'+ ": ${e.toString()}");
    }
  }
}
