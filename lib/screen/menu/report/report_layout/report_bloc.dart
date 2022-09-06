import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/menu/report/report_layout/report_event.dart';
import 'package:sse/screen/menu/report/report_layout/report_sate.dart';
import 'package:sse/utils/const.dart';

import '../../../../model/network/response/report_info_response.dart';
import '../../../../model/network/response/report_layout_response.dart';
import '../../../../model/network/services/network_factory.dart';

class ReportBloc extends Bloc<ReportEvent,ReportState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  List<DetailDataReport> _listDetailDataReport = <DetailDataReport>[];
  List<DetailDataReport> get listDetailDataReport => _listDetailDataReport;
  List<String> listTabViewReport = [];
  List<DataReportLayout> listDataReportLayout = <DataReportLayout>[];


  ReportBloc(this.context) : super(ReportInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetListReports>(_getListReports);
    on<GetListReportLayout>(_getListReportLayout);

  }

  void _getPrefs(GetPrefs event, Emitter<ReportState> emitter)async{
    emitter(ReportInitial());
    _pref = await SharedPreferences.getInstance();
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListReports(GetListReports event, Emitter<ReportState> emitter)async{
    emitter(event.isRefresh ? ReportInitial() : LoadingReport());
    ReportState state = _handleGetListReports(await _networkFactory!.getListReports(_accessToken!));
    emitter(state);
  }

  void _getListReportLayout(GetListReportLayout event, Emitter<ReportState> emitter)async{
    emitter(LoadingReport());
    ReportState state = _handleGetListReportLayout(await _networkFactory!.getListReportLayout(_accessToken!, event.reportId),event.reportId,event.reportTitle);
    emitter(state);
  }

  ReportState _handleGetListReports(Object data){
    if (data is String) return ReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      GetListReportsResponse response = GetListReportsResponse.fromJson(data as Map<String,dynamic>);
      _listDetailDataReport = response.reportData!;
      _listDetailDataReport.forEach((element) {
        listTabViewReport.add(element.name!);
      });
      return GetListReportSuccess();
    }
    catch(e){
      return ReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  ReportState _handleGetListReportLayout(Object data,String idReport,String titleReport){
    if (data is String) return ReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      ReportLayoutResponse response = ReportLayoutResponse.fromJson(data as Map<String,dynamic>);
      listDataReportLayout = response.reportLayoutData!;
      return GetListReportLayoutSuccess(idReport,titleReport);
    }
    catch(e){
      print(e.toString());
      return ReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }
}
