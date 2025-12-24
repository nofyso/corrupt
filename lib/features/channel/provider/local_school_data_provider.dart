import 'dart:async';

import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/util/wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class ClassTableNotifier extends AsyncNotifier<Option<ClassTable>> {
  @override
  FutureOr<Option<ClassTable>> build() async {
    final rawClassTable = await LocalDataKey.localClassTable.readRaw(null);
    final x = jsonDecodeSafeDirect(rawClassTable, ClassTable.fromJson);
    return x;
  }
}

class ExamsNotifier extends AsyncNotifier<Option<ExamsEntity>> {
  @override
  FutureOr<Option<ExamsEntity>> build() async {
    final rawExams = await LocalDataKey.localExamData.readRaw(null);
    final x = jsonDecodeSafeDirect(rawExams, ExamsEntity.fromJson);
    return x;
  }
}

class _BaseSchoolDataNotifier<V> extends AsyncNotifier<Option<V>> {
  final _repo = getIt<LocalDataRepository>();
  DataFetchType<dynamic, V> dataFetchType;

  _BaseSchoolDataNotifier(this.dataFetchType);

  @override
  FutureOr<Option<V>> build() async => await _repo.fetchLocalData(dataFetchType);
}

final classLocalProviderMap = {
  DataFetchType.classes: _classTableNotifierProvider,
  DataFetchType.classTime: _classTimeNotifierProvider,
  DataFetchType.termData: _termDataNotifierProvider,
  DataFetchType.exam: _examsNotifierProvider
};

final _classTableNotifierProvider = AsyncNotifierProvider(() => ClassTableNotifier());

final _examsNotifierProvider = AsyncNotifierProvider(() => ExamsNotifier());

final _termDataNotifierProvider = AsyncNotifierProvider(
  () => _BaseSchoolDataNotifier(DataFetchType.termData),
);

final _classTimeNotifierProvider = AsyncNotifierProvider(
  () => _BaseSchoolDataNotifier(DataFetchType.classTime),
);
