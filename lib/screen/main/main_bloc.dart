import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main_event.dart';
import 'main_state.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Utils.showForegroundNotification(contexts!, message.notification!.title.toString(), message.notification!.body.toString(), onTapNotification: () {
  },);
}
BuildContext? contexts;
class MainBloc extends Bloc<MainEvent,MainState>{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  BuildContext? context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  int indexBanner = 0;

  static final _messaging = FirebaseMessaging.instance;

  init(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
    // _networkFactory = NetWorkFactory(context);
  }

  registerUpPushNotification() {
    //REGISTER REQUIRED FOR IOS
    if (Platform.isIOS) {
      _messaging.requestPermission();
    }
    _messaging.getToken().then((value) {
      if (value == null) return;
    });
  }

  String savedMessageId  = "";

  _listenToPushNotifications() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);
    contexts = context;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId) {
        savedMessageId  = message.messageId!;
      } else {
        return;
      }
      print("onMessage$savedMessageId");
      subscribeToTopic(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId) {
        savedMessageId  = message.messageId!;
      } else {
        return;
      }
      print("onMessageOpenedApp$savedMessageId");
      subscribeToTopic(message);
    });
  }

  void subscribeToTopic(RemoteMessage message){
    Utils.showForegroundNotification(context!, message.notification!.title.toString(), message.notification!.body.toString(), onTapNotification: () {},);
  }

  void showNotification({String? title, String? body,})async {
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('arrive'),
        showWhen: true);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  MainBloc() : super(InitialMainState()){
    registerUpPushNotification();
    _listenToPushNotifications();
    on<GetPrefs>(_getPrefs);

  }


  void _getPrefs(GetPrefs event, Emitter<MainState> emitter)async{
    emitter(InitialMainState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }
}