import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/login/login_screen.dart';
import 'package:sse/screen/dms/delivery/delivery_plan/delivery_plan_screen.dart';
import 'package:sse/screen/menu/report/report_layout/report_screen.dart';
import 'package:sse/screen/menu/setting/about_sse_company.dart';
import 'package:sse/screen/menu/stage/stage_statistic/stage_statistic_screen.dart';
import 'package:sse/screen/menu/support/help_center.dart';
import 'package:sse/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/colors.dart';
import '../../utils/utils.dart';
import '../widget/custom_profile.dart';
import '../widget/custom_question.dart';
import '../widget/register_use.dart';
import 'approval/approval/approval_screen.dart';
import 'support/support_center.dart';
import 'setting/profile.dart';
import 'menu_bloc.dart';
import 'menu_state.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin  {

  late MenuBloc _bloc;

  late Animation<double> fadeAnimation;
  late AnimationController fadeController;
  late Animation<double> editAnimation;
  late AnimationController editController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = MenuBloc(context);
    editController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    editAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: editController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );
    fadeController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: fadeController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        )));

    fadeController.forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MenuBloc,MenuState>(
        bloc: _bloc,
        listener: (context,state){

        },
        child: BlocBuilder<MenuBloc,MenuState>(
          bloc: _bloc,
          builder: (BuildContext context, MenuState state){
            return buildBody(context,state);
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,MenuState state){
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        children: [
          buildAppBar(),
          Divider(height: 1,),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildTitle('Báo cáo'),
                InkWell(
                  onTap: (){
                    if(Const.report == true){
                      pushNewScreen(context, screen: ReportScreen(),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Báo cáo tổng hợp',MdiIcons.chartBar, Const.report == true? false : true),
                ),

                const SizedBox(height: 10,),
                buildTitle('Duyệt phiếu'),
                InkWell(
                  onTap: (){
                    if(Const.approval == true){
                      pushNewScreen(context, screen: ApprovalScreen(),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Duyệt phiếu tổng hợp',MdiIcons.calendarCheckOutline, Const.approval == true? false : true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Sản xuất'),
                InkWell(
                  onTap: (){
                    if(Const.stageStatistic == true){
                      pushNewScreen(context, screen: StageStatisticScreen(unitId: Const.unitId,),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Thống kê công đoạn',MdiIcons.widgets, Const.stageStatistic == true? false : true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Cài đặt & Phản hồi dịch vụ'),
                InkWell(
                  onTap: ()=> pushNewScreen(context, screen: const ProfileScreen(),withNavBar: false),
                  child:  buildButton('Cài đặt',Icons.settings_outlined,false),
                ),
                InkWell(
                  onTap: ()=> pushNewScreen(context, screen: const SupportCenterScreen(),withNavBar: false),
                  child:  buildButton('Hỗ trợ',MdiIcons.headset,false),
                ),
                InkWell(
                  onTap: ()=> pushNewScreen(context, screen: const HelpCenterScreen(),withNavBar: false),
                  child:  buildButton('Trung tâm trợ giúp',Icons.help_outline,false),
                ),
                InkWell(
                  onTap: ()async{
                    const url = 'https://sse.net.vn/dich-vu/dich-vu/chinh-sach-bao-hanh.html';
                    if(await canLaunch(url)){
                      await launch(url);
                    }else {
                      throw 'Could not launch $url';
                    }
                  },
                  child:  buildButton('Chính sách bảo hành',Icons.description,false),
                ),
                const SizedBox(height: 2,),
                InkWell(
                  onTap: ()async{
                    pushNewScreen(context, screen: AboutSSECompanyScreen(),withNavBar: false);
                  },
                  child: buildButton('About SSE Company',MdiIcons.tie,false),
                ),
                const SizedBox(height: 6,),
                Container(
                    height: 6,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14,top: 15),
                  child: Text('Phiên bản: ${Const.versionApp}',style: const TextStyle(color: Colors.grey,fontSize: 13),),
                ),
                buildButtonLogOut(),
                const SizedBox(height: 20,)
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
          lock == false ? Icon(Icons.navigate_next,color: Colors.blueGrey,) : Icon(Icons.lock,color: Colors.grey,),
        ],
      ),
    );
  }

  buildButtonLogOut(){
    return Padding(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 22,bottom: 50),
      child: GestureDetector(
        onTap: (){
          showDialog(
              context: context,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: CustomQuestionComponent(
                    showTwoButton: true,
                    iconData: Icons.warning_amber_outlined,
                    title: 'Bạn sẽ đăng xuất khỏi ứng dụng?',
                    content: 'Hãy chắc chắn bạn muốn điều này xảy ra.',
                  ),
                );
              }).then((value)async{
            if(value != null){
              if(!Utils.isEmpty(value) && value == 'Yeah'){
                pushNewScreen(context, screen: const LoginScreen(),withNavBar: false);
              }
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mainColor,
          ),
          height: 45,
          width: double.infinity,
          child: const Center(
            child: Text('Đăng xuất',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}
