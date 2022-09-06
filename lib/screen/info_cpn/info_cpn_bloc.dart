import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/network/request/config_request.dart';
import 'package:sse/model/network/response/info_company_response.dart';
import 'package:sse/model/network/response/info_store_response.dart';
import 'package:sse/model/network/response/info_units_response.dart';
import 'package:sse/model/network/services/network_factory.dart';
import 'package:sse/utils/const.dart';

import '../../model/network/response/get_permission_user_response.dart';
import '../../model/network/response/setting_options_response.dart';
import '../../themes/colors.dart';
import '../dms/dms_screen.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../personnel/personnel_screen.dart';
import '../sell/sell_screen.dart';
import 'info_cpn_event.dart';
import 'info_cpn_state.dart';


class InfoCPNBloc extends Bloc<InfoCPNEvent,InfoCPNState>{

  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _prefs;
  SharedPreferences? get pref => _prefs;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  String? deviceToken;

  late List<InfoCompanyResponseCompanies> listInfoCPN = <InfoCompanyResponseCompanies>[];
  late List<InfoUnitsResponseUnits> listUnitsCPN = <InfoUnitsResponseUnits>[];
  late List<InfoStoreResponseData> listStoreCPN = <InfoStoreResponseData>[];

  String? companiesNameSelected;
  String? companiesIdSelected;

  String? unitsNameSelected;
  String? unitsIdSelected;

  String? storeNameSelected;
  String? storeIdSelected;

  bool? showAnimationStore = true;
  int keyLock = 0;

  List<SettingOptionsResponseData> listSettingOptions = <SettingOptionsResponseData>[];

  List<UserPermission> listUserPermission=[];
  List<Widget> listMenu = <Widget>[];
  List<PersistentBottomNavBarItem> listNavItem =<PersistentBottomNavBarItem>[];

  InfoCPNBloc(this.context) : super(InitialInfoCPNState()){
    _networkFactory = NetWorkFactory(context);
    getTokenFCM();
    on<GetPrefsInfoCPN>(_getPrefs,);
    on<GetSettingOption>(_getSettingOption);
    on<UpdateTokenFCM>(_updateTokenFCM);
    on<GetCompanyIF>(_getInfoCPN);
    on<Config>(_configCPN);
    on<GetUnits>(_getUnitCPN);
    on<GetStore>(_getStoreCPN);
  }

  void _getPrefs(GetPrefsInfoCPN event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(InfoCPNSuccess());
  }

  void _getInfoCPN(GetCompanyIF event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    InfoCPNState state = _handleGetCompanies(await _networkFactory!.getCompanies(_accessToken!));
    emitter(state);
  }

  void _configCPN(Config event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    ConfigRequest request = ConfigRequest(
        companyId: event.companyId
    );
    InfoCPNState state = _handleConfig(await _networkFactory!.config(request));
    emitter(state);
  }

  void _getUnitCPN(GetUnits event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    InfoCPNState state = _handleGetUnits(await _networkFactory!.getUnits(_accessToken!));
    emitter(state);
  }

  void _getStoreCPN(GetStore event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    InfoCPNState state = _handleGetStore(await _networkFactory!.getStore(_accessToken!,event.unitId));
    emitter(state);
  }

  void _updateTokenFCM(UpdateTokenFCM event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    print("Token: $deviceToken");
    InfoCPNState state = _handleUpdateUId(await _networkFactory!.updateUId(_accessToken!,deviceToken!));
    emitter(state);
  }

  void _getSettingOption(GetSettingOption event, Emitter<InfoCPNState> emitter)async{
    emitter(InfoCPNLoading());
    InfoCPNState state = _handleGetSettings(await _networkFactory!.getSettingOption(_accessToken!));
    emitter(state);
  }

