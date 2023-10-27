import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginScreen.dart';
import 'package:flutter_application_1/PopularMovieScreen.dart';

void main() async {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      //home: PopularMoviesScreen() // O PopularMoviesScreen() para iniciar con la pantalla de películas populares
    );
  }
}
