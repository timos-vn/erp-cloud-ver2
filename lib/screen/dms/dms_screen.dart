import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/dms/shipping/shipping_screen.dart';

import '../../themes/colors.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'check_in/check_in_screen.dart';
import 'delivery/delivery_plan/delivery_plan_screen.dart';
import 'dms_bloc.dart';
import 'dms_state.dart';

class DMSScreen extends StatefulWidget {
  const DMSScreen({Key? key}) : super(key: key);

  @override
  _DMSScreenState createState() => _DMSScreenState();
}

class _DMSScreenState extends State<DMSScreen> {

  late DMSBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DMSBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DMSBloc,DMSState>(
        bloc: _bloc,
        listener: (context,state){

        },
        child: BlocBuilder<DMSBloc,DMSState>(
          bloc: _bloc,
          builder: (BuildContext context, DMSState state){
            return buildBody(context,state);
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,DMSState state){
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildTitle('Check-in'),
                InkWell(
                  onTap: (){
                    if(Const.checkIn == true){
                        pushNewScreen(context, screen: CheckInScreen(),withNavBar: false);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Check-in khách hàng',MdiIcons.tableAccount,Const.checkIn == true? false : true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Sale out'),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Các điểm bán (Kho KH)',Icons.store, true),
                ),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Trạng thái đơn hàng đã đặt',Icons.local_grocery_store_outlined, true),
                ),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Nhập tồn',MdiIcons.fileCabinet, true),
                ),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Báo cáo KPI',MdiIcons.chartBar, true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Khách hàng'),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Đề xuất mở điểm',MdiIcons.garageOpenVariant, true),
                ),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Thông tin Khách hàng',Icons.account_box_outlined, true),
                ),
                InkWell(
                  onTap: (){
                    // if(Const.checkIn == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Ticket',MdiIcons.calendarTextOutline, true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Giao vận'),
                InkWell(
                  onTap: (){
                    if(Const.deliveryPlan == true){
                      pushNewScreen(context, screen: DeliveryPlanScreen(),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Kế hoạch giao hàng',Icons.plagiarism_outlined, Const.deliveryPlan == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.shippingProduct == true){
                      pushNewScreen(context, screen: ShippingScreen(),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Giao hàng',MdiIcons.truckFast, Const.shippingProduct == true? false : true),
                ),
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
      padding: const EdgeInsets.fromLTRB(16, 35, 16,0),
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
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
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
                  style: TextStyle(fontSize: 11,color: Colors.white),
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
                    color: Colors.white,
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

  buildButton(String title, IconData icons, bool lock){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      child: Row(
        children: [
          Center(
            child: Icon(icons,size: 24,color: lock == false ? subColor : Colors.grey,),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(title,style: TextStyle(color:  lock == false ? Colors.black : Colors.grey,fontWeight: FontWeight.normal),),
          ),
          lock == false ? Icon(Icons.navigate_next) : Icon(Icons.lock,color: Colors.grey,),
        ],
      ),
    );
  }
}
