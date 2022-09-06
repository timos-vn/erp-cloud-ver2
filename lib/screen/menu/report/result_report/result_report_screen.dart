import 'package:sse/screen/menu/report/result_report/result_report_bloc.dart';
import 'package:sse/screen/menu/report/result_report/result_report_event.dart';
import 'package:sse/screen/menu/report/result_report/result_report_state.dart';
import 'package:sse/screen/widget/pending_action.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/utils.dart';
import '../../../../model/network/response/approval_detail_response.dart';

Map<String,dynamic> _dataMap = new Map();
List<Map<String,dynamic>> _listValuesCells = [];
List<Map<String,dynamic>> _paginatedDataSource = [];
int _rowsPerPage = 15;
class ResultReportScreen extends StatefulWidget {
  final String idReport;
  final List<dynamic> listRequestValue;
  final String title;

  const ResultReportScreen({Key? key, required this.idReport, required this.listRequestValue, required this.title}) : super(key: key);
  @override
  _ResultReportScreenState createState() => _ResultReportScreenState();
}

class _ResultReportScreenState extends State<ResultReportScreen> {
  late ResultReportBloc _resultReportBloc;
  /// table
  SelectionMode selectionMode = SelectionMode.single;
  DataGridController _dataGridController = DataGridController();
  final ColumnSizer _columnSizer = ColumnSizer();
  List<HeaderData> _listHeader = <HeaderData>[];
  late AutoRowHeightDataGridSource _autoRowHeightDataGridSource;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _resultReportBloc = ResultReportBloc(context);
    _resultReportBloc.add(GetPrefs());
    if(!Utils.isEmpty(_listValuesCells)){
      _listValuesCells.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: orange,
          centerTitle: true,
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            widget.title,
            style: TextStyle(
              color: white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocListener<ResultReportBloc, ResultReportState>(
            bloc: _resultReportBloc,
            listener: (context, state) {
              if(state is GetPrefsSuccess){
                _resultReportBloc.add(GetResultReportEvent(widget.idReport, widget.listRequestValue));
              }
              if (state is GetResultReportSuccess) {
                _listHeader = _resultReportBloc.listHeaderData;
                _dataMap = _resultReportBloc.dataMap2;
                _listValuesCells = _resultReportBloc.listValuesCells;
                _paginatedDataSource = _listValuesCells.getRange(0, ((_listValuesCells.length) >= 14 ? 14 : (_listValuesCells.length))).toList(growable: false);
                _autoRowHeightDataGridSource = AutoRowHeightDataGridSource(listHeader: _listHeader);
              }
              if (state is ResultReportFailure) {}
            },
            child: BlocBuilder<ResultReportBloc, ResultReportState>(
              bloc: _resultReportBloc,
              builder: (BuildContext context, ResultReportState state) {
                return buildPage(context, state);
              },
            )));
  }

  Widget buildPage(BuildContext context, ResultReportState state) {
    return Stack(
      children: [
        !Utils.isEmpty(_listValuesCells) ?
        Column(
      children: [
        Expanded(
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              brightness: SfTheme.of(context).brightness,
              gridLineStrokeWidth: 1.4,
              headerHoverColor: Color(0xFF9588D7).withOpacity(0.6),
              headerColor: mainColor,
            ),
            child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.auto,
                allowSorting: true,
                headerGridLinesVisibility: GridLinesVisibility.vertical,
                selectionMode: selectionMode,
                controller: _dataGridController,
                onCellTap: (index){},
                source: _autoRowHeightDataGridSource,
                columnSizer: _columnSizer,
                columns: List<GridColumn>.generate(_listHeader.length, (int index){
                  return  GridColumn(
                    label: Center(child: Text(_listHeader[index].name.toString().trim(),style: TextStyle(color: Colors.white),)),
                    columnName: _listHeader[index].field.toString().trim(),
                    maximumWidth: 250,
                    columnWidthMode: ColumnWidthMode.none,
                  );
                })
            ),
          ),
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
              color: SfTheme.of(context).dataPagerThemeData.backgroundColor,
              border: Border(
                  top: BorderSide(
                      width: .5,
                      color: Colors.grey),
                  bottom: BorderSide.none,
                  left: BorderSide.none,
                  right: BorderSide.none)),
          child: Align(alignment: Alignment.center, child: _getDataPager()),
        )
      ],
    )
            :
        Center(
          child:Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),),
        Visibility(
          visible: state is ResultLoadingReport,
          child: PendingAction(),
        ),
      ],
    );
  }

  Widget _getDataPager() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        brightness: Brightness.light,
        selectedItemColor: subColor,
      ),
      child: SfDataPager(
        delegate: _autoRowHeightDataGridSource,
        direction: Axis.horizontal,
        pageCount: (int.parse((_listValuesCells.length / _rowsPerPage).toString().split('.')[1]) > 5 ? (_listValuesCells.length / _rowsPerPage + 1) : _listValuesCells.length / _rowsPerPage ),
      ),
    );
  }
}

class AutoRowHeightDataGridSource extends DataGridSource {

  final List<HeaderData> listHeader;

  AutoRowHeightDataGridSource({required this.listHeader}) {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow>  dataGrid = [];

  @override
  List<DataGridRow> get rows => dataGrid;

  void buildPaginatedDataGridRows() {

    List<DataGridRow> listDataGridRow=[];

    _paginatedDataSource.forEach((element) {
      List<DataGridCell> listDataGridCell=[];
      listHeader.forEach((headerFiled) {
        DataGridCell dataGridCell = DataGridCell(
            columnName: headerFiled.field.toString(),
            value: element[headerFiled.field].toString().trim()
        );
        listDataGridCell.add(dataGridCell);
      });
      DataGridRow dataGridRow = DataGridRow(
          cells:  listDataGridCell
      );
      listDataGridRow.add(dataGridRow);
    });
    print(listDataGridRow.length);
    dataGrid = listDataGridRow;
  }

  int get rowCount => _listValuesCells.length;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int _startIndex = newPageIndex * _rowsPerPage;
    int _endIndex = _startIndex + _rowsPerPage;
    if (_endIndex > _paginatedDataSource.length) {
      _endIndex = _paginatedDataSource.length;
    }

    if((_startIndex + _rowsPerPage) > _listValuesCells.length){
      _rowsPerPage = _listValuesCells.length % _rowsPerPage;
    }else{
      _rowsPerPage = 15;
    }

    _paginatedDataSource = _listValuesCells
        .getRange(_startIndex, _startIndex + _rowsPerPage)
        .toList(growable: false);
    // notifyDataSourceListeners();
    buildPaginatedDataGridRows();
    notifyListeners();
    return Future<bool>.value(true);
  }
  @override

  bool shouldRecalculateColumnWidths() {
    return true;
  }
}