  InfoCPNState _handleGetCompanies(Object data) {
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      InfoCompanyResponse response = InfoCompanyResponse.fromJson(data as Map<String,dynamic>);
      listInfoCPN = response.companies!;
      if(listStoreCPN.isNotEmpty){
        listStoreCPN.clear();
        storeIdSelected = null;
        storeNameSelected = null;
      }
      if(listUnitsCPN.isNotEmpty){
        listUnitsCPN.clear();
        unitsIdSelected = null;
        unitsNameSelected = null;
      }
      return GetInfoCompanySuccessful();
    } catch (e) {
      print(e.toString());
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  InfoCPNState _handleConfig(Object data){
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      if(listStoreCPN.isNotEmpty){
        listStoreCPN.clear();
        storeIdSelected = null;
        storeNameSelected = null;
      }
      if(listUnitsCPN.isNotEmpty){
        listUnitsCPN.clear();
        unitsIdSelected = null;
        unitsNameSelected = null;
      }
      return ConfigSuccessful();
    } catch (e) {
      print(e.toString());
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  InfoCPNState _handleGetUnits(Object data){
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      InfoUnitsResponse response = InfoUnitsResponse.fromJson(data as Map<String,dynamic>);
      listUnitsCPN = response.units!;
      if(listStoreCPN.isNotEmpty){
        listStoreCPN.clear();
        storeIdSelected = null;
        storeNameSelected = null;
      }
      return GetInfoUnitsSuccessful();
    } catch (e) {
      print(e.toString());
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  InfoCPNState _handleGetStore(Object data){
    if (data is String) return GetStoreCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      InfoStoreResponse response = InfoStoreResponse.fromJson(data as Map<String,dynamic>);
      listStoreCPN = response.stores!;
      if(listStoreCPN.isEmpty == true && showAnimationStore == true){
        showAnimationStore = false;
        return GetStoreCPNFailure('null');
      }else if(listStoreCPN.isNotEmpty == true && response.statusCode == 200){
        showAnimationStore = true;
        return GetInfoStoreSuccessful();
      }else{
        return GetStoreCPNFailure('null');
      }
    } catch (e) {
      print(e.toString());
      return GetStoreCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  Future<String?> getIdDevice() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  getTokenFCM() {
    print('adxkhma');
    FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
      print('deviceToken: $deviceToken');
    });
  }

  Future<bool> getPermissionUser(String accessToken)async{
    InfoCPNState state = _handleGetPermissionUser(await _networkFactory!.getPermissionUser(accessToken));
    if(state is GetPermissionSuccess){
      return true;
    }else{
      return false;
    }
  }

  InfoCPNState _handleGetSettings(Object data) {
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      SettingOptionsResponse response = SettingOptionsResponse.fromJson(data as Map<String,dynamic>);
      listSettingOptions = response.dataSettingOptions!;
      listSettingOptions.forEach((element) {
        if( int.parse(element.inStockCheck.toString()) == 0){
          Const.inStockCheck = false;
        }else if( int.parse(element.inStockCheck.toString()) == 1){
          Const.inStockCheck = true;
        }
      });
      return GetSettingsSuccessful();
    } catch (e) {
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  InfoCPNState _handleUpdateUId(Object data){
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      print('Update UID success');
      return UpdateUIdSuccess();
    }catch(e){
      print(e);
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }

  InfoCPNState _handleGetPermissionUser(Object data){
    if (data is String) return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try{
      if(listMenu.isNotEmpty)
        listMenu.clear();
      if(listNavItem.isNotEmpty)
        listNavItem.clear();
      GetPermissionUserResponse response = GetPermissionUserResponse.fromJson(data as Map<String,dynamic>);
      listUserPermission = response.userPermission!;
      /// No check menu
      /// 27.8.2022
      ///
      listMenu.add(HomeScreen());
      listNavItem.add(PersistentBottomNavBarItem(
        icon: const Icon(MdiIcons.viewDashboardOutline),
        title: "Dashboard",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: mainColor,
      ),);

      listMenu.add(SellScreen());
      listNavItem.add(PersistentBottomNavBarItem(
        icon: const Icon(MdiIcons.shopping),
        title: "Sell",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: mainColor,
      ));

      listMenu.add(DMSScreen());
      listNavItem.add(PersistentBottomNavBarItem(
        inactiveColorSecondary: mainColor,
        icon: const Icon(MdiIcons.webhook),
        title: ("DMS"),
        activeColorPrimary: mainColor,
        activeColorSecondary: mainColor,
        inactiveColorPrimary: Colors.grey,
        // onPressed: (context) {
        //   pushDynamicScreen(context,
        //       screen: SampleModalScreen(), withNavBar: true);
        // }
      ));

      listMenu.add(PersonnelScreen());
      listNavItem.add(PersistentBottomNavBarItem(
        icon: const Icon(MdiIcons.accountDetailsOutline),
        title: ("HR"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
      ));

      listMenu.add(MenuScreen());
      listNavItem.add(PersistentBottomNavBarItem(
        icon: const Icon(MdiIcons.menu),
        title: ("MENU"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
      ),);

      if(listUserPermission.isNotEmpty){
        listUserPermission.forEach((element) {
          // Parent Menu
          if(element.menuId == '01.00.00'){
            Const.dashBroad = true;
            // listMenu.add(HomeScreen());
            // listNavItem.add(PersistentBottomNavBarItem(
            //     icon: const Icon(MdiIcons.viewDashboardOutline),
            //     title: "Dashboard",
            //     activeColorPrimary: mainColor,
            //     inactiveColorPrimary: Colors.grey,
            //     inactiveColorSecondary: mainColor,
            //   ),);
          }
          else if(element.menuId == '01.00.02'){
            Const.report = true;
            // listMenu.add(SellScreen());
            // listNavItem.add(PersistentBottomNavBarItem(
            //   icon: const Icon(FontAwesomeIcons.sellsy),
            //   title: "Sell",
            //   activeColorPrimary: mainColor,
            //   inactiveColorPrimary: Colors.grey,
            //   inactiveColorSecondary: mainColor,
            // ));
          }
          else if(element.menuId == '01.00.03'){
            Const.approval = true;
            // listMenu.add(DMSScreen());
            // listNavItem.add(PersistentBottomNavBarItem(
            //   inactiveColorSecondary: mainColor,
            //   icon: const Icon(MdiIcons.webhook),
            //   title: ("DMS"),
            //   activeColorPrimary: mainColor,
            //   activeColorSecondary: mainColor,
            //   inactiveColorPrimary: Colors.grey,
            //   // onPressed: (context) {
            //   //   pushDynamicScreen(context,
            //   //       screen: SampleModalScreen(), withNavBar: true);
            //   // }
            // ));
          }
          else if(element.menuId == '01.00.01'){
            Const.hr = true;
            // listMenu.add(PersonnelScreen());
            // listNavItem.add(PersistentBottomNavBarItem(
            //       icon: const Icon(MdiIcons.accountDetailsOutline),
            //       title: ("HR"),
            //       activeColorPrimary: mainColor,
            //       inactiveColorPrimary: Colors.grey,
            //     ));
          }
          else if(element.menuId == '01.00.04'){
            Const.menu = true;
            // listMenu.add(MenuScreen());
            // listNavItem.add(PersistentBottomNavBarItem(
            //   icon: const Icon(MdiIcons.menu),
            //   title: ("MENU"),
            //   activeColorPrimary: mainColor,
            //   inactiveColorPrimary: Colors.grey,
            // ),);
          }
          // Menu
          // Home
          else if(element.menuId == '01.00.05'){
            Const.setting = true;
          }
          else if(element.menuId == '01.00.06'){
            Const.notification = true;
          }
          else if(element.menuId == '01.00.08'){
            Const.reportHome = true;
          }
          //Sell
          else if(element.menuId == '01.00.11'){
            Const.banner = true;
          }
          else if(element.menuId == '01.00.12'){
            Const.createNewOrder = true;
          }
          else if(element.menuId == '01.00.13'){
            Const.transportation = true;
          }
          else if(element.menuId == '01.00.14'){
            Const.customer = true;
          }
          else if(element.menuId == '01.00.15'){
            Const.production = true;
          }
          else if(element.menuId == '01.00.16'){
            Const.stageStatistic = true;
          }
          else if(element.menuId == '01.00.27'){
            Const.historyOrder = true;
          }
          //Menu
          else if(element.menuId == '01.00.17'){
            Const.timeKeeping = true;
          }
          else if(element.menuId == '01.00.18'){
            Const.checkIn = true;
          }
          else if(element.menuId == '01.00.19'){
            Const.createNewWork = true;
          }
          else if(element.menuId == '01.00.20'){
            Const.workAssigned = true;
          }
          else if(element.menuId == '01.00.21'){
            Const.myWork = true;
          }
          else if(element.menuId == '01.00.22'){
            Const.workInvolved = true;
          }
          else if(element.menuId == '01.00.23'){
            Const.onLeave = true;
          }
          else if(element.menuId == '01.00.24'){
            Const.recommendSpending = true;
          }
          else if(element.menuId == '01.00.25'){
            Const.articleCar = true;
          }
          else if(element.menuId == '01.00.26'){
            Const.shippingProduct = true;
          }
          else if(element.menuId == '01.00.28'){
            Const.confirmShippingProduct = true;
          }
          else if(element.menuId == '01.00.29'){
            Const.deliveryPlan = true;
          }
          else if(element.menuId == '01.00.30'){
            Const.updateDeliveryPlan = true;
          }
          else if(element.menuId == '01.00.53'){
            Const.cacheAllowed = true;
          }
          else if(element.menuId == '01.00.54'){
            Const.allowedConfirm = true;
          }
        });
        return GetPermissionSuccess();
      }
      else{
        return GetPermissionFail();
      }
    }catch(e){
      print(e);
      return InfoCPNFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    }
  }
}