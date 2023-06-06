import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transmission_facture_client/pages/home.dart';
import 'package:transmission_facture_client/pages/login.dart';
import 'package:transmission_facture_client/pages/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  await dotenv.load();
  HttpOverrides.global = MyHttpOverrides();

  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var _expirationString = sharedPreferences.getString("expiration");
    if (_expirationString != null){
      var _expiration = DateTime.parse(_expirationString);
      var _tokenIsValid =  DateTime.now().isBefore(_expiration);
      if (_tokenIsValid){
        return const Home(child: MainScreen());
      }
      sharedPreferences.remove("token");
      sharedPreferences.remove("expiration");
      return const Home(child: Login());
    }
    return const Home(child: Login());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
