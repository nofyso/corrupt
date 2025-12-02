import 'package:corrupt/features/update/domain/abstract_repository/github_api.dart';
import 'package:corrupt/features/update/domain/use_case/check_update_usecase.dart';
import 'package:corrupt/infrastructure/di.dart';

class InfraUpdate implements DIRegister {
  @override
  void diRegister() {
    getIt.registerFactory<UpdateCheckUseCase>(() => UpdateCheckUseCase(getIt()));
    getIt.registerLazySingleton<GithubApiRepository>(() => GithubApiRepository());
  }
}
