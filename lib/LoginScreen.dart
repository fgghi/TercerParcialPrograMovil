import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie(this.id, this.title, this.posterPath);
}

class MovieRepository {
  final Dio dio = Dio();

  Future<List<Movie>> fetchMovies() async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3');
    if (response.statusCode == 200) {
      final data = response.data;
      final results = data['results'] as List;
      return results
          .map((movieData) => Movie(
                movieData['id'],
                movieData['title'],
                movieData['poster_path'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class TicketBloc extends Cubit<int> {
  TicketBloc() : super(0);

  void increment() => emit(state + 1);

  void decrement() {
    if (state > 0) {
      emit(state - 1);
    }
  }
}

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  final MovieRepository movieRepository = MovieRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider<MovieRepository>(create: (_) => movieRepository),
          Provider<MovieDropdown>(create: (_) => MovieDropdown()),
          BlocProvider<TicketBloc>(create: (_) => TicketBloc()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('CineApp'),
          ),
          body: Column(
            children: [
              MovieDropdown(),
              TicketCounter(),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDropdown extends StatefulWidget {
  get movies => null;

  get selectedMovieIndex => null;

  @override
  _MovieDropdownState createState() => _MovieDropdownState();
}

class _MovieDropdownState extends State<MovieDropdown> {
  int selectedMovieIndex = 0;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final movieRepository = context.read<MovieRepository>();
    try {
      final movieList = await movieRepository.fetchMovies();
      setState(() {
        movies = movieList;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          value: selectedMovieIndex,
          items: movies
              .asMap()
              .entries
              .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value.title),
                  ))
              .toList(),
          onChanged: (index) {
            setState(() {
              selectedMovieIndex = index!;
            });
          },
        ),
        if (movies.isNotEmpty &&
            selectedMovieIndex >= 0 &&
            selectedMovieIndex < movies.length)
          Image.network(
            'https://image.tmdb.org/t/p/w500/${movies[selectedMovieIndex].posterPath}',
            height: 200,
          )
        else
          Text('No hay poster disponible'),
      ],
    );
  }
}

class TicketCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TicketBloc, int>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<TicketBloc>().increment();
                  },
                  child: Icon(Icons.add),
                ),
                Text('$state'),
                ElevatedButton(
                  onPressed: () {
                    context.read<TicketBloc>().decrement();
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            );
          },
        ),
        ElevatedButton(
        onPressed: () {
            final movieDropdown =Movie(5, 'title', 'posterPath');
            final ticketBloc = 10;
            final movie = movieDropdown;
            final ticketCount = ticketBloc;
            final totalPrice = ticketCount * 30;

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Resumen de Compra'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Película: ${movie.title}'),
                      Text('Cantidad de Entradas: $ticketCount'),
                      Text('Precio Total: $totalPrice Bs.'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Confirmar'),
                    ),
                  ],
                );
              },
            );
          } ,
        child: Text('Confirmar Cantidad de Entradas'),
      ),
      ],
    );
  }
}
