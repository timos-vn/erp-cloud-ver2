import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:sse/screen/info_cpn/info_cpn_bloc.dart';
import 'package:sse/screen/main/main_screen.dart';

import '../../utils/const.dart';
import '../../route/custom_route.dart';
import 'component/custom_info_cpn.dart';

class InfoCPNScreen extends StatefulWidget {
  final String? username;

  const InfoCPNScreen({Key? key,this.username}) : super(key: key);

  @override
  State<InfoCPNScreen> createState() => _InfoCPNScreenState();
}

class _InfoCPNScreenState extends State<InfoCPNScreen> {

  late InfoCPNBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = InfoCPNBloc(context);

  }

  @override
  Widget build(BuildContext context) {
    return CustomInfoCPN(
      logo: const AssetImage('assets/images/logo.png'),
      logoTag: Const.logoTag,
      titleTag: Const.titleTag,
      username: widget.username,
      onInfoCPN: (infoCPNData)async {
        bool? success;
        Const.uId = infoCPNData.uId;
        success = await _bloc.getPermissionUser(infoCPNData.accessToken);
        return success;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => MainScreen(listMenu: _bloc.listMenu,listNavItem: _bloc.listNavItem,),
        ));
      },
    );
  }
}
