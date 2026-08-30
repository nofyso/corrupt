// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_school_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermData _$TermDataFromJson(Map<String, dynamic> json) => TermData(
  $enumDecode(_$SchoolEnumMap, json['belonging']),
  json['academicYear'] as String,
  json['semester'] as String,
  DateTime.parse(json['theFirstDay'] as String),
);

Map<String, dynamic> _$TermDataToJson(TermData instance) => <String, dynamic>{
  'belonging': _$SchoolEnumMap[instance.belonging]!,
  'academicYear': instance.academicYear,
  'semester': instance.semester,
  'theFirstDay': instance.theFirstDay.toIso8601String(),
};

const _$SchoolEnumMap = {
  School.fafu: 'fafu',
  School.mju: 'mju',
  School.fjut: 'fjut',
  School.none: 'none',
};
