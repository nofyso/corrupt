// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsEntity _$ExamsEntityFromJson(Map<String, dynamic> json) => ExamsEntity(
  academicYear: json['academicYear'] as String,
  semester: json['semester'] as String,
  entities: (json['entities'] as List<dynamic>)
      .map((e) => ExamEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamsEntityToJson(ExamsEntity instance) => <String, dynamic>{
  'academicYear': instance.academicYear,
  'semester': instance.semester,
  'entities': instance.entities,
};

ExamEntity _$ExamEntityFromJson(Map<String, dynamic> json) => ExamEntity(
  classId: json['classId'] as String,
  name: json['name'] as String,
  studentName: json['studentName'] as String,
  fromTime: json['fromTime'] == null ? null : DateTime.parse(json['fromTime'] as String),
  toTime: json['toTime'] == null ? null : DateTime.parse(json['toTime'] as String),
  place: json['place'] as String,
  form: json['form'] as String,
  seat: json['seat'] as String,
  campus: json['campus'] as String,
);

Map<String, dynamic> _$ExamEntityToJson(ExamEntity instance) => <String, dynamic>{
  'classId': instance.classId,
  'name': instance.name,
  'studentName': instance.studentName,
  'fromTime': instance.fromTime?.toIso8601String(),
  'toTime': instance.toTime?.toIso8601String(),
  'place': instance.place,
  'form': instance.form,
  'seat': instance.seat,
  'campus': instance.campus,
};
