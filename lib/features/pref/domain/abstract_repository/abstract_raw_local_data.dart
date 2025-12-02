import 'package:cirno_pref_key/cirno_pref.dart';

abstract class LocalRawDataRepository {
  Future<T> getData<OT, T>(CirnoPrefKey<OT, T> key);

  Future<void> setData<OT, T>(CirnoPrefKey<OT, T> key, T t);
}
