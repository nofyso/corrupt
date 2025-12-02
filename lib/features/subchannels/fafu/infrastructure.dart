import 'package:corrupt/features/subchannels/fafu/data/fafu_api.dart';
import 'package:corrupt/features/subchannels/fafu/data/fafu_school_repository_impl.dart';
import 'package:corrupt/features/subchannels/fafu/domain/abstract_repository/fafu_api_raw.dart';
import 'package:corrupt/features/subchannels/fafu/domain/abstract_repository/fafu_school_repository.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:dartlin/dartlin.dart';
import 'package:dio/dio.dart';
import 'package:dio_redirect_interceptor/dio_redirect_interceptor.dart';

class InfraFafu implements DIRegister {
  @override
  void diRegister() {
    getIt.registerLazySingleton<FafuSchoolRepository>(() => FafuSchoolRepositoryImpl());
    getIt.registerSingleton<Dio>(
      Dio(
        BaseOptions(
          followRedirects: true,
          maxRedirects: 20,
          validateStatus: (status) => status != null && status < 400,
          headers: {"Host": "jwgl.fafu.edu.cn", "Origin": "http://jwgl.fafu.edu.cn"},
        ),
      ).let((it) => it..interceptors.add(RedirectInterceptor(() => it))),
      instanceName: "fafuDio",
    );
    getIt.registerLazySingleton<FafuApiRaw>(() => FafuApiRaw(getIt<Dio>(instanceName: "fafuDio")));
    getIt.registerLazySingleton<FafuApi>(() => FafuApi());
  }
}
