import 'package:dartlin/control_flow.dart';
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_table_entity.g.dart';

@JsonSerializable()
class ClassEntity {
  final String name;
  final String teacher;
  final DayOfWeek dayOfWeek;

  /// Start at 0
  final int time;
  final int duration;

  /// Start at 0
  final List<int> weeks;
  final String place;
  final bool user;

  ClassEntity(
    this.name,
    this.teacher,
    this.dayOfWeek,
    this.time,
    this.duration,
    this.weeks,
    this.place,
    this.user,
  );

  factory ClassEntity.fromJson(Map<String, dynamic> json) => _$ClassEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClassEntityToJson(this);
}

@JsonSerializable()
class ClassTable {
  final String academicYear;
  final String semester;
  final List<ClassEntity> classes;

  ClassTable(this.academicYear, this.semester, this.classes);

  factory ClassTable.fromJson(Map<String, dynamic> json) => _$ClassTableFromJson(json);

  Map<String, dynamic> toJson() => _$ClassTableToJson(this);
}

enum DayOfWeek {
  mon(0),
  tue(1),
  wed(2),
  thu(3),
  fri(4),
  sat(5),
  sun(6);

  final int value;

  const DayOfWeek(this.value);

  static DayOfWeek? valueOf(int serial) =>
      DayOfWeek.values.filter((it) => it.value == serial).firstOrNull;

  static DayOfWeek fromDateTime(int dateTimeWeekDay) => switch (dateTimeWeekDay) {
    DateTime.monday => DayOfWeek.mon,
    DateTime.tuesday => DayOfWeek.tue,
    DateTime.wednesday => DayOfWeek.wed,
    DateTime.thursday => DayOfWeek.thu,
    DateTime.friday => DayOfWeek.fri,
    DateTime.saturday => DayOfWeek.sat,
    DateTime.sunday => DayOfWeek.sun,
    _ => throw Exception(""),
  };

  static DayOfWeek? chineseValueOf(String char) => switch (char) {
    "一" => DayOfWeek.mon,
    "二" => DayOfWeek.tue,
    "三" => DayOfWeek.wed,
    "四" => DayOfWeek.thu,
    "五" => DayOfWeek.fri,
    "六" => DayOfWeek.sat,
    "日" => DayOfWeek.sun,
    _ => null,
  };
}

@JsonSerializable()
class ClassTime {
  final List<(int fromTime, int toTime)> times;

  ClassTime(this.times);

  factory ClassTime.fromJson(Map<String, dynamic> json) => _$ClassTimeFromJson(json);

  Map<String, dynamic> toJson() => _$ClassTimeToJson(this);

  ClassTime.of(List<(int fromHour, int fromMinute)> timeList, int duration)
    : this(
        timeList
            .map(
              (it) =>
                  ((it.$1 * 60 * 60 + it.$2 * 60) * 1000).let((time) => (time, time + duration)),
            )
            .toList(),
      );
}

@JsonSerializable()
class AvailableTermTime {
  final List<(String displayValue, String dataValue)> availableAcademicYear;
  final List<(String displayValue, String dataValue)> availableSemester;

  AvailableTermTime(this.availableAcademicYear, this.availableSemester);

  factory AvailableTermTime.fromJson(Map<String, dynamic> json) =>
      _$AvailableTermTimeFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableTermTimeToJson(this);
}
