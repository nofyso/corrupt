import 'package:corrupt/features/subchannels/term_data_fetch/domain/abstract_repository/github_api.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:dio/dio.dart';

class InfraTermDataApi implements DIRegister {
  @override
  void diRegister() {
    getIt.registerLazySingleton<Dio>(() => Dio(), instanceName: "githubDio");
    getIt.registerLazySingleton<GithubApiRaw>(
      () => GithubApiRaw(getIt(instanceName: "githubDio")),
    );
    getIt.registerLazySingleton<GithubApi>(() => GithubApi());
  }
}
