import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mmdb/app_state.dart';
import 'package:mmdb/models/actor.dart';
import 'package:mmdb/models/full_movie.dart';
import '../models/movie.dart';

class TMDBApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = AppState.tmdbKey;

  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/trending/movie/week?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['results'];
      List<Movie> movies =
          body.map((dynamic item) => Movie.fromJson(item)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Actor>> fetchTrendingActors() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/trending/person/week?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['results'];
      List<Actor> actors =
          body.map((dynamic item) => Actor.fromJson(item)).toList();

      return actors;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<FullMovie> fetchFullMovieByID(int id) async {
    final uri =
        Uri.https('api.themoviedb.org', '/3/movie/$id', {'api_key': _apiKey});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      FullMovie movie = FullMovie.fromJson(json.decode(response.body));
      return movie;
    } else {
      throw Exception('Failed to load movie');
    }
  }
}
