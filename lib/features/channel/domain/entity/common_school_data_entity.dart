import 'package:json_annotation/json_annotation.dart';

part 'common_school_data_entity.g.dart';

@JsonSerializable()
class TermData {
  final String academicYear;
  final String semester;
  final DateTime theFirstDay;

  TermData(this.academicYear, this.semester, this.theFirstDay);

  factory TermData.fromJson(Map<String, dynamic> json) =>
      _$TermDataFromJson(json);

  Map<String, dynamic> toJson() => _$TermDataToJson(this);
}
