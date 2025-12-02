import 'package:json_annotation/json_annotation.dart';

part 'exam_entity.g.dart';

@JsonSerializable()
class ExamsEntity {
  final String academicYear;
  final String semester;
  final List<ExamEntity> entities;

  ExamsEntity({required this.academicYear, required this.semester, required this.entities});

  factory ExamsEntity.fromJson(Map<String, dynamic> json) => _$ExamsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ExamsEntityToJson(this);
}

@JsonSerializable()
class ExamEntity {
  final String classId;
  final String name;
  final String studentName;
  final DateTime? fromTime;
  final DateTime? toTime;
  final String place;
  final String form;
  final String seat;
  final String campus;

  ExamEntity({
    required this.classId,
    required this.name,
    required this.studentName,
    required this.fromTime,
    required this.toTime,
    required this.place,
    required this.form,
    required this.seat,
    required this.campus,
  });

  factory ExamEntity.fromJson(Map<String, dynamic> json) => _$ExamEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ExamEntityToJson(this);
}
