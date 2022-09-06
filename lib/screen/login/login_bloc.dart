import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/database/dbhelper.dart';
import 'package:sse/model/entity/info_login.dart';
import 'package:sse/model/network/request/login_request.dart';
import 'package:sse/model/network/response/login_response.dart';
import 'package:sse/model/network/services/host.dart';
import 'package:sse/model/network/services/network_factory.dart';
import 'package:sse/screen/dms/dms_screen.dart';
import 'package:sse/screen/home/home_screen.dart';
import 'package:sse/screen/login/login_event.dart';
import 'package:sse/screen/login/login_state.dart';
import 'package:sse/screen/menu/menu_screen.dart';
import 'package:sse/screen/personnel/personnel_screen.dart';
import 'package:sse/screen/sell/sell_screen.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';


class LoginBloc extends Bloc<LoginEvent,LoginState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _prefs;
  SharedPreferences? get pref => _prefs;
  late String userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  DatabaseHelper? db;

  List<InfoLogin> infoLoginSt = <InfoLogin>[];

  HostSingleton? hostSingleton;

  late bool loginSuccess = false;

  List<Widget> listMenu = <Widget>[];
  List<PersistentBottomNavBarItem> listNavItem =<PersistentBottomNavBarItem>[];

  LoginBloc(this.context) : super(InitialLoginState()){
    _networkFactory = NetWorkFactory(context);
    db = DatabaseHelper();
    db!.init();
    on<GetPrefs>(_getPrefs,);
    // on<Login>(_login);
  }

  void _getPrefs(GetPrefs event, Emitter<LoginState> emitter)async{
    emitter(LoginLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(InitialLoginState());
  }

  // void _login(Login event, Emitter<LoginState> emitter)async{
  //   hostSingleton = new HostSingleton();
  //   hostSingleton?.host = Const.HOST_URL;
  //   hostSingleton?.port = Const.PORT_URL;
  //   emitter(LoginLoading());
  //   LoginRequest request = LoginRequest(
  //       hostId: event.hostURL,
  //       userName: event.username,
  //       password: event.password,
  //       devideToken: "",
  //       language: "V"
  //   );
  //
  //   LoginState state = _handleLogin(await _networkFactory!.login(request),event.hostURL,event.username,event.password);
  //   emitter(state);
  // }

  Future<bool> login(String hostURL, String username, String password)async{
    Const.HOST_URL = hostURL.trim();
    hostSingleton = new HostSingleton();
    hostSingleton?.host = Const.HOST_URL;
    hostSingleton?.port = Const.PORT_URL;
    _networkFactory = NetWorkFactory(context);
    print('checking: ${Const.HOST_URL} - ${Const.PORT_URL}');
    LoginRequest request = LoginRequest(
        hostId: hostURL,
        userName: username,
        password: password,
        devideToken: "",
        language: "V"
    );
    LoginState state = _handleLogin(await _networkFactory!.login(request),hostURL,username,password);
    if(state is LoginSuccess){
      return true;
    }else{
      return false;
    }
    // emitter(state);
  }

  LoginState _handleLogin(Object data,String hostURL,String username,String pass) {
    if (data is String) return LoginFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      LoginResponse response = LoginResponse.fromJson(data as Map<String,dynamic>);
      LoginResponseUser? loginResponseUser = response.user;
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      userName = response.user!.userName!;
      Const.userName = response.user!.userName!;
      Const.userId = response.user!.userId!;
      Utils.saveDataLogin(_prefs!, loginResponseUser!,_accessToken!,_refreshToken!);
      pushService(hostURL,username,pass);
      return LoginSuccess();
    } catch (e) {
      loginSuccess = false;
      return LoginFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  void pushService(String hostURLPORT,String username, String pass) async{
    InfoLogin _infoLogin = new InfoLogin(
        'vi',
        'Tiếng Việt',
        hostURLPORT,
        username,
        pass
    );
    await db!.addInfoLogin(_infoLogin);
    infoLoginSt = await getListFromDb();
    if(!Utils.isEmpty(infoLoginSt)){
      db!.updateInfoLogin(_infoLogin);
    }
  }

  Future<List<InfoLogin>> getListFromDb() {
    return db!.fetchAllInfoLogin();
  }
}