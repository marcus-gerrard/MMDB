import 'package:json_annotation/json_annotation.dart';

part 'full_movie.g.dart';

@JsonSerializable()
class FullMovie {
  final int id;
  final String title;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'backdrop_path')
  final String backdropPath;
  final double budget;
  final List<dynamic> genres;
  @JsonKey(name: 'production_companies')
  final List<dynamic> productionCompanies;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  final double revenue;
  final double runtime;
  final String tagline;
  @JsonKey(name: 'vote_count')
  final double voteCount;

  FullMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.productionCompanies,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.tagline,
    required this.voteCount,
  });

  factory FullMovie.fromJson(Map<String, dynamic> json) => _$FullMovieFromJson(json);
  Map<String, dynamic> toJson() => _$FullMovieToJson(this);
}
