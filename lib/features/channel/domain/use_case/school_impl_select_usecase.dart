import 'package:corrupt/features/channel/domain/abstract_repository/abstract_school.dart';
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/domain/use_case/prefs_usecase.dart';
import 'package:corrupt/features/subchannels/fafu/data/fafu_school_repository_impl.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_school_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class SchoolImplSelectUseCase {
  static final Map<School, AbstractSchoolRepository<dynamic, dynamic>> _map = {
    School.fafu: FafuSchoolRepositoryImpl(),
    School.mju: MjuSchoolRepositoryImpl(),
  };

  final PrefReadUseCase _prefReadUseCase;
  final PrefWriteUseCase _prefWriteUseCase;

  SchoolImplSelectUseCase(this._prefReadUseCase, this._prefWriteUseCase);

  Future<Option<(School, AbstractSchoolRepository<dynamic, dynamic>)>> select([
    School? targetSchool,
  ]) async {
    if (targetSchool != null) {
      await _prefWriteUseCase.write(LocalDataKey.schoolType, targetSchool);
    }
    final schoolType = await _prefReadUseCase.read(LocalDataKey.schoolType);
    if (schoolType == School.none) return Option.none();
    final schoolImpl = _map[schoolType];
    if (schoolImpl == null) return Option.none();
    return Option.of((schoolType, schoolImpl));
  }
}
