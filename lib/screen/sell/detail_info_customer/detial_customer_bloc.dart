import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';

import '../../../model/network/response/detail_customer_response.dart';
import '../../../model/network/services/network_factory.dart';
import 'detail_customer_event.dart';
import 'detail_customer_state.dart';

class DetailCustomerBloc extends Bloc<DetailCustomerEvent,DetailCustomerState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String get accessToken => _accessToken!;
  String? _refreshToken;
  String get refreshToken => _refreshToken!;
  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  DetailCustomerResponseData detailCustomer = new DetailCustomerResponseData();
  List<OtherData>? listOtherData = <OtherData>[];


  DetailCustomerBloc(this.context) : super(DetailCustomerInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetDetailCustomerEvent>(_getDetailCustomerEvent);
  }


  void _getPrefs(GetPrefs event, Emitter<DetailCustomerState> emitter)async{
    emitter(DetailCustomerInitial());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getDetailCustomerEvent(GetDetailCustomerEvent event, Emitter<DetailCustomerState> emitter)async{
    emitter(DetailCustomerInitial());
    DetailCustomerState state = _handlerGetDetailCustomer(await _networkFactory!.getDetailCustomer(_accessToken!, event.idCustomer));
    emitter(state);
  }

  DetailCustomerState _handlerGetDetailCustomer(Object data){
    if(data is String) return DetailCustomerFailure('Có lỗi xảy ra' + ':${data.toString()}');
    try{
      DetailCustomerResponse response = DetailCustomerResponse.fromJson(data as Map<String,dynamic>);
      detailCustomer = response.data!;
      listOtherData = response.data?.otherData!;
      return GetDetailCustomerSuccess();
    }catch(e){
      print(e.toString());
      return DetailCustomerFailure('Có lỗi xảy ra' + ':${e.toString()}');
    }
  }
}