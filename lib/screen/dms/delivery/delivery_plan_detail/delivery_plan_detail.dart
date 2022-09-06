import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/model/network/response/delivery_plan_detail_response.dart';
import 'package:sse/screen/dms/delivery/delivery_plan/delivery_plan_bloc.dart';
import 'package:sse/screen/dms/delivery/delivery_plan/delivery_plan_event.dart';
import 'package:sse/screen/dms/delivery/delivery_plan/delivery_plan_state.dart';
import 'package:sse/screen/widget/custom_question.dart';
import 'package:sse/screen/widget/input_quantity_popup_order.dart';
import 'package:sse/screen/widget/pending_action.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';


class DeliveryPlanDetailScreen extends StatefulWidget {
  final String? sttRec;
  final String? soCt;
  final String? ngayCt;
  final String? ngayGiao;
  final String? maKH;
  final String? maVc;
  final String? nguoiGiao;

  const DeliveryPlanDetailScreen({Key? key,this.sttRec,this.soCt,this.ngayCt,this.ngayGiao,this.maKH,this.maVc,this.nguoiGiao}) : super(key: key);

  @override
  _DeliveryPlanDetailScreenState createState() => _DeliveryPlanDetailScreenState();
}

class _DeliveryPlanDetailScreenState extends State<DeliveryPlanDetailScreen> {
  late DeliveryPlanBloc _bloc;

