import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/personnel/personnel_bloc.dart';
import 'package:sse/screen/personnel/personnel_event.dart';
import 'package:sse/screen/personnel/personnel_state.dart';
import 'package:sse/screen/personnel/suggestions/suggestions_screen.dart';
import 'package:sse/screen/personnel/time_keeping/component/home_test.dart';
import 'package:sse/screen/personnel/time_keeping/component/test.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_screen.dart';
import 'package:sse/themes/colors.dart';

import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../widget/custom_question.dart';
import '../widget/pending_action.dart';
import 'component/list_dnc.dart';

class PersonnelScreen extends StatefulWidget {
  const PersonnelScreen({Key? key}) : super(key: key);

  @override
  _PersonnelScreenState createState() => _PersonnelScreenState();
}

class _PersonnelScreenState extends State<PersonnelScreen> {

  late PersonnelBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = PersonnelBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PersonnelBloc,PersonnelState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is TimeKeepingSuccess){
            Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeahh, Chấm công thành công');
          }else if(state is TimeKeepingFailure){
            Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi,  ${state.error}');
          }
        },
        child: BlocBuilder<PersonnelBloc,PersonnelState>(
          bloc: _bloc,
          builder: (BuildContext context, PersonnelState state){
            return Stack(
              children: [
                buildBody(context,state),
                Visibility(
                  visible: state is PersonnelLoading,
                  child: PendingAction(),
                )
              ],
            );

          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,PersonnelState state){
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
                buildTitle('Chấm công'),
                InkWell(
                  onTap: (){
                    if(Const.timeKeeping == true){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: CustomQuestionComponent(
                                showTwoButton: true,
                                iconData: Icons.warning_amber_outlined,
                                title: 'Bạn đang thực hiện chấm công!!!',
                                content: 'Thời gian chấm công: ${DateTime.now().hour}:${DateTime.now().minute < 10 ? ('0' + DateTime.now().minute.toString()) :DateTime.now().minute  }:${DateTime.now().second}',
                              ),
                            );
                          }).then((value)async{
                        if(value != null){
                          if(!Utils.isEmpty(value) && value == 'Yeah'){
                            _bloc.add(LoadingTimeKeeping(uId: Const.uId));
                          }
                        }
                      });
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Chấm công',MdiIcons.timetable, Const.timeKeeping == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    pushNewScreen(context, screen: TimeKeepingScreen(),withNavBar: false);
                    // if(Const.stageStatistic == true){
                    //
                    // }else{
                    //
                    // }
                    // Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Bảng chấm công',MdiIcons.tableAccount, false),
                ),
                const SizedBox(height: 10,),
                buildTitle('Đề nghị'),
                InkWell(
                  onTap: (){
                    if(Const.onLeave == true){
                      pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 1, title: 'Đề nghị nghỉ phép',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Nghỉ phép',MdiIcons.calendarAccountOutline, Const.onLeave == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.recommendSpending == true){
                      pushNewScreen(context, screen: ListDNC(),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Đề nghị chi',Icons.monetization_on_outlined, Const.recommendSpending == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.articleCar == true){
                      pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Điều xe',MdiIcons.truckFast, Const.articleCar == true? false : true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Công việc'),
                InkWell(
                  onTap: (){
                    if(Const.createNewWork == true){
                    //   pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Thêm mới công việc',Icons.note_add, Const.createNewWork == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.workAssigned == true){
                      //   pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Công việc tôi giao',MdiIcons.pencilBoxMultipleOutline, Const.workAssigned == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.myWork == true){
                      //   pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Công việc của tôi',MdiIcons.timetable, Const.myWork == true? false : true),
                ),
                InkWell(
                  onTap: (){
                    if(Const.workInvolved == true){
                      //   pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    }else{
                      Utils.showUpgradeAccount(context);
                    }
                  },
                  child:  buildButton('Công việc tôi liên quan',Icons.fact_check, Const.workInvolved == true? false : true),
                ),
                const SizedBox(height: 10,),
                buildTitle('Thông tin nhân sự & phòng ban'),
                InkWell(
                  onTap: (){
                    // if(Const.workInvolved == true){
                    //     pushNewScreen(context, screen: SuggestionsScreen(keySuggestion: 3, title: 'Đề nghị điều xe',),withNavBar: true);
                    // }else{
                    //   Utils.showUpgradeAccount(context);
                    // }
                    Utils.showUpgradeAccount(context);
                  },
                  child:  buildButton('Thông tin nhân viên',MdiIcons.accountDetailsOutline, true),
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
