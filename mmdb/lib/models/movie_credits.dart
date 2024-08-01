class MovieCredits {
  MovieCredits({
    required this.cast,
    required this.crew,
  });

  final Map<String, List<CastMember>> cast;
  final Map<String, List<CrewMember>> crew;
}

class CastMember {
  CastMember(
      {required this.id,
      required this.department,
      required this.name,
      required this.profilePath,
      required this.character,
      required this.popularity});

  final int id;
  final String department;
  final String name;
  final String? profilePath;
  final String character;
  final double popularity;

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
        id: json['id'],
        department: json['known_for_department'],
        name: json['name'],
        profilePath: json['profile_path'],
        character: json['character'],
        popularity: json['popularity']);
  }
}

class CrewMember {
  CrewMember({
    required this.id,
    required this.department,
    required this.name,
    required this.profilePath,
    required this.popularity,
  });

  final int id;
  final String department;
  final String name;
  final String? profilePath;
  final double popularity;

  factory CrewMember.fromJson(Map<String, dynamic> json) {
    return CrewMember(
      id: json['id'],
      department: json['job'],
      name: json['name'],
      profilePath: json['profile_path'],
      popularity: json['popularity'],
    );
  }
}
