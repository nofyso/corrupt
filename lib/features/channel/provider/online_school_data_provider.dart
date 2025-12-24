import 'dart:async';

import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/use_case/fetch_school_data_online_usecase.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class BaseOnlineSchoolDataNotifier<P, V>
    extends FamilyAsyncNotifier<Either<SchoolDataFetchFailure, V>, P> {
  final FetchSchoolDataOnlineUseCase _usecase = getIt();
  final DataFetchType<P, V> dataFetchType;

  BaseOnlineSchoolDataNotifier(this.dataFetchType);

  @override
  FutureOr<Either<SchoolDataFetchFailure, V>> build(P p) async {
    return await _usecase.fetch(dataFetchType, p);
  }
}

final onlineClassTableNotifierProvider = AsyncNotifierProviderFamily(
  () => BaseOnlineSchoolDataNotifier(DataFetchType.classes),
);

final onlineClassTimeNotifierProvider = AsyncNotifierProviderFamily(
  () => BaseOnlineSchoolDataNotifier(DataFetchType.classTime),
);

final onlineExamsNotifierProvider = AsyncNotifierProviderFamily(
  () => BaseOnlineSchoolDataNotifier(DataFetchType.exam),
);

final   onlineScoresNotifierProvider = AsyncNotifierProviderFamily(
  () => BaseOnlineSchoolDataNotifier(DataFetchType.score),
);
