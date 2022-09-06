import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/sell/sell_bloc.dart';
import 'package:sse/screen/sell/sell_state.dart';
import 'package:sse/screen/widget/custom_slider.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../menu/support/support_center.dart';
import '../widget/custom_question.dart';
import '../widget/custom_upgrade.dart';
import 'component/history_order.dart';
import 'order/order_sceen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {

  late SellBloc _bloc;

  List<String> slider = [
    'https://images.unsplash.com/photo-1465408953385-7c4627c29435?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MzV8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/flagged/photo-1574876242429-3164fb8bf4bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1480455624313-e29b44bbfde1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1483118714900-540cf339fd46?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = SellBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.0),
      body: BlocListener<SellBloc,SellState>(
        bloc: _bloc,
        listener: (context,state){

        },
        child: BlocBuilder<SellBloc,SellState>(
          bloc: _bloc,
          builder: (BuildContext context, SellState state){
            return buildBody(context,state);
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,SellState state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // buildAppBar(),
        buildSlider(),
        Padding(
          padding: const EdgeInsets.only(left: 16,top: 25,bottom: 10),
          child: Text('Danh mục menu'.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: (){
                  if(Const.createNewOrder == true){
                    pushNewScreen(context, screen: OrderScreen(),withNavBar: true);
                  }else{
                    Utils.showUpgradeAccount(context);
                  }
                },
                child: buildButton('Tạo đơn hàng mới',MdiIcons.cartOutline, Const.createNewOrder == true ? false : true),
              ),
              GestureDetector(
                onTap: (){
                  if(Const.historyOrder == true){
                    pushNewScreen(context, screen: HistoryOrderScreen(),withNavBar: true);
                  }else{
                    Utils.showUpgradeAccount(context);
                  }
                },
                child: buildButton('Lịch sử đặt hàng',MdiIcons.history, Const.historyOrder == true ? false : true),
              ),
              GestureDetector(
                onTap: (){
                  if(Const.production == true){
                    pushNewScreen(context, screen: HistoryOrderScreen(),withNavBar: true);
                  }else{
                    Utils.showUpgradeAccount(context);
                  }
                },
                child: buildButton('Thông tin sản phẩm',MdiIcons.professionalHexagon,Const.production == true ? false : true),
              ),
              GestureDetector(
                onTap: (){
                  if(Const.customer == true){
                    pushNewScreen(context, screen: HistoryOrderScreen(),withNavBar: true);
                  }else{
                    Utils.showUpgradeAccount(context);
                  }
                },
                child:  buildButton('Thông tin khách hàng',Icons.account_box_outlined, Const.customer == true? false : true),
              ),
            ],
          ),
        )
      ],
    );
  }

  buildAppBar(){
    return Container(
      height: 90,
      width: double.infinity,
      // decoration: BoxDecoration(
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.grey.shade200,
      //           offset: Offset(2, 4),
      //           blurRadius: 5,
      //           spreadRadius: 2)
      //     ],
      //     gradient: LinearGradient(
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //         colors: [Color(0xcdef9f25), Color.fromARGB(255, 226, 182, 97)])),
      padding: const EdgeInsets.fromLTRB(16, 38, 16,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: InkWell(
                          onTap: (){
                            // Utils.pushAndRemoveUtilKeepFirstPage(context, InfoCompanyPage(
                            //   username:  _mainBloc.userName,
                            //   listInfoUnitsID: _mainBloc.listInfoUnitsID,
                            //   listInfoUnitsName: _mainBloc.listInfoUnitsName,
                            //   currentCompanyName: _mainBloc.currentCompanyName,
                            //   currentCompanyID: _mainBloc.currentCompanyID,
                            //   getDF: true,
                            // ));
                          },
                          child: Text(
                            Const.companyName != '' ? Const.companyName : "Công ty ABC - Demo Công ty ABC - Demo Công ty ABC - Demo".toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black,),
                            maxLines: 1,overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  Const.storeName != '' ? Const.storeName : Const.unitName,
                  style: TextStyle(fontSize: 11,color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            //onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NotificationPage())),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: <Widget>[
                  Icon(
                    MdiIcons.bellOutline,
                    size: 25,
                    color: Colors.red,
                  ),
                  // Visibility(
                  //   visible: !Utils.isEmpty(_mainBloc.countNotifyUnRead)
                  //       &&
                  //       _mainBloc.countNotifyUnRead > 0
                  //   ,
                  //   child: Positioned(
                  //     top: -7,
                  //     right: -5,
                  //     child: Container(
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.all(2),
                  //       decoration: BoxDecoration(
                  //         color: blue,
                  //         borderRadius: BorderRadius.circular(9),
                  //       ),
                  //       constraints: BoxConstraints(
                  //         minWidth: 17,
                  //         minHeight: 17,
                  //       ),
                  //       child: Text(
                  //         !Utils.isEmpty(_mainBloc.countNotifyUnRead)
                  //             &&
                  //             _mainBloc.countNotifyUnRead > 0
                  //             ? _mainBloc.countNotifyUnRead.toString()
                  //             : "",
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 10,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildSlider(){
    return Container(
      height: 200,
      width: double.infinity,
      child: slider.isEmpty ? Container() : CustomCarousel(items: slider,),
    );
  }

  buildTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2)
        ),
        padding: const EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title,style: TextStyle(color: subColor,fontSize: 13),)),
      ),
    );
  }

  buildButton(String title, IconData icons,bool lock){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Container(
          height: 65,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  //color: Colors.white.withOpacity(0.95),
                ),
                child: Center(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                      ),
                      child: Icon(icons,size: 22,color: lock == false ? subColor : Colors.grey,)),
                ),
              ),
              Container(height: 25,width: 1,color: lock == false ? Colors.blueGrey : Colors.grey,),
              const SizedBox(width: 16,),
              Expanded(
                child: Text(title,style: TextStyle(color:lock == false ? subColor : Colors.grey,fontWeight: FontWeight.bold),),
              ),
              lock == false ? Icon(Icons.navigate_next,color: Colors.blueGrey,) : Icon(Icons.lock,color: Colors.grey,),
              const SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
