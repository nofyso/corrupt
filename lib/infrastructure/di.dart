import 'package:corrupt/features/channel/infrastructure.dart';
import 'package:corrupt/features/larva/infrastructure.dart';
import 'package:corrupt/features/pref/infrastructure.dart';
import 'package:corrupt/features/refresh/infrastructure.dart';
import 'package:corrupt/features/update/infrastructure.dart';
import 'package:corrupt/presentation/page/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  final diRegisters = <DIRegister>[
    InfraPrefs(),
    InfraChannel(),
    InfraUpdate(),
    InfraLarva(),
    InfraRefresh(),
  ];

  getIt.registerLazySingleton<EventBus>(() => EventBus());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<LoginController>(() => LoginController()); //FIXME ???
  getIt.registerLazySingleton<ProviderContainer>(() => ProviderContainer());
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());

  for (final it in diRegisters) {
    it.diRegister();
  }
}

interface class DIRegister {
  void diRegister() {}
}
