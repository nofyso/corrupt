import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/features/subchannels/mju/domain/entity/mju_json_object.dart';
import 'package:fpdart/fpdart.dart';

class MjuAnalyzer {
  //TODO wrap with try and add error processing
  static (AvailableTermTime, int, int) getClassAvailableTermTimeAndSelected(
    BeautifulSoup document,
    String academicYearField,
    String semesterField,
  ) {
    final academicYearResult = document
        .find("select", id: academicYearField)!
        .children
        .mapWithIndex(
          (it, i) => (
            it.string,
            it.attributes["value"]!,
            it.attributes["selected"] == "selected" ? i : -1,
          ),
        );
    final academicYearIndex = academicYearResult
        .filter((it) => it.$3 != -1)
        .firstOrNull!
        .$3;
    final semesterResult = document
        .find("select", id: semesterField)!
        .children
        .mapWithIndex(
          (it, i) => (
            it.string,
            it.attributes["value"]!,
            it.attributes["selected"] == "selected" ? i : -1,
          ),
        );
    final semesterIndex = semesterResult
        .filter((it) => it.$3 != -1)
        .firstOrNull!
        .$3;
    return (
      AvailableTermTime(
        academicYearResult.map((it) => (it.$1, it.$2)).toList(),
        semesterResult.map((it) => (it.$1, it.$2)).toList(),
      ),
      academicYearIndex,
      semesterIndex,
    );
  }

  static Either<data_fetch_failure.OtherFailure, ClassTable> analyzeClassTable(
    String jsonObject,
    String academicYear,
    String semester,
  ) => Either.Do(($) {
    final rootJsonRaw = $(
      jsonDecodeSafe(jsonObject).toEither(
        () => data_fetch_failure.OtherFailure(
          "error in analyzing class table (bad json data)",
        ),
      ),
    );
    final rootJson = rootJsonRaw as Map<String, dynamic>;
    final classesJsonList = rootJson["kbList"] as List<dynamic>;
    final classes = classesJsonList
        .map((it) => MjuClassEntry.fromJson(it).toClassEntity())
        .toList(growable: false);
    return ClassTable(academicYear, semester, classes);
  });

  static Either<data_fetch_failure.OtherFailure, ExamsEntity> analyzeExams(
    String jsonObject,
    String academicYear,
    String semester,
  ) {
    final rootJson = jsonDecode(jsonObject) as Map<String, dynamic>;
    final examsJsonList = rootJson["items"] as List<dynamic>;
    final exams = examsJsonList
        .map((it) => MjuExamEntity.fromJson(it).toExamEntity())
        .toList(growable: false);
    return Either.right(
      ExamsEntity(
        academicYear: academicYear,
        semester: semester,
        entities: exams,
      ),
    );
  }

  static Either<data_fetch_failure.SchoolDataFetchFailure, ScoresEntity>
  analyzeScores(String jsonObject, String academicYear, String semester) =>
      Either.Do(($) {
        final rootJsonRaw = $(
          jsonDecodeSafe(jsonObject).toEither(
            () => data_fetch_failure.OtherFailure(
              "error in analyzing class table (bad json data)",
            ),
          ),
        );
        final rootJson = rootJsonRaw as Map<String, dynamic>;
        final scoreItemsJsonList = rootJson["items"] as List<dynamic>;
        final scores = scoreItemsJsonList
            .map((it) => MjuScoreEntity.fromJson(it).toScoreEntity())
            .toList(growable: false);
        return ScoresEntity(
          academicYear: academicYear,
          semester: semester,
          entities: scores,
        );
      });
}
