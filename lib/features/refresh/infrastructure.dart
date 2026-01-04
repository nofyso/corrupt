import 'package:corrupt/features/refresh/domain/use_case/default_online_fetch_argument_get_usecase.dart';
import 'package:corrupt/features/refresh/domain/use_case/get_current_term_arg_usecase.dart';
import 'package:corrupt/features/refresh/domain/use_case/refresh_usecase.dart';
import 'package:corrupt/features/update/domain/entity/refresh_event.dart';
import 'package:corrupt/features/update/provider/android_update_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/infrastructure/event_bus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pref/provider/local_pref_provider.dart';

class InfraRefresh implements DIRegister, EventRegister {
  @override
  void diRegister() {
    getIt.registerFactory<DefaultOnlineFetchArgumentGetUseCase>(
      () => DefaultOnlineFetchArgumentGetUseCase(getIt(), getIt()),
    );
    getIt.registerFactory<GetCurrentTermArgUseCase>(
      () => GetCurrentTermArgUseCase(getIt()),
    );
    getIt.registerLazySingleton<RefreshUseCase>(() => RefreshUseCase(getIt()));
  }

  @override
  void eventRegister() {
    final eventBus = getIt<EventBus>();
    final ref = getIt<ProviderContainer>();
    eventBus.on<RefreshEvent>().listen((event) {
      switch (event) {
        case RefreshDataInvalidateEvent(provider: final provider):
          ref.invalidate(provider);
        case RefreshPrefInvalidateEvent():
          ref.invalidate(prefProvider);
        case RefreshUpdateStateEvent(updateInfo: final value):
          ref.read(updateAvailabilityProvider.notifier).state = value;
      }
    });
  }
}
