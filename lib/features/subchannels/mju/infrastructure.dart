import 'package:cookie_jar/cookie_jar.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_school_repository_impl.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_api_cas_raw.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_api_edu_raw.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_school_repository.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:dartlin/control_flow.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_redirect_interceptor/dio_redirect_interceptor.dart';
import 'package:path_provider/path_provider.dart';

class InfraMju implements DIRegister {
  @override
  void diRegister() {
    getIt.registerSingletonAsync<CookieJar>(
      () async => PersistCookieJar(
        ignoreExpires: false,
        persistSession: true,
        storage: FileStorage((await getApplicationCacheDirectory()).path),
      ),
      instanceName: "mjuCookieJar",
    );
    getIt.registerLazySingleton<MjuSchoolRepository>(
      () => MjuSchoolRepositoryImpl(),
    );
    getIt.registerLazySingleton<Dio>(
      () =>
          Dio(
            BaseOptions(
              followRedirects: false,
              headers: {
                "user-agent":
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0",
              },
              validateStatus: (status) => status != null && status < 400,
            ),
          ).let(
            (it) => it
              ..interceptors.add(
                CookieManager(getIt<CookieJar>(instanceName: "mjuCookieJar")),
              )
              ..interceptors.add(RedirectInterceptor(() => it)),
          ),
      instanceName: "mjuDio",
    );
    getIt.registerLazySingleton<MjuCasApiRaw>(
      () => MjuCasApiRaw(getIt(instanceName: "mjuDio")),
    );
    getIt.registerLazySingleton<MjuEduApiRaw>(
      () => MjuEduApiRaw(getIt(instanceName: "mjuDio")),
    );
  }
}
