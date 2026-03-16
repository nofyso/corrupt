import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/subchannels/fjut/data/fjut_api.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_school_repository.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_request_parameter.dart';
import 'package:dartlin/dartlin.dart';
import 'package:fpdart/fpdart.dart';

import '../../../channel/domain/entity/data_fetch_type.dart';

class FjutSchoolRepositoryImpl extends FjutSchoolRepository {
  static final FjutApi _fjutApi = FjutApi();

  static final _termData = [
    TermData("2025-2026", "2", DateTime(2026, DateTime.march, 1)),
  ];

  static final _classTime = ClassTime.fromTimes([
    (8, 20),
    (9, 15),
    (10, 15),
    (11, 5),
    (14, 0),
    (14, 55),
    (15, 55),
    (16, 50),
    (18, 30),
    (19, 25),
    (20, 20),
  ], 45 * 60 * 1000);

  @override
  Future<Either<data_fetch_failure.SchoolDataFetchFailure, V>> fetchData<P, V>(
    final DataFetchType<P, V> dataType,
    P p,
  ) async {
    switch (dataType) {
      case DataFetchType.classes:
        final terms = DataFetchType.classes.castP(p);
        final (academicYear, semester) =
            terms?.let((it) => (it.academicYear, it.semester)) ?? (null, null);
        final result = await _fjutApi.loopBackSafe(
          () => _fjutApi.fetchClassTable(
            dataPair: semester == null || academicYear == null
                ? null
                : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.exam:
        final (academicYear, semester) =
            (DataFetchType.exam
                .castP(p)
                ?.let((it) => (it.academicYear, it.semester)) ??
            (null, null));
        final result = await _fjutApi.loopBackSafe(
          () => _fjutApi.fetchExams(
            dataPair: semester == null || academicYear == null
                ? null
                : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.score:
        final (academicYear, semester) =
            (DataFetchType.score
                .castP(p)
                ?.let((it) => (it.academicYear, it.semester)) ??
            (null, null));
        final result = await _fjutApi.loopBackSafe(
          () => _fjutApi.fetchScores(
            dataPair: semester == null || academicYear == null
                ? null
                : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.termData:
        return Either.right(_termData as V);
      case DataFetchType.classTime:
        return Either.right(_classTime as V);
    }
  }

  @override
  Future<Either<login_failure.SchoolLoginFailure, FjutLoginResult>> login(
    FjutLoginParameter? newParameter,
  ) async => await _fjutApi.login(newParameter);
}
