import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_api.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_school_repository.dart';
import 'package:corrupt/features/subchannels/mju/domain/entity/mju_request_parameter.dart';
import 'package:dartlin/dartlin.dart';
import 'package:fpdart/fpdart.dart';

class MjuSchoolRepositoryImpl extends MjuSchoolRepository {
  static final _mjuApi = MjuApi();

  static final _termData = [
    TermData("2025-2026", "1", DateTime(2025, DateTime.september, 1)), //TODO network fetch
  ];

  static final _classTime = ClassTime.of([
    (8, 30),
    (9, 25),
    (10, 30),
    (11, 25),
    (14, 0),
    (14, 55),
    (15, 50),
    (16, 45),
    (18, 30),
    (19, 25),
  ], 45 * 60 * 1000);

  @override
  Future<Either<SchoolDataFetchFailure, V>> fetchData<P, V>(
    DataFetchType<P, V> dataType,
    P p,
  ) async {
    switch (dataType) {
      case DataFetchType.classes:
        final terms = DataFetchType.classes.castP(p);
        final (academicYear, semester) =
            (terms?.let((it) => (it.academicYear, it.semester)) ?? (null, null));
        final result = await _mjuApi.loopBackSafe(
          () => _mjuApi.fetchClassTable(
            dataPair: semester == null || academicYear == null ? null : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.exam:
        final (academicYear, semester) =
            (DataFetchType.exam.castP(p)?.let((it) => (it.academicYear, it.semester)) ??
            (null, null));
        final result = await _mjuApi.loopBackSafe(
          () => _mjuApi.fetchExams(
            dataPair: semester == null || academicYear == null ? null : (academicYear, semester),
          ),
        );
        return result as Either<data_fetch_failure.SchoolDataFetchFailure, V>;
      case DataFetchType.score:
        return Either.left(data_fetch_failure.NotImplementedFailure());
      case DataFetchType.termData:
        return Either.right(_termData as V);
      case DataFetchType.classTime:
        return Either.right(_classTime as V);
    }
  }

  @override
  Future<Either<SchoolLoginFailure, MjuLoginResult>> login(MjuLoginParameter newParameter) async =>
      await _mjuApi.login(newParameter);
}
