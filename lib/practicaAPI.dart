import 'package:dio/dio.dart';

class Movie {
  final int id;
  final String title;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}

class MovieService {
  final Dio dio = Dio();
  final String apiKey = 'fa3e844ce31744388e07fa47c7c5d8c3';

  Future<List<Movie>> getPopularMovies() async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=$apiKey');
    return response.data['results'];
  }
}
