import 'package:flutter/material.dart';
import '../constants/colors.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.child}) : super(key: key) ;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const appTitle = "Decharge App";
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: AppColors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: child,
      ),
    );
  }
}
