import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_event.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_state.dart';
import 'package:sse/utils/const.dart';

import '../../../model/network/request/time_keeping_request.dart';
import '../../../model/network/services/network_factory.dart';

class TimeKeepingBloc extends Bloc<TimeKeepingEvent,TimeKeepingState>{
  NetWorkFactory? _networkFactory;
  BuildContext context;
  SharedPreferences? _pref;
  SharedPreferences? get pref => _pref;
  String? userName;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  int indexBanner = 0;
  String? _userId;
  String? currentAddress;
  Position? currentLocation;

  TimeKeepingBloc(this.context) : super(InitialTimeKeepingState()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefsTimeKeeping>(_getPrefs);
    on<TimeKeepingFromUserEvent>(_timeKeepingFromUserEvent);
    on<LoadingTimeKeeping>(_loadingTimeKeeping);

  }


  void _getPrefs(GetPrefsTimeKeeping event, Emitter<TimeKeepingState> emitter)async{
    emitter(InitialTimeKeepingState());
    _pref = await SharedPreferences.getInstance();
    userName = _pref!.getString(Const.USER_NAME) ?? "";
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    _userId = _pref!.getString(Const.USER_ID) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _timeKeepingFromUserEvent(TimeKeepingFromUserEvent event, Emitter<TimeKeepingState> emitter)async{
    emitter(InitialTimeKeepingState());
    TimeKeepingRequest request = TimeKeepingRequest(
        datetime: event.datetime,
        userName: _userId,
        location: currentAddress,
        latLong: '${currentLocation?.latitude},${currentLocation?.longitude}',
        descript: '',
        note: '',
        uId: event.uId,
        qrCode: event.qrCode
    );
    TimeKeepingState state =  _handleTimeKeeping(await _networkFactory!.timeKeeping(request,_accessToken!));
    emitter(state);
  }

  void _loadingTimeKeeping(LoadingTimeKeeping event, Emitter<TimeKeepingState> emitter)async{
    emitter(TimeKeepingLoading());
    getUserLocation().whenComplete(() => add(TimeKeepingFromUserEvent(DateTime.now().toString(), '0',event.uId)));
  }

  TimeKeepingState _handleTimeKeeping(Object data,) {
    if (data is String) return TimeKeepingFailure('Úi, Có lỗi rồi Đại Vương ơi !!!');
    try {
      return TimeKeepingSuccess();
    } catch (e) {
      return TimeKeepingFailure('Úi, ${e.toString()}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<TimeKeepingState> getUserLocation() async {
    currentLocation = await _determinePosition();
    print(currentLocation?.latitude.toString());
    print(currentLocation?.longitude.toString());
    return GetLocationSuccess();
  }
}