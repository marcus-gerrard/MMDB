import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  final int id;
  final String name;
  @JsonKey(name: 'profile_path')
  final String profilePath;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
}