  String dateFrom = DateTime.now().toString();
  String dateTo = DateTime.now().toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DeliveryPlanBloc(context);
    _bloc.add(GetPrefsDeliveryPlan());

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryPlanBloc,DeliveryPlanState>(
      bloc: _bloc,
      listener: (context,state){
        if(state is GetPrefsSuccess){
          _bloc.add(GetDetailDeliveryPlan(soCt: widget.sttRec,maVc: widget.maVc,maKH: widget.maKH,ngayGiao: widget.ngayGiao,nguoiGiao: widget.nguoiGiao));
        }
        else if(state is DeliveryPlanFailure){
          Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, ${state.error}');
        }else if(state is UpdateDeliveryPlanSuccess){
          Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeah, Cập nhật phiếu thành công');
        }else if(state is CreateDeliveryPlanSuccess){
          Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeah, Tạo phiếu thành công');
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<DeliveryPlanBloc,DeliveryPlanState>(
        bloc: _bloc,
        builder: (BuildContext context, DeliveryPlanState state){
          return Scaffold(
            floatingActionButton: Const.updateDeliveryPlan == true ? Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: FloatingActionButton(
                child: Icon(Icons.save_alt,color: Colors.white,),
                backgroundColor: subColor,
                onPressed: ()async{
                  if(!Utils.isEmpty( _bloc.listDetailDeliveryPlan)){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: CustomQuestionComponent(
                              showTwoButton: true,
                              iconData: Icons.warning_amber_outlined,
                              title: 'Bạn đang thực hiện Lưu phiếu!',
                              content: 'Lưu ý: Hãy xác nhận số liệu trên phiếu là chính xác',
                            ),
                          );
                        }).then((value)async{
                      if(value != null){
                        if(!Utils.isEmpty(value) && value == 'Yeah'){
                          _bloc.add(UpdatePlanDeliveryDraft(sttRec: widget.sttRec,listDelivery: _bloc.listDetailDeliveryPlan));
                        }
                      }
                    });
                  }else{
                    Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Đại Vương chưa cập nhật MVT nào vào phiếu kìa.');
                  }
                },
              ),
            ) : Container(),
            body: Stack(
              children: [
                buildBody(context,state),
                Visibility(
                  visible: state is GetListDeliveryPlanEmpty,
                  child: Center(
                    child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Visibility(
                  visible: state is DeliveryPlanLoading,
                  child: PendingAction(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  buildAppBar(){
    return Container(
      height: 83,
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
      child: Row(
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
          const SizedBox(width: 10,),
          Expanded(
            child: Center(
              child: Text(
                'Chi tiết phiếu',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),

          InkWell(
            onTap: (){
              if(!Utils.isEmpty( _bloc.listDetailDeliveryPlan)&& Const.updateDeliveryPlan == true){
                showDialog(
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: CustomQuestionComponent(
                          showTwoButton: true,
                          iconData: Icons.warning_amber_outlined,
                          title: 'Bạn đang thực hiện Tạo phiếu!',
                          content: 'Lưu ý: Hãy xác nhận số liệu trên phiếu là chính xác',
                        ),
                      );
                    }).then((value)async{
                  if(value != null){
                      if(!Utils.isEmpty(value) && value == 'Yeah'){
                        _bloc.add(CreatePlanDelivery(sttRec: widget.sttRec,listDelivery: _bloc.listDetailDeliveryPlan,soCt: widget.soCt,ngayCt: widget.ngayCt));
                      }
                  }
                });
              }else{
                Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Đại Vương chưa cập nhật MVT nào vào phiếu kìa.');
              }
            },
            child: Container(
              height: 45,
              width: 50,
              child: Icon(Icons.how_to_reg,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

  buildBody(BuildContext context,DeliveryPlanState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 2));
                _bloc.add(GetDetailDeliveryPlan(soCt: widget.sttRec,maVc: widget.maVc,maKH: widget.maKH,ngayGiao: widget.ngayGiao,nguoiGiao: widget.nguoiGiao));
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey.withOpacity(.1),
                padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 60),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _bloc.listDetailDeliveryPlan.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          if(Const.updateDeliveryPlan == true){
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return InputQuantityPopupOrder(
                                    quantity: _bloc.listDetailDeliveryPlan[index].slXtt!.toDouble(),
                                    listDvt: [],
                                    allowDvt: false,
                                  );
                                }).then((value){
                              if(!Utils.isEmpty(value)){
                                print(value);
                                _bloc.listDetailDeliveryPlan.forEach((element) {
                                  if(element.maVt?.trim() == _bloc.listDetailDeliveryPlan[index].maVt?.trim()){
                                    setState(() {
                                      _bloc.listDetailDeliveryPlan[index].slXtt = double.parse(value[0].toString());
                                    });
                                  }
                                });
                              }
                            });
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.blueGrey.withOpacity(0.5),
                          child: Container(
                            height: 225,width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.code,color: Colors.grey,size: 12,),
                                  SizedBox(width: 5,),
                                  Expanded(child: Text('${_bloc.listDetailDeliveryPlan[index].tenKh?.trim()??''}', style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                ],),
                                Expanded(child: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(Icons.drive_file_rename_outline,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Flexible(child: Text('(${_bloc.listDetailDeliveryPlan[index].maVt?.trim()??''}) ${_bloc.listDetailDeliveryPlan[index].tenVt.toString()}', style: TextStyle(color: Colors.black,fontSize: 12),maxLines: 1,overflow: TextOverflow.fade,)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(Icons.account_circle_outlined,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Flexible(child: Text('Nhân viên: ${_bloc.listDetailDeliveryPlan[index].tenNvvc?.trim() == 'null' ? '' : _bloc.listDetailDeliveryPlan[index].tenNvvc.toString().trim()}', style: TextStyle(color: Colors.black,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Flexible(child: Text('${_bloc.listDetailDeliveryPlan[index].diaChi != '' ? _bloc.listDetailDeliveryPlan[index].diaChi?.trim().toString() : 'Địa chỉ KH chưa được cập nhật'}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(Icons.local_shipping,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Flexible(child: Text('${_bloc.listDetailDeliveryPlan[index].tenVc.toString()}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.timer_sharp,color: Colors.grey,size: 12,),
                                            SizedBox(width: 5,),
                                            Text('Giờ có mặt: ${_bloc.listDetailDeliveryPlan[index].gioCoMat.toString()}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                                          ],
                                        ),
                                        Text((!Utils.isEmpty(_bloc.listDetailDeliveryPlan[index].ngayGiao.toString()) && _bloc.listDetailDeliveryPlan[index].ngayGiao != 'null') ? '${Utils.parseDateTToString(_bloc.listDetailDeliveryPlan[index].ngayGiao.toString(), Const.DATE_FORMAT_1)}':'', style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(Icons.fact_check,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Flexible(child: Text('Ghi chú: ${_bloc.listDetailDeliveryPlan[index].ghiChu.toString()}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Divider(height: 4,),
                                    buildValues(_bloc.listDetailDeliveryPlan[index])
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildValues(DeliveryPlanDetailResponseData item){
    final double width = MediaQuery.of(context).size.width;
    return Expanded(
      child: DataTable(
        headingRowHeight: 28,
        dividerThickness: 1.0,
        columnSpacing: 0,
        horizontalMargin: 0,
        columns: <DataColumn>[
          DataColumn(
            label: Container(
              width: width * .45,
              child: Center(
                child: Text(
                  'Số lượng theo kế hoạch',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
          DataColumn(
            label: VerticalDivider(),
          ),
          DataColumn(
            label: Container(
              width: width * .4,
              child: Center(
                child: Text(
                  'Số lượng thực tế',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Center(child: Text(item.slKh?.toInt().toString()??'',style: TextStyle(fontSize: 11,color: Colors.grey),))),
              DataCell(Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: VerticalDivider(),
              )),
              DataCell(Center(child: Text(item.slXtt?.toInt().toString()??'',style: TextStyle(fontSize: 11,color: Colors.grey),))),
            ],
          ),
        ],
      ),
    );
  }
}
