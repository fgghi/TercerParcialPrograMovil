import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginScreen.dart';

void main() async {
   runApp(MyApp());
 }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieApp(),
    );
  }
}
