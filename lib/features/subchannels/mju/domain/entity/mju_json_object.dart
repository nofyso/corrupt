import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:dartlin/collections.dart';
import 'package:dartlin/control_flow.dart';
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mju_json_object.g.dart';

@JsonSerializable()
class MjuLoginPublicKey {
  String modulus;
  String exponent;

  MjuLoginPublicKey(this.modulus, this.exponent);

  factory MjuLoginPublicKey.fromJson(Map<String, dynamic> json) =>
      _$MjuLoginPublicKeyFromJson(json);

  Map<String, dynamic> toJson() => _$MjuLoginPublicKeyToJson(this);
}

@JsonSerializable()
class MjuClassEntry {
  @JsonKey(name: "kcmc")
  final String name;
  @JsonKey(name: "xqmc")
  final String place;
  @JsonKey(name: "cdmc")
  final String classroom;
  @JsonKey(name: "xm")
  final String teacher;
  @JsonKey(name: "xqj")
  final String dayOfWeek;
  @JsonKey(name: "zcd")
  final String weeks;
  @JsonKey(name: "jcs")
  final String classTime;

  MjuClassEntry(
    this.name,
    this.place,
    this.classroom,
    this.teacher,
    this.dayOfWeek,
    this.weeks,
    this.classTime,
  );

  factory MjuClassEntry.fromJson(Map<String, dynamic> json) => _$MjuClassEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MjuClassEntryToJson(this);

  ClassEntity toClassEntity() {
    final (fromTime, toTime) = classTime
        .split("-")
        .let((it) => (int.parse(it[0]), int.parse(it[1])));
    final weeksArray = weeks
        .split(",")
        .flatMap((it) {
          final singleWeeks = it.contains("(单)");
          final doubleWeeks = it.contains("(双)");
          return it
              .replaceAll("(单)", "")
              .replaceAll("(双)", "")
              .replaceAll("周", "")
              .split("-")
              .let(
                (s) =>
                    s.length == 1 ? [int.parse(s.first)] : int.parse(s.first).to(int.parse(s.last)),
              )
              .filter((it) => !(singleWeeks && it % 2 == 0))
              .filter((it) => !(doubleWeeks && it % 2 != 0));
        })
        .map((it) => it - 1)
        .toList(growable: false);
    final dow = DayOfWeek.valueOf(int.parse(dayOfWeek) % 7)!;
    return ClassEntity(
      name,
      teacher,
      dow,
      fromTime - 1,
      toTime - fromTime + 1,
      weeksArray.map((it) => dow == DayOfWeek.sun ? it + 1 : it).toList(),
      "$place $classroom",
      false,
    );
  }
}

@JsonSerializable()
class MjuExamEntity {
  @JsonKey(name: "kcmc")
  final String name;
  @JsonKey(name: "kssj")
  final String? timeRaw;
  @JsonKey(name: "cdmc")
  final String? room;
  @JsonKey(name: "zwh")
  final String? seat;
  @JsonKey(name: "kch")
  final String? classId;
  @JsonKey(name: "xm")
  final String? studentName;
  @JsonKey(name: "cdxqmc")
  final String? campus;
  @JsonKey(name: "ksfs")
  final String? form;

  factory MjuExamEntity.fromJson(Map<String, dynamic> json) => _$MjuExamEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MjuExamEntityToJson(this);

  MjuExamEntity(
    this.name,
    this.timeRaw,
    this.room,
    this.seat,
    this.classId,
    this.studentName,
    this.campus,
    this.form,
  );

  (DateTime, DateTime)? _tryParseTime() {
    if (timeRaw == null) return null;
    if (timeRaw!.length != 23) return null;
    final (year, month, day) = timeRaw!
        .substring(0, 10)
        .split("-")
        .let((it) => (int.parse(it[0]), int.parse(it[1]), int.parse(it[2])));
    final (fromTime, toTime) = timeRaw!
        .substring(11, 22)
        .split("-")
        .map((it) => it.split(":").let((a) => (int.parse(a[0]), int.parse(a[1]))))
        .toList()
        .let((it) => (it[0], it[1]));
    return (
      DateTime(year, month, day, fromTime.$1, fromTime.$2),
      DateTime(year, month, day, toTime.$1, toTime.$2),
    );
  }

  ExamEntity toExamEntity() {
    final (fromTime, toTime) = _tryParseTime() ?? (null, null);
    return ExamEntity(
      classId: classId ?? "/",
      name: name,
      studentName: studentName ?? "/",
      fromTime: fromTime,
      toTime: toTime,
      place: room ?? "/",
      form: form ?? "/",
      seat: seat ?? "/",
      campus: campus ?? "/",
    );
  }
}
