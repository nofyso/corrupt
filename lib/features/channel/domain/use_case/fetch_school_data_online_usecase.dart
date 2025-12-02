import 'package:corrupt/features/channel/domain/abstract_repository/abstract_school.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart';
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:corrupt/features/channel/domain/use_case/school_impl_select_usecase.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/domain/use_case/prefs_usecase.dart';
import 'package:fpdart/fpdart.dart';

class FetchSchoolDataOnlineUseCase {
  final SchoolImplSelectUseCase _implSelect;
  final PrefWriteUseCase _prefWriteUseCase;

  FetchSchoolDataOnlineUseCase(this._implSelect, this._prefWriteUseCase);

  Future<Either<SchoolDataFetchFailure, V>> fetch<P, V>(DataFetchType<P, V> dataType, P p) async {
    switch (await _implSelect.select()) {
      case Some<(School, AbstractSchoolRepository<dynamic, dynamic>)>(value: final school):
        final (_, schoolRepository) = school;
        final result = await schoolRepository.fetchData(dataType, p);
        if (switch (result) {
          Left<SchoolDataFetchFailure, V>(value: final value) => switch (value) {
            LoginFailure(loginFailure: final loginFailure) => switch (loginFailure) {
              BadDataFailure() => true,
              _ => false,
            },
            _ => false,
          },
          _ => false,
        }) {
          await _prefWriteUseCase.write(LocalDataKey.logged, false);
          await _prefWriteUseCase.write(LocalDataKey.schoolType, School.none);
          return Either.left(NotLoggedFailure());
        }
        return result;
      case None():
        return Either.left(NotLoggedFailure());
    }
  }
}
