import 'dart:async';

import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/use_case/fetch_school_data_online_usecase.dart';
import 'package:corrupt/features/channel/provider/local_school_data_provider.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/refresh/domain/use_case/default_online_fetch_argument_get_usecase.dart';
import 'package:corrupt/features/refresh/domain/use_case/refresh_usecase.dart';
import 'package:corrupt/features/update/domain/entity/refresh_event.dart';
import 'package:corrupt/features/update/domain/use_case/check_update_usecase.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:dartlin/control_flow.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fpdart/fpdart.dart';

abstract class RefreshPhase {
  abstract RefreshState state;

  FutureOr<(Exception?, bool)> refresh();
}

class CommonDataFetchPhase<T, U> extends RefreshPhase {
  final _fetchUseCase = getIt<FetchSchoolDataOnlineUseCase>();
  final _localRawDataRepository = getIt<LocalRawDataRepository>();
  final _argumentSelectUseCase = getIt<DefaultOnlineFetchArgumentGetUseCase>();
  final _eventBus = getIt<EventBus>();

  final DataFetchType<dynamic, T> dataFetchType;
  final CirnoPrefKey<String, U> localDataKey;
  final String Function(AppLocalizations i18n) displayFunction;
  U Function(T) transform = (t) => t as U;

  CommonDataFetchPhase(this.dataFetchType, this.localDataKey, this.displayFunction, this.transform);

  @override
  late RefreshState state = RefreshState(displayFunction);

  @override
  FutureOr<(Exception?, bool)> refresh() async {
    final arg = await _argumentSelectUseCase.getArgument(dataFetchType);
    final result = await _fetchUseCase.fetch(dataFetchType, arg);
    switch (result) {
      case Right<SchoolDataFetchFailure, T>(value: final value):
        _localRawDataRepository.setData(localDataKey, transform(value));
        classLocalProviderMap[dataFetchType]?.let(
          (it) => _eventBus.fire(RefreshDataInvalidateEvent(it)),
        );
        return (null, true);
      case Left<SchoolDataFetchFailure, T>(value: final value):
        return (value.asException(), false);
    }
  }
}

class PrefGatePhase<T> extends RefreshPhase {
  final _localRawDataRepository = getIt<LocalRawDataRepository>();
  final CirnoPrefKey<dynamic, T> localDataKey;
  final bool Function(T) predicate;

  PrefGatePhase(this.localDataKey, this.predicate);

  @override
  RefreshState state = RefreshState((i18n) => i18n.screen_main_refresh_gate);

  @override
  FutureOr<(Exception?, bool)> refresh() async {
    final result = await _localRawDataRepository.getData(localDataKey);
    return (null, predicate(result));
  }
}

class RefreshCheckPhase extends RefreshPhase {
  final _localRawDataRepository = getIt<LocalRawDataRepository>();
  final _updateCheckUseCase = getIt<UpdateCheckUseCase>();
  final _eventBus = getIt<EventBus>();

  @override
  RefreshState state = RefreshState((i18n) => i18n.screen_main_refresh_update_check);

  @override
  FutureOr<(Exception?, bool)> refresh() async {
    final checkUpdate = await _localRawDataRepository.getData(SettingKeysGen.updateChecking);
    if (!checkUpdate) return (null, true);
    final updateInfo = await _updateCheckUseCase.checkUpdate();
    updateInfo.match(() {}, (it) => _eventBus.fire(RefreshUpdateStateEvent(it)));
    return (null, true);
  }
}
