import 'package:json_annotation/json_annotation.dart';

part 'score_entity.g.dart';

@JsonSerializable()
class ScoresEntity {
  final String academicYear;
  final String semester;
  final List<ScoreEntity> entities;

  ScoresEntity({required this.academicYear, required this.semester, required this.entities});

  factory ScoresEntity.fromJson(Map<String, dynamic> json) => _$ScoresEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ScoresEntityToJson(this);
}

@JsonSerializable()
class ScoreEntity {
  String year;
  String term;
  String classId;
  String name;
  String type;
  String belong;
  String score;
  String credit;
  String gp;
  String place;
  String note;
  bool elective;

  ScoreEntity({
    required this.year,
    required this.term,
    required this.classId,
    required this.name,
    required this.type,
    required this.belong,
    required this.score,
    required this.credit,
    required this.gp,
    required this.place,
    required this.note,
    required this.elective,
  });

  factory ScoreEntity.fromJson(Map<String, dynamic> json) => _$ScoreEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreEntityToJson(this);
}
