import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/screen/dms/shipping/shipping_bloc.dart';
import 'package:sse/screen/dms/shipping/shipping_event.dart';
import 'package:sse/screen/dms/shipping/shipping_state.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../model/network/response/list_shipping_reponse.dart';
import '../../../themes/colors.dart';
import '../../../utils/images.dart';
import '../../options_input/options_input_screen.dart';
import '../../widget/pending_action.dart';
import '../detail_shipping/detail_shipping_screen.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {

  late ShippingBloc _bloc;
  DateTime dateFrom = DateTime.now().add(Duration(days: -30));
  DateTime dateTo = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = ShippingBloc(context);
    _bloc.add(GetPrefsShippingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ShippingBloc,ShippingState>(
        listener: (context, state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetListShippingEvent(dateFrom: dateFrom,dateTo: dateTo));
          }
        },
        bloc: _bloc,
        child: BlocBuilder<ShippingBloc,ShippingState>(
          bloc: _bloc,
          builder: (BuildContext context, ShippingState state){
            return Stack(
              children: [
                buildBody(context, state),
                Visibility(
                  visible: state is GetListShippingEmpty,
                  child: Center(child: Text('Úi, Đại Vương dữ liệu trống',style: TextStyle(color: Colors.blueGrey),),),
                ),
                Visibility(
                  visible: state is ShippingLoading,
                  child: PendingAction(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,ShippingState state){
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
                _bloc.add(GetListShippingEvent(dateFrom: dateFrom,dateTo: dateTo));
              },
              child: Container(
                height: double.infinity,width: double.infinity,
                child: buildListShipping(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListShipping(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 55),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _bloc.listShipping.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailShippingScreen(sttRec: _bloc.listShipping[index].sttRec,)));
              },
              child: Card(
                elevation: 10,
                shadowColor: Colors.blueGrey.withOpacity(0.5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text('KH: ${_bloc.listShipping[index].tenKh?.trim()}', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                    Text(' (${_bloc.listShipping[index].maKh?.trim()})', style: TextStyle(color: Colors.grey,fontSize: 10),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(MdiIcons.locker,color: Colors.blueGrey,size: 12,),
                                    SizedBox(width: 3,),
                                    Text('Số CT: ${_bloc.listShipping[index].soCt?.trim()}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded,color: Colors.blueGrey,size: 12,),
                                    SizedBox(width: 3,),
                                    Text('Ngày:   ${Utils.parseStringDateToString(_bloc.listShipping[index].ngayCt.toString(), Const.DATE_SV, Const.DATE_FORMAT_1)}', style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.monetization_on_outlined,color: Colors.blueGrey,size: 12,),
                                    SizedBox(width: 3,),
                                    Text('Tổng thanh toán: ${Utils.formatMoney(_bloc.listShipping[index].tTtNt)} VNĐ', style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.navigate_next,color: Colors.grey,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
          Expanded(
            child: Center(
              child: Text(
                "Danh sách P.Giao Hàng",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            onTap: ()=>  showDialog(
                context: context,
                builder: (context) => OptionsFilterDate()).then((value){
              if(value != null){
                if(value[1] != null && value[2] != null){
                  _bloc.add(GetListShippingEvent(dateFrom: Utils.parseStringToDate(value[3], Const.DATE_SV_FORMAT),dateTo: Utils.parseStringToDate(value[4], Const.DATE_SV_FORMAT)));
                }else{
                  Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Hãy chọn từ ngày đến ngày');
                }
              }
            }),
            child: Container(
              width: 40,
              height: 50,
              child: Icon(
                Icons.calendar_today_rounded,
                size: 22,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

}
