import 'dart:async';

import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/refresh/data/refresh_impl.dart';
import 'package:corrupt/features/update/domain/entity/refresh_event.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fpdart/fpdart.dart';

class RefreshUseCase {
  final EventBus _eventBus;

  RefreshUseCase(this._eventBus);

  Stream<RefreshState>? _currentStream;

  final impl = <RefreshPhase>[
    RefreshCheckPhase(),
    PrefGatePhase(LocalDataKey.logged, (it) => it),
    CommonDataFetchPhase(
      DataFetchType.classes,
      LocalDataKey.localClassTable,
      (i18n) => i18n.screen_main_refresh_classes,
      (it) => Option.of(it.$2),
    ),
    CommonDataFetchPhase(
      DataFetchType.termData,
      LocalDataKey.localTermData,
      (i18n) => i18n.screen_main_refresh_terms,
      (it) => Option.of(it),
    ),
    CommonDataFetchPhase(
      DataFetchType.classTime,
      LocalDataKey.localClassTime,
      (i18n) => i18n.screen_main_refresh_class_time,
      (it) => Option.of(it),
    ),
  ];

  Stream<RefreshState> refresh() async* {
    if (_currentStream != null) {
      yield* _currentStream!;
      return;
    }
    final stream = _refresh();
    _currentStream = stream;
    yield* stream;
    _currentStream = null;
  }

  Stream<RefreshState> _refresh() async* {
    try {
      //TODO add failure handle
      for (final it in impl) {
        yield it.state;
        final result = await it.refresh();
        if (!result.$2) break;
      }
      yield RefreshState((_) => "", isRefreshing: false);
      _eventBus.fire(RefreshPrefInvalidateEvent());
    } catch (e) {
      print(e);
    }
  }
}

class RefreshState {
  bool isRefreshing;
  String Function(AppLocalizations i18n) displayFunction;

  RefreshState(this.displayFunction, {this.isRefreshing = true});
}
