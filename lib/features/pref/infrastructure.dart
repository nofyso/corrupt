import 'package:corrupt/features/pref/data/local_data_impl.dart';
import 'package:corrupt/features/pref/data/local_raw_data_impl.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_local_data.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/provider_bridge.dart';
import 'package:corrupt/features/pref/domain/use_case/prefs_usecase.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/infrastructure/event_bus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfraPrefs implements DIRegister, EventRegister {
  @override
  void diRegister() {
    getIt.registerLazySingleton<LocalRawDataRepository>(() => LocalRawDataRepositoryImpl());
    getIt.registerLazySingleton<LocalDataRepository>(() => LocalDataRepositoryImpl());
    getIt.registerFactory<PrefReadUseCase>(() => PrefReadUseCase());
    getIt.registerFactory<PrefWriteUseCase>(() => PrefWriteUseCase());
  }

  @override
  void eventRegister() {
    getIt<EventBus>().on<PrefsProviderEvent>().listen((event) {
      final ref = getIt<ProviderContainer>();
      switch (event.provider) {
        case PrefsProviderType.prefs:
          ref.invalidate(prefProvider);
      }
    });
  }
}
