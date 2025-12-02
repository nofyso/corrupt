import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:fpdart/fpdart.dart';

abstract class LocalDataRepository {
  Future<Option<V>> fetchLocalData<P, V>(DataFetchType<P, V> dataType);
}
