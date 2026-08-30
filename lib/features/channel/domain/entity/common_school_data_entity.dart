import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'common_school_data_entity.g.dart';

@JsonSerializable()
class TermData {
  final School belonging;
  final String academicYear;
  final String semester;
  final DateTime theFirstDay;

  TermData(this.belonging, this.academicYear, this.semester, this.theFirstDay);

  factory TermData.fromJson(Map<String, dynamic> json) =>
      _$TermDataFromJson(json);

  Map<String, dynamic> toJson() => _$TermDataToJson(this);
}
