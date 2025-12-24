// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_table_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassEntity _$ClassEntityFromJson(Map<String, dynamic> json) => ClassEntity(
  json['name'] as String,
  json['teacher'] as String,
  $enumDecode(_$DayOfWeekEnumMap, json['dayOfWeek']),
  (json['time'] as num).toInt(),
  (json['duration'] as num).toInt(),
  (json['weeks'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  json['place'] as String,
  json['user'] as bool,
);

Map<String, dynamic> _$ClassEntityToJson(ClassEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'teacher': instance.teacher,
      'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek]!,
      'time': instance.time,
      'duration': instance.duration,
      'weeks': instance.weeks,
      'place': instance.place,
      'user': instance.user,
    };

const _$DayOfWeekEnumMap = {
  DayOfWeek.sun: 'sun',
  DayOfWeek.mon: 'mon',
  DayOfWeek.tue: 'tue',
  DayOfWeek.wed: 'wed',
  DayOfWeek.thu: 'thu',
  DayOfWeek.fri: 'fri',
  DayOfWeek.sat: 'sat',
};

ClassTable _$ClassTableFromJson(Map<String, dynamic> json) => ClassTable(
  json['academicYear'] as String,
  json['semester'] as String,
  (json['classes'] as List<dynamic>)
      .map((e) => ClassEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassTableToJson(ClassTable instance) =>
    <String, dynamic>{
      'academicYear': instance.academicYear,
      'semester': instance.semester,
      'classes': instance.classes,
    };

ClassTime _$ClassTimeFromJson(Map<String, dynamic> json) => ClassTime(
  (json['times'] as List<dynamic>)
      .map(
        (e) => _$recordConvert(
          e,
          ($jsonValue) => (
            ($jsonValue[r'$1'] as num).toInt(),
            ($jsonValue[r'$2'] as num).toInt(),
          ),
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ClassTimeToJson(ClassTime instance) => <String, dynamic>{
  'times': instance.times
      .map((e) => <String, dynamic>{r'$1': e.$1, r'$2': e.$2})
      .toList(),
};

$Rec _$recordConvert<$Rec>(Object? value, $Rec Function(Map) convert) =>
    convert(value as Map<String, dynamic>);

AvailableTermTime _$AvailableTermTimeFromJson(Map<String, dynamic> json) =>
    AvailableTermTime(
      (json['availableAcademicYear'] as List<dynamic>)
          .map(
            (e) => _$recordConvert(
              e,
              ($jsonValue) =>
                  ($jsonValue[r'$1'] as String, $jsonValue[r'$2'] as String),
            ),
          )
          .toList(),
      (json['availableSemester'] as List<dynamic>)
          .map(
            (e) => _$recordConvert(
              e,
              ($jsonValue) =>
                  ($jsonValue[r'$1'] as String, $jsonValue[r'$2'] as String),
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$AvailableTermTimeToJson(AvailableTermTime instance) =>
    <String, dynamic>{
      'availableAcademicYear': instance.availableAcademicYear
          .map((e) => <String, dynamic>{r'$1': e.$1, r'$2': e.$2})
          .toList(),
      'availableSemester': instance.availableSemester
          .map((e) => <String, dynamic>{r'$1': e.$1, r'$2': e.$2})
          .toList(),
    };
