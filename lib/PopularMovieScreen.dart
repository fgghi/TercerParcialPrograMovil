import 'package:flutter/material.dart';
import 'package:flutter_application_1/practicaAPI.dart';
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieService {
  final Dio dio = Dio();
  final String apiKey = 'fa3e844ce31744388e07fa47c7c5d8c3';

  Future<List<Movie>> getPopularMovies() async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=$apiKey');

    List<dynamic> results = response.data['results'];

    List<Movie> movies = results.map((result) => Movie.fromJson(result)).toList();

    return movies;
  }
}


class PopularMoviesScreen extends StatefulWidget {
  @override
  _PopularMoviesScreenState createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  final MovieService movieService = MovieService();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _useFingerprint = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFingerprintPreference();
  }

  void _loadFingerprintPreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool useFingerprint = prefs.getBool('useFingerprint') ?? false;
    setState(() {
      _useFingerprint = useFingerprint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Populares'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<List<Movie>>(
            future: movieService.getPopularMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Movie>? movies = snapshot.data;

                return Expanded(
                  child: ListView.builder(
                    itemCount: movies?.length,
                    itemBuilder: (context, index) {
                      Movie movie = movies![index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text('Puntuación: ${movie.voteAverage.toStringAsFixed(1)}'),
                      );
                    },
                  ),
                );
              }
            },
          ),
          // Sección de preferencias
          ListTile(
            title: Text('Usar Autenticación por Huella Digital'),
            trailing: Switch(
              value: _useFingerprint,
              onChanged: (newValue) {
                _toggleFingerprint(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFingerprint(bool newValue) async {
    if (newValue) {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        setState(() {
          _useFingerprint = true;
        });

        // Guardar el estado en las preferencias
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('useFingerprint', true);

        // Mostrar un mensaje cuando se habilita la autenticación por huella digital
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Autenticación por Huella Digital habilitada'),
              content: Text('La autenticación por huella digital se utilizará en el inicio de sesión.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else {
        // Muestra un mensaje de que no hay autenticación por huella digital disponible.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Autenticación por Huella Digital no disponible'),
              content: Text('Tu dispositivo no es compatible con la autenticación por huella digital.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _useFingerprint = false;
      });

      // Guardar el estado en las preferencias
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('useFingerprint', false);
    }
  }

  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    bool useFingerprint = _useFingerprint;

    if (useFingerprint) {
      bool authenticated = await _authenticateWithFingerprint();

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PopularMoviesScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Autenticación por Huella Digital fallida'),
              content: Text('No se pudo autenticar con huella digital. Por favor, intenta nuevamente o usa la autenticación por correo y contraseña.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Continuar con la autenticación por correo y contraseña
      // ...
    }
  }

  Future<bool> _authenticateWithFingerprint() async {
    // Implementa la autenticación por huella digital aquí
    // Retorna true si la autenticación fue exitosa, de lo contrario, retorna false
    return false; // Cambia esto con la lógica real de autenticación por huella digital
  }
}
