import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../widget/pending_action.dart';
import 'detail_customer_event.dart';
import 'detail_customer_state.dart';
import 'detial_customer_bloc.dart';

class DetailInfoCustomerScreen extends StatefulWidget {
  final String? idCustomer;

  const DetailInfoCustomerScreen({Key? key, this.idCustomer}) : super(key: key);
  @override
  _DetailInfoCustomerScreenState createState() => _DetailInfoCustomerScreenState();
}

class _DetailInfoCustomerScreenState extends State<DetailInfoCustomerScreen> {

  late DetailCustomerBloc _bloc;

  List<Color> listColor = [Colors.blueAccent,Colors.lightGreen,Colors.pink,Colors.yellow];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailCustomerBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DetailCustomerBloc,DetailCustomerState>(
          bloc: _bloc,
          listener: (context,state){
            if(state is GetPrefsSuccess){
              _bloc.add(GetDetailCustomerEvent(widget.idCustomer.toString()));
            }
            if(state is DetailCustomerFailure){
              Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Có lỗi xảy ra.');
            }
            else if(state is GetDetailCustomerSuccess){

            }
          },
          child: BlocBuilder<DetailCustomerBloc,DetailCustomerState>(
            bloc: _bloc,
            builder: (BuildContext context, DetailCustomerState state){
              return Stack(
                children: [
                  buildBody(context, state),
                  Visibility(
                    visible: state is DetailCustomerLoading,
                    child: PendingAction(),
                  ),
                ],
              );
            },
          )
      ),
    );
  }

  buildBody(BuildContext context,DetailCustomerState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16,top: 10,bottom: 10,right: 16),
                  child: Container(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Text(_bloc.detailCustomer.customerName??'',style: TextStyle(color: blue,fontWeight: FontWeight.normal,fontSize: 18),)),
                            SizedBox(height: 8,),
                            Divider(
                              height: 1,
                              color: blue,
                            ),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Icon(Icons.phone,size: 13,color: grey,),
                                SizedBox(width: 8,),
                                Text(
                                  _bloc.detailCustomer.phone??'',
                                  style: TextStyle(fontSize: 13,color: grey,),
                                ),
                              ],
                            ),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                Icon(Icons.email,size: 13,color: grey,),
                                SizedBox(width: 8,),
                                Text(
                                  _bloc.detailCustomer.email??'....',
                                  style: TextStyle(fontSize: 13,color: grey,),
                                ),
                              ],
                            ),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                Icon(Icons.location_on,size: 13,color: grey,),
                                SizedBox(width: 8,),
                                Flexible(
                                  child: Text(
                                    _bloc.detailCustomer.address??'',
                                    style: TextStyle(fontSize: 13,color: grey,),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                Icon(FontAwesome5.birthday_cake,size: 13,color: grey,),
                                SizedBox(width: 8,),
                                Text(
                                  //Utils.parseStringToDate( _bloc.detailCustomer.birthday.toString(), Const.DATE_SV).toString().split(' ')[0]
                                  '${_bloc.detailCustomer.birthday}',
                                  // _bloc.detailCustomer?.birthday??'',
                                  style: TextStyle(fontSize: 13,color: grey,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 5,),
                listItem(context)
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
                "Thông tin khách hàng",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Container(
            width: 40,
            height: 50,
            child: Icon(
              Icons.event,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget listItem(BuildContext context){
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 0,left: 16,right: 16),
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                if(index == 0){
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterOrderPage()));
                }else if(index == 1){

                }else if(index == 2){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> ManagerCustomerPage()));
                }
              },
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: _bloc.listOtherData?[index].iconUrl?.isNotEmpty == true ? Colors.white : listColor[index],
                          ),
                          child: _bloc.listOtherData?[index].iconUrl?.isNotEmpty == true ?
                          CachedNetworkImage(
                            imageUrl: _bloc.listOtherData![index].iconUrl.toString(),
                            fit: BoxFit.fitHeight,
                            height: 40,
                            width: 40,
                            // width: MediaQuery.of(context).size.width,
                          ) :
                          Center(
                              child: Icon(Icons.library_books,size: 15,color: white,)
                          )
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          _bloc.listOtherData?[index].text??'',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),//_bloc.listOtherData[index]?.value.toString()??'0.0'
                      Center(child: Text(NumberFormat(_bloc.listOtherData?[index].formatString).format(_bloc.listOtherData?[index].value).toString(),style: TextStyle(fontWeight: FontWeight.normal,color: orange),)),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index)=> Container(),
          itemCount: _bloc.listOtherData!.length
      ),
    );
  }
}
