import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sse/screen/login/login_screen.dart';

import 'model/database/dbhelper.dart';
import 'model/entity/info_login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final key = ValueKey('my overlay');
  DatabaseHelper db = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getListFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      key: key,
      child: OKToast(
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('vi', 'VN'),
            // arabic, no country code
          ],
          title: 'Flutter Demo',
          theme: ThemeData(
            visualDensity:  VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          // initialRoute: RouterGenerator.routeIntro,
          home:LoginScreen(),//InfoCPNScreen
        ),
      ),
    );
  }

  Future<List<InfoLogin>> getListFromDb() {
    return db.fetchAllInfoLogin();
  }
}