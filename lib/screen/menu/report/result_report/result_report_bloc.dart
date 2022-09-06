import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/menu/report/result_report/result_report_event.dart';
import 'package:sse/screen/menu/report/result_report/result_report_state.dart';
import 'package:sse/utils/const.dart';
import 'package:intl/intl.dart';

import '../../../../model/network/request/result_report_request.dart';
import '../../../../model/network/response/approval_detail_response.dart';
import '../../../../model/network/services/network_factory.dart';

class ResultReportBloc extends Bloc<ResultReportEvent, ResultReportState> {
  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  List<String> dataInsideHeader = [];
  List<String> dataInsideColFist = [];
  List<HeaderData> listHeaderData = <HeaderData>[];
  List<List<String>> output = [];
  List<Map<String,dynamic>> listValuesCells = [];
  List<dynamic> responseData = [];
  Map<String,dynamic> dataMap2 = new Map();
  int page = 1;
  int totalPage = 0;


  ResultReportBloc(this.context) : super(ResultReportInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetResultReportEvent>(_getResultReportEvent);
    on<NextPageResultReportEvent>(_nextPageResultReportEvent);
    on<PrevPageResultReportEvent>(_prevPageResultReportEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<ResultReportState> emitter)async{
    emitter(ResultReportInitial());
    _pref = await SharedPreferences.getInstance();
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getResultReportEvent(GetResultReportEvent event, Emitter<ResultReportState> emitter)async{
    emitter(ResultLoadingReport());
    ResultReportRequest request = ResultReportRequest(
        reportId: event.idReport,
        values:event.listRequest
    );
    ResultReportState state = _handleLoadListResult(await _networkFactory!.getResultReport(request, _accessToken!));
    emitter(state);
  }

  void _nextPageResultReportEvent(NextPageResultReportEvent event, Emitter<ResultReportState> emitter)async{
    emitter(ResultLoadingReport());
    if (page < totalPage) {
      page++;
      await getDataPageList();
    }
    emitter(NextPageResultReportSuccess());
  }

  void _prevPageResultReportEvent(PrevPageResultReportEvent event, Emitter<ResultReportState> emitter)async{
    emitter(ResultLoadingReport());
    if (page > 1) {
      page--;
      await getDataPageList();
    }
    emitter(PrevPageResultReportSuccess());
  }

  ResultReportState _handleLoadListResult(Object data) {
    if (data is String) return ResultReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      ResultReportResponse response = ResultReportResponse.fromJson(data as Map<String,dynamic>);
      listHeaderData = response.headerDesc!;
      Map<String, dynamic> jsonMap = new Map<String, dynamic>.from(data);
      responseData = jsonMap["values"];
      getDataPageList();
      return GetResultReportSuccess();
    } catch (e) {
      print(e);
      return ResultReportFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  Future<void> getDataPageList() async {
    int round = 0;
    responseData.forEach((contentRow) {
      Map<String,dynamic> dataMap = new Map();
      round++;
      listHeaderData.forEach((header) {
        for (final name in contentRow.keys){
          if (header.field.toString() == name){
            var value;
            if(header.type == 2){
              print(contentRow[name]);
              final formatter = new NumberFormat(header.format??'#,##0');//### ##0,00 - ###,##0,00
              if(contentRow[name] == null || contentRow[name] == 'null' || contentRow[name].toString().isEmpty){
                value = 0;
              }else {
                value = formatter.format(contentRow[name]);
              }
            }else if(header.type == 3){
              DateTime x = DateTime.parse(contentRow[name].toString());
              value =DateFormat("dd/MM/yyyy").format(x);
            } else{
              value = contentRow[name];
            }
            dataMap.putIfAbsent(name, () => value);
            if(round == 1){
              dataMap2.putIfAbsent(name, () => value);
            }
          }
        }
      });
      listValuesCells.add(dataMap);
    });
  }
}