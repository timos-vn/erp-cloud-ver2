import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/screen/menu/report/report_layout/report_bloc.dart';
import 'package:sse/screen/menu/report/report_layout/report_event.dart';
import 'package:sse/screen/menu/report/report_layout/report_sate.dart';
import 'package:sse/screen/widget/pending_action.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/utils.dart';

import '../../../../model/network/response/report_info_response.dart';
import '../../component/value_report_filter.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with TickerProviderStateMixin {

  late TabController tabController;
  late ReportBloc _reportBloc;
  bool show = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 0, vsync: this);
    _reportBloc = ReportBloc(context);
    _reportBloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<ReportBloc, ReportState>(
          bloc: _reportBloc,
          listener: (context, state) {
            if(state is GetPrefsSuccess){
              _reportBloc.add(GetListReports(isRefresh: true));
            }
            if (state is GetListReportSuccess) {
              tabController = TabController(vsync: this, length: _reportBloc.listTabViewReport.length);
              show = true;
            }
            if (state is GetListReportLayoutSuccess) {
              print(_reportBloc.listDataReportLayout.length);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ValueReportFilter(
                    listRPLayout: _reportBloc.listDataReportLayout,
                    idReport: state.idReport,
                    title: state.titleReport,
                  )));
            }
          },
          child: BlocBuilder<ReportBloc, ReportState>(
            bloc: _reportBloc,
            builder: (BuildContext context, ReportState state) {
              return Stack(
                children: [
                  buildBody(context, state),
                  Visibility(
                    visible: state is LoadingReport,
                    child: PendingAction(),
                  ),
                ],
              );
            },
          ),
        )
    );
  }

  buildAppBar(){
    return Container(
      height: 153,
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [subColor,Color.fromARGB(255, 150, 185, 229)])),
      padding: const EdgeInsets.fromLTRB(5, 35, 12,0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: ()=> Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Báo cáo tổng hợp",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                      maxLines: 1,overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
            ],
          ),
          Visibility(
            visible: show == true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Container(
                  padding: EdgeInsets.all(4),
                  height: 43,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(width: 0.8, color: white), borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: TabBar(
                    controller: tabController,
                    unselectedLabelColor: white,
                    labelColor: orange,
                    labelStyle: TextStyle(fontWeight: FontWeight.normal),
                    isScrollable: true,
                    // indicatorPadding: EdgeInsets.only(top: 6,bottom: 6,right: 8,left: 8),

                    indicator: BoxDecoration(color: white, borderRadius: BorderRadius.all(Radius.circular(12))),
                    tabs: List<Widget>.generate(_reportBloc.listTabViewReport.length, (int index) {
                      return new Tab(
                        text: _reportBloc.listTabViewReport[index].toString(),
                      );
                    }),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  buildBody(BuildContext context,ReportState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 2));
               // _bloc.add(GetListStageStatistic(unitId: widget.unitId,idStageStatistic:idStageStatistic.toString(),));
              },
              child: Container(
                height: double.infinity,width: double.infinity,
                child: TabBarView(
                    controller: tabController,
                    children: List<Widget>.generate(_reportBloc.listTabViewReport.length, (int index) {
                      for (int i = 0; i <= _reportBloc.listTabViewReport.length; i++) {
                        if (i == index) {
                          return buildPageReport(context, _reportBloc.listDetailDataReport, index);
                        }
                      }
                      return Text('');
                    })),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPageReport(BuildContext context,  List<DetailDataReport> detailDataReport, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _reportBloc.add(GetListReportLayout(detailDataReport[i].reportList![index].id.toString(),detailDataReport[i].reportList![index].name.toString()));
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      detailDataReport[i].reportList![index].iconUrl!.isNotEmpty ? CachedNetworkImage(
                        imageUrl: detailDataReport[i].reportList![index].iconUrl.toString(),
                        fit: BoxFit.fitHeight,
                        height: 40,
                        width: 40,
                      ) : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${detailDataReport[i].reportList![index].name.toString()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                              visible: !Utils.isEmpty(detailDataReport[i].reportList![index].desc.toString()) == true && detailDataReport[i].reportList![index].desc.toString() != 'null',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '${detailDataReport[i].reportList![index].desc.toString()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: grey,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(),
          itemCount: detailDataReport[i].reportList!.length),
    );
  }
}
