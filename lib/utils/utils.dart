// ignore_for_file: unnecessary_null_comparison

import 'dart:ffi';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/network/response/login_response.dart';
import 'package:intl/intl.dart';
import '../model/models/login_user_type.dart';
import '../screen/menu/support/support_center.dart';
import '../screen/widget/custom_toast.dart';
import '../screen/widget/custom_upgrade.dart';
import '../themes/colors.dart';
import 'const.dart';
import 'images.dart';

class Utils{

  static bool isEmpty(Object text) {
    if (text is String) return text.isEmpty;
    if (text is List) return  text.isEmpty;
    // ignore: unnecessary_null_comparison
    return text == null;
  }

  static Uint8List hexToUint8List(String hex) {
    // ignore: unnecessary_type_check
    if (!(hex is String)) {
      throw 'Expected string containing hex digits';
    }
    if (hex.length % 2 != 0) {
      throw 'Odd number of hex digits';
    }
    var l = hex.length ~/ 2;
    var result = new Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(hex.substring(i * 2, (2 * (i + 1))), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result[i] = x;
    }
    return result;
  }

  static String getAutoFillHints(LoginUserType userType) {
    switch (userType) {
      case LoginUserType.hotId:
        return AutofillHints.hotId;
      case LoginUserType.name:
        return AutofillHints.username;
      case LoginUserType.phone:
        return AutofillHints.telephoneNumber;
      case LoginUserType.email:
      default:
        return AutofillHints.email;
    }
  }


  static void showDialogTwoButton(
      {required BuildContext context,
        String? title,
        required Widget contentWidget,
        required List<Widget> actions,
        bool dismissible = false}) =>
      showDialog(
          barrierDismissible: dismissible,
          context: context,
          builder: (context) {
            return AlertDialog(
                title: title != null ? Text(title) : null,
                content: contentWidget,
                actions: actions);
          });


  static TextInputType getKeyboardType(LoginUserType userType) {
    switch (userType) {
      case LoginUserType.name:
        return TextInputType.name;
      case LoginUserType.phone:
        return TextInputType.number;
      case LoginUserType.email:
      default:
        return TextInputType.emailAddress;
    }
  }

  static Icon getPrefixIcon(LoginUserType userType) {
    switch (userType) {
      case LoginUserType.name:
        return const Icon(FontAwesomeIcons.circleUser);
      case LoginUserType.phone:
        return const Icon(FontAwesomeIcons.squarePhoneFlip);
      case LoginUserType.email:
      default:
        return const Icon(FontAwesomeIcons.squareEnvelope);
    }
  }

  static String getLabelText(LoginUserType userType) {
    switch (userType) {
      case LoginUserType.hotId:
        return "Hot Id";
      case LoginUserType.name:
        return "Tài khoản";
      case LoginUserType.phone:
        return "Phone";
      case LoginUserType.pass:
      default:
        return "Mật khẩu";
    }
  }

  static bool isNullOrEmpty(String? value) => value == '' || value == null;

  static void showUpgradeAccount(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: CustomUpgradeComponent(
              showTwoButton: true,
              iconData: Icons.warning_amber_outlined,
              title: 'Upgrade Account !!!',
              content: 'Tính năng bị hạn chế vui lòng Upgrade tài khoản để sử dụng tính năng này!',
            ),
          );
        }).then((value)async{
      if(value == 'Yeah'){
        pushNewScreen(context, screen: const SupportCenterScreen(),withNavBar: false);
      }
    });
  }

  static void showForegroundNotification(BuildContext context, String title, String text, {VoidCallback? onTapNotification}) {
    showOverlayNotification((context) {
      return Padding(
        padding: const EdgeInsets.only(top: 38,left: 8,right: 8),
        child: Material(
          color: Colors.transparent,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: InkWell(
                onTap: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                  onTapNotification!();
                },
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.asset(icLogo,fit: BoxFit.contain,scale: 1,),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  subtitle: Text(text,style:  const TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 4000));
  }

  static void saveDataLogin(SharedPreferences _prefs, LoginResponseUser user,String accessToken, String refreshToken) {
    _prefs.setString(Const.USER_ID, user.userId!.toString());
    _prefs.setString(Const.ACCESS_TOKEN, accessToken);
    _prefs.setString(Const.REFRESH_TOKEN, refreshToken);
    _prefs.setString(Const.USER_NAME, user.userName??"");
    _prefs.setString(Const.PHONE_NUMBER, user.phoneNumber??"");
    _prefs.setString(Const.CODE, user.code.toString() == null ? '' : user.code.toString());
    _prefs.setString(Const.CODE_NAME, user.codeName??"");
    _prefs.setString(Const.EMAIL, user.email??"");
  }

  static void removeData(SharedPreferences _prefs) {
    _prefs.remove(Const.USER_ID);
    _prefs.remove(Const.USER_NAME);
    _prefs.remove(Const.ACCESS_TOKEN);
    _prefs.remove(Const.REFRESH_TOKEN);
    _prefs.remove(Const.PHONE_NUMBER);
    _prefs.remove(Const.EMAIL);
    _prefs.remove(Const.CODE);
    _prefs.remove(Const.CODE_NAME);
  }

  static navigateNextFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String formatMoney(dynamic amount) {
    return NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
        .replaceAll(' ', '').replaceAll('.', ',')
        .replaceAll('₫', '');
  }

  static String formatMoneyStringToDouble(dynamic amount) {
    return NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
        .replaceAll(' ', '').replaceAll(',', '.')
        .replaceAll('₫', '');
  }

  static bool isTablet() {

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      return true;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      return true;
    }
    else {
      return false;
    }

  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static getCountByScreen(BuildContext context) {
    if (isTablet())
      return isPortrait(context) ? 2 : 5;
    else
      return /*isPortrait(context) ? 2 : 3*/ 2;
  }

  static bool isInteger(num value) => value is int || value == value.roundToDouble();

  static String formatNumber(num amount) {
    return isInteger(amount) ? amount.toStringAsFixed(0) : amount.toString();
  }

  static void showCustomToast(BuildContext context,IconData icon, String title){
    showToastWidget(
      customToast(context, icon, title),
      duration: const Duration(seconds: 3),
      onDismiss: () {},
    );
  }

  static String parseDateToString(DateTime dateTime, String format) {
    String date = "";

    if (dateTime != null)
      try {
        date = DateFormat(format).format(dateTime);
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }

  static String parseStringDateToString(String dateSv, String fromFormat, String toFormat) {
    String date = "";
    if (dateSv != null)
      try {
        date = DateFormat(toFormat, "en_US")
            .format(DateFormat(fromFormat).parse(dateSv));
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }

  static DateTime parseStringToDate(String dateStr, String format) {
    DateTime date = DateTime.now();
    if (dateStr != null)
      try {
        date = DateFormat(format).parse(dateStr);
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }

  static String parseDateTToString(String dateInput,String format){
    String date = "";
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateInput);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat(format);
    date = outputFormat.format(inputDate);
    return date;
  }

  static String formatTotalMoney(dynamic amount) {

    String totalMoney = NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
        .replaceAll(' ', '').replaceAll('.', ' ')
        .replaceAll('₫', '').toString();
    if(totalMoney.split(' ').length == 1 || totalMoney.split(' ').length == 2){
      return totalMoney;
    }else{
      return totalMoney.split(' ')[0] + ' '+ totalMoney.split(' ')[1];
    }
  }
}