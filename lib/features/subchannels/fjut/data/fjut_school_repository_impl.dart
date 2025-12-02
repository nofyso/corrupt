import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_school_repository.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_request_parameter.dart';
import 'package:fpdart/fpdart.dart';

import '../../../channel/domain/entity/data_fetch_type.dart';

class FjutSchoolRepositoryImpl extends FjutSchoolRepository {
  @override
  Future<Either<SchoolDataFetchFailure, V>> fetchData<P, V>(DataFetchType<P, V> dataType, P p) {
    // TODO: implement fetchData
    throw UnimplementedError();
  }

  @override
  Future<Either<SchoolLoginFailure, FjutLoginResult>> login(FjutLoginParameter parameter) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
