import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_local_data.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:fpdart/fpdart.dart';

class LocalDataRepositoryImpl extends LocalDataRepository {
  final _localRawDataRepository = getIt<LocalRawDataRepository>();

  @override
  Future<Option<V>> fetchLocalData<P, V>(DataFetchType<P, V> dataType) async {
    try {
      final value = await switch (dataType) {
        DataFetchType.classes => _localRawDataRepository.getData(LocalDataKey.localClassTable),
        DataFetchType.termData => _localRawDataRepository.getData(LocalDataKey.localTermData),
        DataFetchType.classTime => _localRawDataRepository.getData(LocalDataKey.localClassTime),
        DataFetchType.exam => _localRawDataRepository.getData(LocalDataKey.localExamData),
        DataFetchType.score => _localRawDataRepository.getData(LocalDataKey.localScoreData),
      }.then((it) => it as Option<V>);
      return value;
    } catch (e) {
      return Option.none();
    }
  }
}
