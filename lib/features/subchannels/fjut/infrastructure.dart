import 'package:corrupt/features/subchannels/fjut/data/fjut_school_repository_impl.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_school_repository.dart';
import 'package:corrupt/infrastructure/di.dart';

class InfraFjut implements DIRegister {
  @override
  void diRegister() {
    getIt.registerLazySingleton<FjutSchoolRepository>(
      () => FjutSchoolRepositoryImpl(),
    );
  }
}
