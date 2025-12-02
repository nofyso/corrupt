// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_school_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermData _$TermDataFromJson(Map<String, dynamic> json) => TermData(
  json['academicYear'] as String,
  json['semester'] as String,
  DateTime.parse(json['theFirstDay'] as String),
);

Map<String, dynamic> _$TermDataToJson(TermData instance) => <String, dynamic>{
  'academicYear': instance.academicYear,
  'semester': instance.semester,
  'theFirstDay': instance.theFirstDay.toIso8601String(),
};
