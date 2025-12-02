import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:fpdart/fpdart.dart';

abstract class AbstractSchoolRepository<SchoolLoginParameter, SchoolLoginResult> {
  Future<Either<data_fetch_failure.SchoolDataFetchFailure, V>> fetchData<P, V>(
    DataFetchType<P, V> dataType,
    P p,
  );

  Future<Either<login_failure.SchoolLoginFailure, SchoolLoginResult>> login(
    SchoolLoginParameter parameter,
  );
}
