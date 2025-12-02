import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/subchannels/fafu/data/fafu_api.dart';
import 'package:corrupt/features/subchannels/fafu/domain/abstract_repository/fafu_school_repository.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_request_parameters.dart';
import 'package:dartlin/control_flow.dart';
import 'package:fpdart/fpdart.dart';

class FafuSchoolRepositoryImpl extends FafuSchoolRepository {
  static final FafuApi _fafuApi = FafuApi();

  static final _termData = [
    TermData("2025-2026", "1", DateTime(2025, DateTime.september, 1)), //TODO network fetch
  ];

  static final _classTime = ClassTime.of([
    (8, 0),
    (8, 50),
    (9, 55),
    (10, 45),
    (11, 35),
    (14, 0),
    (14, 50),
    (15, 50),
    (16, 40),
    (18, 25),
    (19, 15),
    (20, 5),
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
        final result = await _fafuApi.loopBackSafe(
          () => _fafuApi.fetchClassTable(
            dataPair: semester == null || academicYear == null ? null : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.exam:
        final (academicYear, semester) =
            (DataFetchType.exam.castP(p)?.let((it) => (it.academicYear, it.semester)) ??
            (null, null));
        final result = await _fafuApi.loopBackSafe(
          () => _fafuApi.fetchExams(
            dataPair: semester == null || academicYear == null ? null : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.score:
        final (academicYear, semester) =
            (DataFetchType.score.castP(p)?.let((it) => (it.academicYear, it.semester)) ??
            (null, null));
        final result = await _fafuApi.loopBackSafe(
          () => _fafuApi.fetchScores(
            dataPair: semester == null || academicYear == null ? null : (academicYear, semester),
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
  Future<Either<login_failure.SchoolLoginFailure, FafuLoginResult>> login(
    FafuLoginParameter? newParameter,
  ) async => await _fafuApi.login(newParameter);
}
