import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/model/models/login_data.dart';
import 'package:sse/screen/info_cpn/info_cpn_screen.dart';
import 'package:sse/screen/login/login_bloc.dart';
import 'package:sse/screen/login/login_event.dart';
import 'package:sse/screen/login/login_state.dart';
import 'package:sse/screen/page_test.dart';

import '../../utils/const.dart';
import '../../route/custom_route.dart';
import '../../utils/utils.dart';
import 'component/custom_login.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 5250);

  late LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = LoginBloc(context);
    _loginBloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (context,state){
          if (state is LoginFailure) {
            Const.HOST_URL = '';
            Const.PORT_URL = 0;
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          bloc: _loginBloc,
          builder: (BuildContext context, LoginState state){
            return CustomLogin(
              logo: const AssetImage('assets/images/logo.png'),
              logoTag: Const.logoTag,
              titleTag: Const.titleTag,
              onLogin: (loginData) async{
                debugPrint('Hot Id: ${loginData.hotId}');
                debugPrint('User Name: ${loginData.username}');
                debugPrint('Password: ${loginData.password}');
                bool? success;
                // success = await _loginBloc.login(loginData.hotId, loginData.username, loginData.password);
                success = await _loginBloc.login("https://tcg-cloud.sse.net.vn", "trungdk", "123abc");
                print(success);
                return success;
              },
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(FadePageRoute(
                  builder: (context) => InfoCPNScreen(username: _loginBloc.userName.toString()),
                ));
              },
            );
          },
        ),
      ),
    );
  }
}
