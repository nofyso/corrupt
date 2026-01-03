import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';

class LocalRawDataRepositoryImpl extends LocalRawDataRepository {
  @override
  Future<T> getData<OT, T>(CirnoPrefKey<OT, T> key) => key.read(null);

  @override
  Future<void> setData<OT, T>(CirnoPrefKey<OT, T> key, T t) =>
      key.write(null, t);
}
