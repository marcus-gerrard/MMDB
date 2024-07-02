// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullMovie _$FullMovieFromJson(Map<String, dynamic> json) => FullMovie(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      backdropPath: json['backdrop_path'] as String,
      budget: (json['budget'] as num).toDouble(),
      genres: json['genres'] as List<dynamic>,
      productionCompanies: json['production_companies'] as List<dynamic>,
      releaseDate: json['release_date'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      runtime: (json['runtime'] as num).toDouble(),
      tagline: json['tagline'] as String,
      voteCount: (json['vote_count'] as num).toDouble(),
    );

Map<String, dynamic> _$FullMovieToJson(FullMovie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'backdrop_path': instance.backdropPath,
      'budget': instance.budget,
      'genres': instance.genres,
      'production_companies': instance.productionCompanies,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'tagline': instance.tagline,
      'vote_count': instance.voteCount,
    };
