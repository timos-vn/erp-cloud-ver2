import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';

import '../../../model/network/request/confirm_shipping_request.dart';
import '../../../model/network/request/get_item_shipping_request.dart';
import '../../../model/network/response/get_item_detail_shipping_response.dart';
import '../../../model/network/services/network_factory.dart';
import 'detail_shipping_event.dart';
import 'detail_shipping_state.dart';

class DetailShippingBloc extends Bloc<DetailShippingEvent,DetailShippingState>{
  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  MasterDetailItemShipping? masterItem = MasterDetailItemShipping();
  List<DettailItemShipping> listItemDetailShipping = <DettailItemShipping>[];

  DetailShippingBloc(this.context) : super(DetailShippingInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetItemShippingEvent>(_getItemShippingEvent);
    on<ConfirmShippingEvent>(_confirmShippingEvent);
  }


  void _getPrefs(GetPrefs event, Emitter<DetailShippingState> emitter)async{
    emitter(DetailShippingInitial());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getItemShippingEvent(GetItemShippingEvent event, Emitter<DetailShippingState> emitter)async{
    emitter(DetailShippingLoading());
    GetItemShippingRequest request = GetItemShippingRequest(
      sttRec: event.sstRec,
    );
    DetailShippingState state = _handleGetListShipping(await _networkFactory!.getItemDetailShipping(request,_accessToken!));
    emitter(state);
  }

  void _confirmShippingEvent(ConfirmShippingEvent event, Emitter<DetailShippingState> emitter)async{
    emitter(DetailShippingLoading());
    List<DsLine> dsLine = <DsLine>[];
    listItemDetailShipping.forEach((element) {
      DsLine item = DsLine(
          sttRec:  event.sstRec,
          sttRec0: element.sttRec0,
          soLuong:  element.soLuongThucGiao
      );
      dsLine.add(item);
    });
    ConfirmShippingRequest request = ConfirmShippingRequest(
        dsLine: dsLine,
        typePayment: event.typePayment
    );
    // print(dsLine.length);
    DetailShippingState state = _handleConfirmShipping(await _networkFactory!.confirmDetailShipping(request,_accessToken!));
    emitter(state);
  }

  DetailShippingState _handleGetListShipping(Object data){
    if(data is String) return GetItemShippingFailure('Úi, Đại Vương ơi '+ ": ${data.toString()}");
    try{
      GetItemShippingResponse response = GetItemShippingResponse.fromJson(data as Map<String,dynamic>);
      listItemDetailShipping = response.data!.dettail!;
      masterItem = response.data?.master;
      if(listItemDetailShipping.isEmpty){
        return GetListShippingEmpty();
      }else{
        return GetItemShippingSuccess();
      }
    }catch(e){
      print(e.toString());
      return GetItemShippingFailure('Úi, Đại Vương ơi '+ ": ${e.toString()}");
    }
  }

  DetailShippingState _handleConfirmShipping(Object data){
    if(data is String) return GetItemShippingFailure('Úi, Đại Vương ơi '+ ": ${data.toString()}");
    try{
      return ConfirmShippingSuccess();
    }catch(e){
      print(e.toString());
      return GetItemShippingFailure('Úi, Đại Vương ơi '+ ": ${e.toString()}");
    }
  }
}