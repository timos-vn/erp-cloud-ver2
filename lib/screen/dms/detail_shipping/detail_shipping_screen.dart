import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/screen/dms/detail_shipping/detail_shipping_state.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../model/network/response/get_item_detail_shipping_response.dart';
import '../../../utils/images.dart';
import '../../widget/confirm_type_payment.dart';
import '../../widget/input_quantity_shipping_popup.dart';
import '../../widget/pending_action.dart';
import 'detail_shipping_bloc.dart';
import 'detail_shipping_event.dart';

class DetailShippingScreen extends StatefulWidget {
  final String? sttRec;
  final String? nameCustomer;
  const DetailShippingScreen({Key? key,this.sttRec,this.nameCustomer}) : super(key: key);

  @override
  _DetailShippingScreenState createState() => _DetailShippingScreenState();
}

class _DetailShippingScreenState extends State<DetailShippingScreen> {

  late DetailShippingBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailShippingBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed:() {
            showDialog(
                context: context,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: ConfirmTypePayment(
                      title: 'Xác nhận phiếu giao vận!',
                      content: 'Vui lòng chọn hình thức thanh toán',
                      type: 0,
                    ),
                  );
                }).then((value) {
                  print(value);
              if(!Utils.isEmpty(value) && value[0] == 'confirm'){
                int typePayment = 0;
                if(value[1] == true){
                  typePayment = 1;
                }else if(value[2] == true){
                  typePayment = 2;
                }
                _bloc.add(ConfirmShippingEvent(
                    sstRec:  _bloc.masterItem?.sttRec,
                    typePayment: typePayment
                ));
              }
            });
          } ,
          backgroundColor: subColor,
          tooltip: 'Increment',
          child: Icon(Icons.check,color: Colors.white,),
        ),
      ),
      body: BlocListener<DetailShippingBloc, DetailShippingState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetItemShippingEvent(widget.sttRec.toString()));
          }
          else if(state is ConfirmShippingSuccess){
            Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeah, Xác nhận thành công');
          }
        },
        child: BlocBuilder<DetailShippingBloc, DetailShippingState>(
          bloc: _bloc,
          builder: (BuildContext context,DetailShippingState state){
            return Stack(
              children: [
                buildBody(context, state),
                Visibility(
                  visible: state is GetListShippingEmpty,
                  child: Center(
                    child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Visibility(
                  visible: state is DetailShippingLoading,
                  child: PendingAction(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,DetailShippingState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Container(
                          height: 35,
                          child: Center(child: Text(' Tổng số lượng ')),
                        ),
                        Container(
                          height: 35,
                          child:Center(child: Text('${_bloc.masterItem?.tSoLuong?.toInt()} SP',style: TextStyle(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)) ,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(
                          height: 35,
                          child: Center(child: Text(' Tổng thanh toán ')),
                        ),
                        Container(
                          height: 35,
                          child:Center(child: Text('${Utils.formatMoney(_bloc.masterItem?.tTtNt??0).toString()} VNĐ',style: TextStyle(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)) ,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Text('Danh sách chi tiết',style: TextStyle(color:Colors.blueGrey,fontSize: 12),),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      // controller: _scrollController,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (BuildContext context, int index)=>Container(),
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                            onTap: (){
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return InputQuantityShipping(quantity: _bloc.listItemDetailShipping[index].soLuong?.toInt() ,title: 'Vui lòng nhập số lượng thay đổi',desc: 'Nếu số lượng không thay đổi thì bạn không cần sửa.',);
                                  }).then((quantity){
                                if(quantity != null){
                                  _bloc.listItemDetailShipping.forEach((element) {
                                    if(element.sttRec0.toString().trim() == _bloc.listItemDetailShipping[index].sttRec0.toString().trim()){
                                      setState(() {
                                        _bloc.listItemDetailShipping[index].soLuongThucGiao = double.parse(quantity);
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            child: buildItem(_bloc.listItemDetailShipping[index]));
                      },
                      itemCount: _bloc.listItemDetailShipping.length //length == 0 ? length : _hasReachedMax ? length : length + 1,
                  ),
                ),
                const SizedBox(height: 55,)
              ],
            ),
          )
        ],
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
          Expanded(
            child: Center(
              child: Text(
                "${_bloc.masterItem?.tenKh?.toString()??'Chi tiết phiếu'}",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 50,
            child: Icon(
              Icons.how_to_reg,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(DettailItemShipping item){
    return Padding(
      padding: const EdgeInsets.only(bottom: 6,top: 0,left: 10,right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          // color: subColor.withOpacity(0.2),
          padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
          width: double.infinity,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(36), // Image radius
                  child: CachedNetworkImage(
                    imageUrl: img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.tenVt??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 5,),
                    Text('Số lượng: ${item.soLuong?.toInt()} ${item.dvt}',style: TextStyle(color: Colors.blueGrey,fontSize: 11),),
                    SizedBox(height: 5,),
                    Text('Số thực giao: ${item.soLuongThucGiao?.toInt()} ${item.dvt}',style: TextStyle(color: Colors.blueGrey,fontSize: 11),),
                    SizedBox(height: 5,),
                    Text('Tổng thanh toán: ${Utils.formatMoney(item.tienNt2)} VNĐ',style: TextStyle(color: Colors.blueGrey,fontSize: 11),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
