import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mmdb/app_state.dart';
import 'package:mmdb/models/actor.dart';
import 'package:mmdb/models/full_actor.dart';
import 'package:mmdb/models/full_movie.dart';
import 'package:mmdb/models/movie_credits.dart';
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

  Future<FullActor> fetchActor(int actorID) async {
    final String actorURL = '$_baseUrl/person/$actorID?api_key=$_apiKey';

    final String movieCreditsURL =
        '$_baseUrl/person/$actorID/movie_credits?api_key=$_apiKey';

    final String tvCreditsURL =
        '$_baseUrl/person/$actorID/tv_credits?api_key=$_apiKey';

    final responses = await Future.wait([
      http.get(Uri.parse(actorURL)),
      http.get(Uri.parse(movieCreditsURL)),
      http.get(Uri.parse(tvCreditsURL)),
    ]);

    if (responses.any((element) => element.statusCode != 200)) {
      throw Exception('Failed to load actor');
    }

    var actorContents = json.decode(responses[0].body);
    var movieCredits = json.decode(responses[1].body);
    var tvCredits = json.decode(responses[2].body);

    return FullActor.fromJson(actorContents, movieCredits, tvCredits);
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

  Future<MovieCredits> fetchCredits(int movieId) async {
    final uri = Uri.https('api.themoviedb.org', '/3/movie/$movieId/credits',
        {'api_key': _apiKey});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> cast = json.decode(response.body)['cast'];
      List<dynamic> crew = json.decode(response.body)['crew'];

      List<CastMember> castList =
          cast.map((item) => CastMember.fromJson(item)).toList();

      List<CrewMember> crewList =
          crew.map((item) => CrewMember.fromJson(item)).toList();

      Map<String, List<CastMember>> castMap = {};
      Map<String, List<CrewMember>> crewMap = {};

      for (CastMember member in castList) {
        String key = member.department;

        if (castMap.containsKey(key)) {
          castMap[key]!.add(member);
        } else {
          castMap[key] = [member];
        }
      }

      for (CrewMember member in crewList) {
        String key = member.department;

        if (crewMap.containsKey(key)) {
          crewMap[key]!.add(member);
        } else {
          crewMap[key] = [member];
        }
      }
      return MovieCredits(cast: castMap, crew: crewMap);
    } else {
      throw Exception('Failed to load cast and crew');
    }
  }
}
