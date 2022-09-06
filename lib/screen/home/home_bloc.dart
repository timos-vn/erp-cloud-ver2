import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/database/database_models.dart';
import 'package:sse/model/network/request/report_data_request.dart';
import 'package:sse/model/network/response/bar_chart_response.dart';
import 'package:sse/model/network/response/data_default_response.dart';
import 'package:sse/model/network/response/pie_chart_response.dart';
import 'package:sse/model/network/response/table_chart_response.dart';
import 'package:sse/model/network/services/network_factory.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  BuildContext context;
  NetWorkFactory? _networkFactory;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  List colors = [Colors.indigo,Colors.lightGreen,Colors.purple,mainColor,Colors.red,
    Colors.blueAccent, Colors.blueGrey,Colors.teal,Colors.green,
    subColor,
  ];

  Random random = new Random();
  String? timeId;
  String? reportId;
  String? title;
  String? dataChartType;
  String? chartType;
  String? typeMoney;
  String? legend1;
  String? legend2;

  double tongDT=0;
  double tongCP=0;
  double totalProfit=0;
  double totalMNPieChart = 0;
  double totalPercentPieChart=0;

  List<ReportCategories> listReportCategories = <ReportCategories>[];
  ReportInfo? reportInfo;
  List<ReportData> listReportData = <ReportData>[];
  List<NumberFormatType> listNumberFormat = <NumberFormatType>[];
  List<PieChartReportResponseData> _listPieChart = <PieChartReportResponseData>[];
  List<HeaderData> listHeaderData = <HeaderData>[];

  List<ReportDataModels> valueCl1 = [];
  List<ReportDataModels> valueCl2  = [];
  List<DataPieChart> pieChart = [];

  List<Task> pieChart2 = [];

  List<dynamic> responseData = [];
  Map<String,dynamic> dataMap2 = new Map();
  List<Map<String,dynamic>> listValuesCells = [];


  HomeBloc(this.context) : super(InitialHomeState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs);
    on<GetDataDefault>(_getDataDefault);
    on<ChangeValueTime>(_changeValueTime);
    on<GetReportData>(_getReportData);
    on<SetStateEvent>(_setStateEvent);

  }

  void _getPrefs(GetPrefs event, Emitter<HomeState> emitter)async{
    emitter(InitialHomeState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _setStateEvent(SetStateEvent event, Emitter<HomeState> emitter)async{
    emitter(DoNotPermissionViewState());
  }

  void _changeValueTime(ChangeValueTime event,Emitter<HomeState> emitter){
    emitter(HomeLoading());
    timeId = event.timeId;
    emitter(ChangeTimeValueSuccess());
  }

  void _getReportData(GetReportData event,Emitter<HomeState> emitter)async{
    emitter(HomeLoading());
    ReportRequest request = ReportRequest(
        reportId: event.reportId,
        timeId: event.timeId,
        unitId: Const.unitId,
        storeId: Const.storeId,
        unitOfMeasure: '',
        reportType: ''
    );
    HomeState state = _handleGetData(await _networkFactory!.getData(request,_accessToken!));
    emitter(state);
  }

  void _getDataDefault(GetDataDefault event, Emitter<HomeState> emitter)async{
    emitter(HomeLoading());
    HomeState state = _handleGetDefaultData(await _networkFactory!.getDefaultData(_accessToken!));
    emitter(state);
  }

  HomeState _handleGetData(Object data){
    if (data is String) return HomeFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      dataChartType =null;
      title =null;chartType=null;
      DataDefaultResponse dataDefaultResponse = DataDefaultResponse.fromJson(data as Map<String,dynamic>);
      reportInfo = dataDefaultResponse.reportInfo!;

      timeId = reportInfo?.timeId;
      reportId = reportInfo?.reportId;
      title = reportInfo?.title;
      dataChartType = reportInfo?.dataType;
      chartType = reportInfo?.chartType;
      typeMoney = reportInfo?.subtitle;

      if(dataChartType == Const.CHART){
        if(chartType?.trim() == Const.BAR_CHART){
          print('This is Bar chart');
          legend1 = reportInfo?.legend1;
          legend2 = reportInfo?.legend2;
          tongCP = 0;tongDT  =0;
          valueCl1.clear();
          valueCl2.clear();
          BarChartDataResponse barChartDataResponse = BarChartDataResponse.fromJson(data);
          List<BarChartReportData>? _listBarChartReportData = barChartDataResponse.data;
          _listBarChartReportData?.forEach((element) {
            tongDT = (tongDT + element.value1!);
            tongCP = (tongCP + element.value2!);
            valueCl1.add(new ReportDataModels(element.colName.toString(), element.value1!));//'6', 4000000
            valueCl2.add(new ReportDataModels(element.colName.toString(), element.value2!));
          });
          totalProfit = tongDT - tongCP;
        }
        else if(chartType == Const.PIE_CHART){
          totalMNPieChart=0;
          totalPercentPieChart =0;
          print('This is Pie chart');
          pieChart.clear();
          PieChartDataResponse pieChartDataResponse = PieChartDataResponse.fromJson(data);
          _listPieChart = pieChartDataResponse.data!;
          _listPieChart.forEach((element) {
            totalMNPieChart = (totalMNPieChart + element.value!);
          });
          totalProfit = totalMNPieChart;
          for(int index = 0;index <= (_listPieChart.length - 1);index++){
            Color _colors = colors[Random().nextInt(1)];
            if(typeMoney?.trim() == '%'){
              double percent = (_listPieChart[index].value!/totalMNPieChart);
              if(index == _listPieChart.length-1){
                pieChart.add(DataPieChart(
                    title: _listPieChart[index].colName.toString(),
                    value: ((1 - totalPercentPieChart )*100),
                    color: _listPieChart.length <= 10 ? colors[index] : _colors
                ));
              }
              else{
                if(percent.toString().length >=4){
                  double newValues = double.parse(percent.toString().substring(0,4));
                  totalPercentPieChart += newValues;
                  double x = (newValues*100);
                  if(x.toString().length >=4)
                  {
                    x = double.parse((x.toString().substring(0,4)));
                  }
                  print('xxx:$x');
                  pieChart.add(DataPieChart(
                      title:_listPieChart[index].colName.toString(),
                      value:(x),
                      color: _listPieChart.length <= 10 ? colors[index] : _colors
                  ));
                }
                else{
                  print('xxx1:$percent');
                  pieChart.add(DataPieChart(
                      title:_listPieChart[index].colName.toString(),
                      value:(percent*100),
                      color: _listPieChart.length <= 10 ? colors[index] : _colors
                  ));
                  totalPercentPieChart += (percent);
                }
              }
            }
            else{
              pieChart.add(new DataPieChart(
                  title: _listPieChart[index].colName.toString(),
                  value:_listPieChart[index].value!,
                  color: _listPieChart.length <= 10 ? colors[index] : _colors));
            }
          }
        }
        else if(chartType == Const.LINE_CHART){
          print('This is Line chart');
        }
      }
      else if(dataChartType == Const.TABLE){
        print('This is Table data');
        TableChartResponse response = TableChartResponse.fromJson(data);
        listHeaderData = response.headerDesc!;
        Map<String, dynamic> jsonMap = new Map<String, dynamic>.from(data);
        responseData = jsonMap["reportData"];
        getDataPageList();
        return GetDefaultDataSuccess();
      }
      return GetDataSuccess();
    }
    catch(e){
      return HomeFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  HomeState _handleGetDefaultData(Object data){
    if (data is String) return HomeFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      DataDefaultResponse dataDefaultResponse = DataDefaultResponse.fromJson(data as Map<String,dynamic>);
      Const.stockList = dataDefaultResponse.stockList!;
      listReportCategories = dataDefaultResponse.reportCategories!;
      Const.currencyList = dataDefaultResponse.currencyList!;
      reportInfo = dataDefaultResponse.reportInfo!;
      listNumberFormat = dataDefaultResponse.numberFormat!;

      listNumberFormat.forEach((element) {
        if(element.name == 'quantity'){
          Const.quantityFormat = element.value!;
        }
        else if(element.name == 'quantity_nt'){
          Const.quantityNtFormat = element.value!;
        }
        else if(element.name == 'amount'){
          Const.amountFormat = element.value!;
        }
        else if(element.name == 'amount_nt'){
          Const.amountNtFormat = element.value!;
        }
        else if(element.name == 'rate'){
          Const.rateFormat = element.value!;
        }
      });

      timeId = reportInfo?.timeId;
      reportId = reportInfo?.reportId;
      title = reportInfo?.title;
      dataChartType = reportInfo?.dataType;
      chartType = reportInfo?.chartType;
      typeMoney = reportInfo?.subtitle;
      legend1 = reportInfo?.legend1;
      legend2 = reportInfo?.legend2;

      // _prefs.setStringList(Const.LIST_TIME_NAME, _listFilterTimeName);
      // _prefs.setStringList(Const.LIST_TIME_ID, _listFilterTimeId);
      print('-- save LIST TIME OK');
      // print(_prefs.getStringList(Const.LIST_TIME_NAME).length);
      if(dataChartType == Const.CHART){
        if(chartType == Const.BAR_CHART){
          print('This is Bar chart');
          BarChartDataResponse barChartDataResponse = BarChartDataResponse.fromJson(data);
          List<BarChartReportData>? _listBarChartReportData = barChartDataResponse.data;
          _listBarChartReportData?.forEach((element) {
            tongDT = (tongDT + element.value1!);
            tongCP = (tongCP + element.value2!);
            valueCl1.add(new ReportDataModels(element.colName.toString(), element.value1!));//'6', 4000000
            valueCl2.add(new ReportDataModels(element.colName.toString(), element.value2!));
          });
          totalProfit = tongDT - tongCP;
        }
        else if(chartType == Const.PIE_CHART){
          totalMNPieChart=0;
          totalPercentPieChart =0;
          print('This is Pie chart');
          pieChart.clear();
          PieChartDataResponse pieChartDataResponse = PieChartDataResponse.fromJson(data);
          _listPieChart = pieChartDataResponse.data!;
          _listPieChart.forEach((element) {
            totalMNPieChart = (totalMNPieChart + element.value!);
          });
          totalProfit = totalMNPieChart;
          for(int index = 0;index <= (_listPieChart.length - 1);index++){
            Color _colors = colors[Random().nextInt(1)];
            if(typeMoney?.trim() == '%'){
              double percent = (_listPieChart[index].value!/totalMNPieChart);
              if(index == _listPieChart.length-1){
                pieChart.add(DataPieChart(
                    title: _listPieChart[index].colName.toString(),
                    value: ((1 - totalPercentPieChart )*100),
                    color: _listPieChart.length <= 10 ? colors[index] : _colors
                ));
              }
              else{
                if(percent.toString().length >=4){
                  double newValues = double.parse(percent.toString().substring(0,4));
                  totalPercentPieChart += newValues;
                  double x = (newValues*100);
                  if(x.toString().length >=4)
                  {
                    x = double.parse((x.toString().substring(0,4)));
                  }
                  print('xxx:$x');
                  pieChart.add(DataPieChart(
                      title:_listPieChart[index].colName.toString(),
                      value:(x),
                      color: _listPieChart.length <= 10 ? colors[index] : _colors
                  ));
                }
                else{
                  print('xxx1:$percent');
                  pieChart.add(DataPieChart(
                      title:_listPieChart[index].colName.toString(),
                      value:(percent*100),
                      color: _listPieChart.length <= 10 ? colors[index] : _colors
                  ));
                  totalPercentPieChart += (percent);
                }
              }
            }
            else{
              pieChart.add(new DataPieChart(
                  title: _listPieChart[index].colName.toString(),
                  value:_listPieChart[index].value!,
                  color: _listPieChart.length <= 10 ? colors[index] : _colors));
            }
          }
        }
        else if(chartType == Const.LINE_CHART){
          print('This is Line chart');
        }
      }
      else if(dataChartType == Const.TABLE){
        print('This is Table data');
        TableChartResponse response = TableChartResponse.fromJson(data);
        listHeaderData = response.headerDesc!;
        Map<String, dynamic> jsonMap = new Map<String, dynamic>.from(data);
        responseData = jsonMap["reportData"];
        getDataPageList();
        return GetDefaultDataSuccess();
      }
      return GetDefaultDataSuccess();
    }
    catch(e){
      print(e.toString());
      return HomeFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
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
              final formatter = new NumberFormat(header.format??'#,##0');//### ##0,00 - ###,##0,00
              value = formatter.format(contentRow[name]);
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