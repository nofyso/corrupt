import 'package:corrupt/features/larva/data/larva_impl.dart';
import 'package:corrupt/features/larva/domain/abstract_repository/larva_repository.dart';
import 'package:corrupt/infrastructure/di.dart';

class InfraLarva implements DIRegister {
  @override
  void diRegister() {
    getIt.registerLazySingleton<LarvaRepository>(() => LarvaImpl());
  }
}
