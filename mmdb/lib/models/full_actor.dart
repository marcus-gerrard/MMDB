class FullActor {
  final int id;
  final String name;
  final String profilePath;
  final String birthday;
  final String? deathday;
  final List<dynamic> aliases;
  final String knownFor;
  final int gender;
  final String biography;
  final double popularity;
  final String placeOfBirth;
  final List<MovieCastCredit> movieCastCredits;
  final List<MovieCrewCredit> movieCrewCredits;
  final List<TelevisionCastCredit> televisionCastCredits;
  final List<TelevisionCrewCredit> televisionCrewCredits;

  FullActor({
    required this.id,
    required this.knownFor,
    required this.name,
    required this.profilePath,
    required this.aliases,
    required this.biography,
    required this.birthday,
    required this.movieCastCredits,
    required this.movieCrewCredits,
    required this.televisionCastCredits,
    required this.televisionCrewCredits,
    required this.deathday,
    required this.gender,
    required this.placeOfBirth,
    required this.popularity,
  });

  factory FullActor.fromJson(Map<String, dynamic> bodyContents,
      Map<String, dynamic> movieCredits, Map<String, dynamic> tvCredits) {
    return FullActor(
      id: bodyContents['id'],
      knownFor: bodyContents['known_for_department'],
      name: bodyContents['name'],
      profilePath: bodyContents['profile_path'],
      aliases: bodyContents['also_known_as'] as List<dynamic>,
      biography: bodyContents['biography'],
      birthday: bodyContents['birthday'],
      deathday: bodyContents['deathday'],
      gender: bodyContents['gender'],
      placeOfBirth: bodyContents['place_of_birth'],
      popularity: bodyContents['popularity'],
      movieCastCredits: movieCredits.containsKey('cast')
          ? movieCredits['cast'].map<MovieCastCredit>((item) {
              return MovieCastCredit.fromJson(item);
            }).toList()
          : [],
      movieCrewCredits: movieCredits.containsKey('crew')
          ? movieCredits['crew'].map<MovieCrewCredit>((item) {
              return MovieCrewCredit.fromJson(item);
            }).toList()
          : [],
      televisionCastCredits: tvCredits.containsKey('cast')
          ? tvCredits['cast'].map<TelevisionCastCredit>((item) {
              return TelevisionCastCredit.fromJson(item);
            }).toList()
          : [],
      televisionCrewCredits: tvCredits.containsKey('crew')
          ? tvCredits['crew'].map<TelevisionCrewCredit>((item) {
              return TelevisionCrewCredit.fromJson(item);
            }).toList()
          : [],
    );
  }
}

class MovieCastCredit {
  MovieCastCredit({
    required this.id,
    required this.characterName,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  final int id;
  final String characterName;
  final String title;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;

  factory MovieCastCredit.fromJson(Map<String, dynamic> json) {
    return MovieCastCredit(
      id: json['id'],
      releaseDate: json['release_date'],
      characterName: json['character'],
      title: json['title'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'],
    );
  }
}

class MovieCrewCredit {
  MovieCrewCredit({
    required this.releaseDate,
    required this.title,
    required this.posterPath,
    required this.id,
    required this.job,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;
  final String job;
  final double voteAverage;

  factory MovieCrewCredit.fromJson(Map<String, dynamic> json) {
    return MovieCrewCredit(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
      job: json['job'],
      voteAverage: json['vote_average'],
    );
  }
}

class TelevisionCastCredit {
  TelevisionCastCredit({
    required this.releaseDate,
    required this.title,
    required this.posterPath,
    required this.episodeCount,
    required this.id,
    required this.voteAverage,
    required this.character,
  });

  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;
  final int episodeCount;
  final double voteAverage;
  final String character;

  factory TelevisionCastCredit.fromJson(Map<String, dynamic> json) {
    return TelevisionCastCredit(
      id: json['id'],
      title: json['name'],
      releaseDate: json['first_air_date'],
      posterPath: json['poster_path'],
      episodeCount: json['episode_count'],
      voteAverage: json['vote_average'],
      character: json['character'],
    );
  }
}

class TelevisionCrewCredit {
  TelevisionCrewCredit({
    required this.releaseDate,
    required this.title,
    required this.posterPath,
    required this.episodeCount,
    required this.id,
    required this.job,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;
  final int episodeCount;
  final String job;
  final double voteAverage;

  factory TelevisionCrewCredit.fromJson(Map<String, dynamic> json) {
    return TelevisionCrewCredit(
      id: json['id'],
      title: json['name'],
      releaseDate: json['first_air_date'],
      posterPath: json['poster_path'],
      episodeCount: json['episode_count'],
      job: json['job'],
      voteAverage: json['vote_average'],
    );
  }
}
