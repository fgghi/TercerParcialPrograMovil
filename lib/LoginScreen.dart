import 'package:flutter/material.dart';
import 'package:flutter_application_1/PopularMovieScreen.dart';
import 'package:flutter_application_1/practica.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    bool isSignedIn = await authService.signInWithEmailAndPassword(email, password);

    if (isSignedIn) {
      // Inicio de sesión correcto, navega a MovieScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PopularMoviesScreen()),
      );
    } else {
      // Muestra mensaje de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _signIn(context), // Pasa el contexto como argumento
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
