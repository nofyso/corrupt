import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/refresh/domain/use_case/get_current_term_arg_usecase.dart';
import 'package:dartlin/control_flow.dart';

class DefaultOnlineFetchArgumentGetUseCase {
  final LocalRawDataRepository _localRawDataRepository;
  final GetCurrentTermArgUseCase _termArgUseCase;

  DefaultOnlineFetchArgumentGetUseCase(this._localRawDataRepository, this._termArgUseCase);

  Future<P> getArgument<P, V>(DataFetchType<P, V> fetchType) async {
    switch (fetchType) {
      case DataFetchType.classes:
        final sourceRaw = await _localRawDataRepository.getData(SettingKeysGen.classDataSource);
        final source = ClassesDataSource.fromRawValue(sourceRaw);
        final arg = (source == ClassesDataSource.currentDate
            ? (await _termArgUseCase.getCurrentTermData()).toNullable()?.let(
                (it) => TermBasedFetchArgument(it.academicYear, it.semester),
              )
            : null);
        return arg as P;
      case DataFetchType.termData ||
          DataFetchType.classTime ||
          DataFetchType.exam ||
          DataFetchType.score:
        return null as P;
    }
  }
}
