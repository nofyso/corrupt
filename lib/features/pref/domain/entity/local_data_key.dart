import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:fpdart/fpdart.dart';

import '../../../channel/domain/entity/exam_entity.dart';
import '../../../channel/domain/entity/score_entity.dart';

class LocalDataKey {
  static final schoolType = "common:school_type".toEnhancedKey(
    School.none,
    (e) => e.name,
    (s) => School.values.where((it) => it.name == s).first,
  );
  static final logged = "common:logged".toEnhancedKeySimple(false);
  static final localClassTable = "common:class_table".toEnhancedKeyJson(
    Option<ClassTable>.none(),
    ClassTable.fromJson,
  );

  /*static final localClassAvailableTime = "common:class_available_time".toEnhancedKeyJson(
    ClassAvailableTime as ClassTable?,
  );*/
  static final localClassTime = "common:class_time".toEnhancedKeyJson(
    Option<ClassTime>.none(),
    ClassTime.fromJson,
  );
  static final localTermData = "common:term_data".toEnhancedKeyJsonList(
    Option<List<TermData>>.none(),
    TermData.fromJson,
  );
  static final localExamData = "common:exam_data".toEnhancedKeyJsonList(
    Option<List<ExamEntity>>.none(),
    ExamEntity.fromJson,
  );
  static final localScoreData = "common:score_data".toEnhancedKeyJsonList(
    Option<List<ScoreEntity>>.none(),
    ScoreEntity.fromJson,
  );
}
