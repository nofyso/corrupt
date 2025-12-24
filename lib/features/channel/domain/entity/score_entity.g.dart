// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoresEntity _$ScoresEntityFromJson(Map<String, dynamic> json) => ScoresEntity(
  academicYear: json['academicYear'] as String,
  semester: json['semester'] as String,
  entities: (json['entities'] as List<dynamic>)
      .map((e) => ScoreEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScoresEntityToJson(ScoresEntity instance) =>
    <String, dynamic>{
      'academicYear': instance.academicYear,
      'semester': instance.semester,
      'entities': instance.entities,
    };

ScoreEntity _$ScoreEntityFromJson(Map<String, dynamic> json) => ScoreEntity(
  year: json['year'] as String,
  term: json['term'] as String,
  classId: json['classId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  belong: json['belong'] as String,
  score: json['score'] as String,
  credit: json['credit'] as String,
  gp: json['gp'] as String,
  place: json['place'] as String,
  note: json['note'] as String,
  elective: json['elective'] as bool,
);

Map<String, dynamic> _$ScoreEntityToJson(ScoreEntity instance) =>
    <String, dynamic>{
      'year': instance.year,
      'term': instance.term,
      'classId': instance.classId,
      'name': instance.name,
      'type': instance.type,
      'belong': instance.belong,
      'score': instance.score,
      'credit': instance.credit,
      'gp': instance.gp,
      'place': instance.place,
      'note': instance.note,
      'elective': instance.elective,
    };
