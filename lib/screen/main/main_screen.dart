import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/dms/dms_bloc.dart';
import 'package:sse/screen/home/home_bloc.dart';
import 'package:sse/screen/menu/menu_bloc.dart';
import 'package:sse/screen/personnel/personnel_bloc.dart';
import 'package:sse/screen/sell/sell_bloc.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import 'main_bloc.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainScreen extends StatefulWidget {
  final List<Widget> listMenu;
  final List<PersistentBottomNavBarItem> listNavItem;
  final String? userName;
  final String? currentAddress;
  final int? rewardPoints;

  const MainScreen({Key? key,required this.listMenu,required this.listNavItem,this.userName,this.currentAddress,this.rewardPoints}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  late MainBloc _mainBloc;
  late HomeBloc _homeBloc;
  late SellBloc _sellBloc;
  late DMSBloc _dmsBloc;
  late PersonnelBloc _personnelBloc;
  late MenuBloc _menuBloc;

  PersistentTabController? _controller;

  int _lastIndexToHome = 0;
  int _currentIndex = 0;


  GlobalKey<NavigatorState>? _currentTabKey;
  // late List<BottomNavigationBarItem> listBottomItems;
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  // void showUpdate(){
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return WillPopScope(
  //           onWillPop: () async => false,
  //           child: const ConfirmUpdateVersionPage(
  //             title: 'Đã có phiên bản mới',
  //             content: 'Cập nhật ứng dụng của bạn để có trải nghiệm tốt nhất',
  //             type: 0,
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {

    _mainBloc = MainBloc();
    _homeBloc = HomeBloc(context);
    _sellBloc = SellBloc(context);
    _dmsBloc = DMSBloc();
    _personnelBloc = PersonnelBloc(context);
    _menuBloc = MenuBloc(context);
    _controller = PersistentTabController(initialIndex: 0);
    _currentTabKey = firstTabNavKey;
    widget.listMenu.forEach((element) {

    });
    _mainBloc.add(GetPrefs());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        bool isSuccess = await _currentTabKey!.currentState!.maybePop();
        if (!isSuccess && _currentIndex != Const.HOME) {
          _lastIndexToHome = Const.HOME;
          _currentIndex = _lastIndexToHome;
          _currentTabKey = firstTabNavKey;
        }
        if (!isSuccess) _exitApp(context);
        return false;
      },
      child: Scaffold(
        body: MultiBlocProvider(
            providers: [
              BlocProvider<MainBloc>(
                create: (context) {
                  if (_mainBloc.isClosed == true) _mainBloc = MainBloc();
                  return _mainBloc;
                },
              ),
              BlocProvider<HomeBloc>(
                create: (context) {
                  if (_homeBloc.isClosed == true) _homeBloc = HomeBloc(context);
                  return _homeBloc;
                },
              ),
              BlocProvider<SellBloc>(
                create: (context) {
                  if (_sellBloc.isClosed == true) _sellBloc = SellBloc(context);
                  return _sellBloc;
                },
              ),
              BlocProvider<DMSBloc>(
                create: (context) {
                  if (_dmsBloc.isClosed == true) _dmsBloc = DMSBloc();
                  return _dmsBloc;
                },
              ),
              BlocProvider<PersonnelBloc>(
                create: (context) {
                  if (_personnelBloc.isClosed == true) _personnelBloc = PersonnelBloc(context);
                  return _personnelBloc;
                },
              ),
              BlocProvider<MenuBloc>(
                create: (context) {
                  if (_menuBloc.isClosed == true) _menuBloc = MenuBloc(context);
                  return _menuBloc;
                },
              ),
            ],
            child: BlocListener<MainBloc, MainState>(
              bloc: _mainBloc,
              listener: (context, state) {
                // if (state is GetVersionGoLiveSuccess) {
                //
                // }else if(state is GetPrefsSuccess){
                //   _mainBloc.add(GetLocationEvent());
                // }
                // else if(state is GetLisPromotionsSuccess){
                //
                // }
                // if (state is LogoutSuccess) {
                //   _lastIndexToShop = Const.HOME;
                //   _currentIndex = _lastIndexToShop;
                //   _currentTabKey = firstTabNavKey;
                // }
                // if (state is NavigateToNotificationState) {
                // }
              },
              child: BlocBuilder<MainBloc, MainState>(
                bloc: _mainBloc,
                builder: (context, state) {
                  // if (state is MainPageState) {
                  //   _currentIndex = state.position;
                  //   if (_currentIndex == Const.HOME) {}
                  //   else if (_currentIndex == Const.SALE) {}
                  //   else if (_currentIndex == Const.DMS) {}
                  // }
                  // if (state is MainProfile) {
                  //   _currentTabKey = fifthTabNavKey;
                  // }
                  _mainBloc.init(context);
                  return Stack(
                    children: [
                      PersistentTabView(
                        context,
                        controller: _controller,
                        screens: widget.listMenu,
                        items: widget.listNavItem,
                        confineInSafeArea: true,

                        handleAndroidBackButtonPress: true,
                        resizeToAvoidBottomInset: true,
                        stateManagement: true,
                        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 0.0
                            : kBottomNavigationBarHeight,
                        hideNavigationBarWhenKeyboardShows: true,
                        margin: const EdgeInsets.all(0.0),
                        popActionScreens: PopActionScreensType.all,
                        bottomScreenMargin: 0.0,
                        onWillPop: (context) async {
                          await showDialog(
                            context: context!,
                            useSafeArea: true,
                            builder: (context) => Container(
                              height: 50.0,
                              width: 50.0,
                              color: Colors.white,
                              child: ElevatedButton(
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                          return false;
                        },
                        selectedTabScreenContext: (context) {
                        },
                        hideNavigationBar: false,
                        backgroundColor: Colors.white,
                        decoration: const NavBarDecoration(
                          //border: Border.all(),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, spreadRadius: 0.1),
                            ],
                            //colorBehindNavBar: Colors.indigo,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            )),
                        popAllScreensOnTapOfSelectedTab: true,
                        itemAnimationProperties: const ItemAnimationProperties(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease,
                        ),
                        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property
                      ),
                      // Visibility(
                      //   visible: state is MainLoading,
                      //   child: PendingAction(),
                      // )
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }

  void _exitApp(BuildContext context) {
    List<Widget> actions = [
      FlatButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Text('No',
            style:
            const TextStyle(
              color: Colors.orange,
              fontSize: 14,
            )),
      ),
      FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Text(
            'Yes',
            style:const TextStyle(
              color: Colors.orange,
              fontSize: 14,)
        ),
      )
    ];

    Utils.showDialogTwoButton(
        context: context,
        title: 'Notice',
        contentWidget: Text(
            'ExitApp',
            style:const TextStyle(fontSize: 16.0)),
        actions: actions);
  }
}
