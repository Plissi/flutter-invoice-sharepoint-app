import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:transmission_facture_client/pages/home.dart';
import 'package:transmission_facture_client/pages/login.dart';

Future<void> main() async {
  await dotenv.load();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = "Decharge App";
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:(MemoryCache.instance.contains("token") == true && DateTime.now().isBefore(DateTime.parse(MemoryCache.instance.read("expiration"))) == true)
                ?const Home()
                :const Login()
          ),
        ),
      ),
    );
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
