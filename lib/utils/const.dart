
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sse/model/network/response/data_default_response.dart';
import 'package:sse/themes/colors.dart';

import '../model/entity/color_for_alpha_b.dart';

class Const {
  // ignore: non_constant_identifier_names
  // static  String HOST_URL = "http://103.48.192.2:6070";
  // ignore: non_constant_identifier_names
  static  String HOST_URL = "";
  // ignore: non_constant_identifier_names
  static  int PORT_URL = 0;

  static const String HOST_GOOGLE_MAP_URL = "https://maps.googleapis.com/maps/api/";

  // ignore: non_constant_identifier_names
  static TextInputFormatter FORMAT_DECIMA_NUMBER = FilteringTextInputFormatter.deny(RegExp('[\\-|\\ |\\/|\\*|\$|\\#|\\+|\\|]'));




  static const int MAX_COUNT_ITEM = 20;
  static const kDefaultPadding = 20.0;
  static const String BACK = 'Back to screen';

  static const String DATE_FORMAT = "dd/MM/yyyy";
  static const String DATE_TIME_FORMAT_LOCAL = "dd/MM/yyyy HH:mm:ss";
  static const String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
  static const String DATE_FORMAT_1 = "dd-MM-yyyy";
  static const String DATE_FORMAT_2 = "yyyy-MM-dd";
  static const String DATE_SV = "yyyy-MM-dd'T'HH:mm:ss";
  static const String DATE_SV_FORMAT = "yyyy/MM/dd";
  static const String DATE_SV_FORMAT_1 = "MM/dd/yyyy";
  static const String DATE_SV_FORMAT_2 = "yyyy-MM-dd";
  static const String DATE = "EEE";
  static const String DAY = "dd";
  static const String YEAR = "yyyy";
  static const String TIME = "hh:mm aa";

  static const String REFRESH = "REFRESH";

  static const HOME= 0;
  static const SALE = 1;
  static const DMS = 3;
  static const PERSONNEL= 4;
  static const MENU = 5;

  static const String BAR_CHART = 'bar';
  static const String PIE_CHART = 'pie';
  static const String LINE_CHART = 'line';

  static const String CHART = 'C';
  static const String TABLE = 'G';

  static const String ACCESS_TOKEN = "Token";
  static const String REFRESH_TOKEN = "Refresh token";
  static const String USER_ID = 'User id';
  static const String USER_NAME = "User name";
  static const String PHONE_NUMBER = "Phone number";
  static const String EMAIL = "Email";
  static const String CODE = "Code";
  static const String CODE_NAME = "Code name";

  static const String SEND_OTP_SUCCESS = "Send OTP Success";

  static const List<String> listSex = ['Nam', 'Nữ', 'Khác'];

  static const String logoTag = 'near.huscarl.loginsample.logo';
  static const String titleTag = 'near.huscarl.loginsample.title';

  ///version app
  static String versionApp = '1.0.0';

  ///Data
  static String companyId = '';
  static String companyName = '';
  static String unitId = '';
  static String unitName = '';
  static String storeId = '';
  static String storeName = '';
  static String uId = '';
  static bool inStockCheck = false;
  static String userName = '';
  static int userId = 0;


  static List<StockList> stockList = [];
  static List<CurrencyList> currencyList = [];


  ///Data format
  static String quantityFormat='';
  static String quantityNtFormat='';
  static String amountFormat='';
  static String amountNtFormat='';
  static String rateFormat='';

  /// List user permission
  // Menu
  static bool dashBroad = false;
  static bool erp = false;
  static bool dms = false;
  static bool hr = false;
  static bool menu = false;
  // Parent Menu
  // Menu
  static bool report = false;
  static bool approval = false;
  static bool setting = false;
  static bool notification = false;
  static bool reportHome = false;

  static bool banner = false;
  static bool createNewOrder = false;
  static bool historyOrder = false;
  static bool transportation = false;
  static bool customer = false;
  static bool production = false;
  static bool deliveryPlan = false;
  static bool updateDeliveryPlan = false;
  static bool stageStatistic = false;

  static bool timeKeeping = false;
  static bool checkIn = false;
  static bool createNewWork = false;
  static bool workAssigned = false;
  static bool myWork = false;
  static bool workInvolved = false;
  static bool onLeave = false;
  static bool recommendSpending = false;
  static bool articleCar = false;
  static bool shippingProduct = false;
  static bool confirmShippingProduct = false;

  static bool cacheAllowed = false;
  static bool allowedConfirm = false;


  static List<String> kColorForAlphaA = ['P','Q','R','S','T','U','V','W','X','Y','Z'];
  static List<ColorForAlphaB> kColorForAlphaB = [
    ColorForAlphaB('A',Color(0xff451599)),
    ColorForAlphaB('B',Color(0xff7e0cde)),
    ColorForAlphaB('C',Color(0xff2f7135)),
    ColorForAlphaB('D',Color(0xff1f3df1)),
    ColorForAlphaB('E',Color(0xff21a304)),
    ColorForAlphaB('F',Color(0xff9a2e2e)),
    ColorForAlphaB('G',Color(0xff490353)),
    ColorForAlphaB('H',Color(0xff03299a)),
    ColorForAlphaB('I',Color(0xff166c05)),
    ColorForAlphaB('J',Color(0xff533a80)),
    ColorForAlphaB('K',Color(0xff8cbb43)),
    ColorForAlphaB('L',Color(0xff845724)),
    ColorForAlphaB('M',Color(0xff0fdb19)),
    ColorForAlphaB('N',Color(0xff2907db)),
    ColorForAlphaB('O',Color(0xff0449d5)),
    ColorForAlphaB('P',Color(0xffe0591a)),
    ColorForAlphaB('Q',Color(0xff4d4fad)),
    ColorForAlphaB('R',Color(0xff03ef07)),
    ColorForAlphaB('S',Color(0xffad184b)),
    ColorForAlphaB('T',Color(0xffc1be88)),
    ColorForAlphaB('U',Color(0xff3a4e80)),
    ColorForAlphaB('V',Color(0xff3a805a)),
    ColorForAlphaB('W',Color(0xff3a8076)),
    ColorForAlphaB('X',Color(0xff0370d2)),
    ColorForAlphaB('Y',Color(0xff129303)),
    ColorForAlphaB('Z',Color(0xff3a8068)),
  ];
}

const kTitleKey = Key('FLUTTER_LOGIN_TITLE');
// const kRecoverPasswordIntroKey = Key('RECOVER_PASSWORD_INTRO');
// const kRecoverPasswordDescriptionKey = Key('RECOVER_PASSWORD_DESCRIPTION');
// const kDebugToolbarKey = Key('DEBUG_TOOLBAR');

const kMinLogoHeight = 50.0; // hide logo if less than this
const kMaxLogoHeight = 125.0;

const TextStyle headerTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  //fontFamily: SizeConfig.montesseratFontFamily););
);