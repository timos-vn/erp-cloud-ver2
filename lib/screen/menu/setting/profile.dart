import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/menu/menu_bloc.dart';
import 'package:sse/screen/menu/menu_state.dart';
import 'package:sse/screen/widget/custom_profile.dart';
import 'package:sse/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../themes/colors.dart';
import '../../widget/register_use.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin  {

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
        duration: const Duration(milliseconds: 1000), vsync: this);
    editAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: editController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );
    fadeController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: fadeController,
        curve: const Interval(
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
            return buildBody(state);
          },
        ),
      ),
    );
  }

  Widget buildBody(MenuState state){
    return Column(children: <Widget>[
      FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 15.0),
          child: Stack(children: <Widget>[
            CustomPaint(
              painter: ProfileHeader(deviceSize: MediaQuery.of(context).size),
            ),
            Container(
                width: 150.0,
                height: 150.0,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2,
                    top: MediaQuery.of(context).size.height * 0.1),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4.0,
                          offset: Offset(0.0, 5.0)),
                    ],
                    shape: BoxShape.circle,
                    image:  DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/background_erp.jpg'),
                    ))),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width - 50,
                  top: MediaQuery.of(context).size.height * 0.03),
              child: IconButton(
                  icon: const Icon(
                      MdiIcons.clipboardAccountOutline
                  ),
                  iconSize: 20.0,
                  color: Colors.white.withOpacity(0.8),
                  onPressed: () {

                  }),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${Const.userName != '' ? Const.userName.toUpperCase() : "Đối tác - SSE".toUpperCase()}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Hạng - Đang cập nhật',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14.0,
                        ),
                      ),
                    ])),
          ]),
        ),
      ),
      const SizedBox(height: 30,),
      Expanded(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildButton('Thông tin & Liên hệ',MdiIcons.contactlessPaymentCircle,'0',false,subColor),
                const Divider(),
                buildButton('Mật khẩu',MdiIcons.lockOutline,'0',false,subColor),
                Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2)
                ),
                const SizedBox(height: 5,),
                buildButton('Đổi ngôn ngữ',MdiIcons.earth,'Tiếng việt',true,subColor),
                const Divider(),
                buildButton('Cài đặt thông báo',MdiIcons.bellRingOutline,'0',false,subColor),
                Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2)
                ),
                const SizedBox(height: 7,),
                InkWell(
                  //onTap: ()=> pushNewScreen(context, screen: const PolicyScreen(),withNavBar: false),
                  child:  buildButton('Gửi phản hồi',MdiIcons.messageQuestionOutline,'0',false,Colors.red),
                ),
                // const Divider(),
                // buildButton('Yêu cầu xoá tài khoản',MdiIcons.accountRemoveOutline,'0',false,subColor),
                const SizedBox(height: 2,),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  buildButton(String title, IconData icons, String number, bool showNumber,Color colorIcon){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      child: Row(
        children: [
          Center(
            child: Icon(icons,size: 24,color: colorIcon,),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
          ),
          Visibility(
            visible: showNumber==true,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(number,style: const TextStyle(color: Colors.blueGrey),),
            ),),
          const Icon(Icons.navigate_next),
        ],
      ),
    );
  }

}
