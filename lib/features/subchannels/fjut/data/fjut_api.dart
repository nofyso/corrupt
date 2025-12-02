import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_api_cas_raw.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_api_vpn_raw.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_data_key.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_request_parameter.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/util/regex_helper.dart';
import 'package:corrupt/util/wrapper.dart' as wrapper;
import 'package:dartlin/collections.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_redirect_interceptor/dio_redirect_interceptor.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrofit/dio.dart';

class FjutApi {
  static Future<void> initialize() async {
    _cookieJar = PersistCookieJar(
      ignoreExpires: false,
      persistSession: true,
      storage: FileStorage((await getApplicationCacheDirectory()).path),
    );
    _dio
      ..interceptors.add(CookieManager(_cookieJar))
      ..interceptors.add(RedirectInterceptor(() => _dio));
  }

  static final Dio _dio = Dio(
    BaseOptions(
      followRedirects: false,
      headers: {
        "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0",
      },
      validateStatus: (status) => status != null && status < 400,
    ),
  );
  static late final CookieJar _cookieJar;
  static final _vpnRaw = FjutVpnApiRaw(_dio);
  static final _casRaw = FjutCasApiRaw(_dio);

  // static final _eduRaw = FjutEduApiRaw(_dio);

  static final _vpnTokenRegex = "(?<=name=\"csrf-token\" content=\").*?(?=\" />)".asRegExp;
  static final _vpnDataInvalidRegex = "(?<=</button>).*?(?=</div>)".asRegExp;

  static const _loopback0 = "jwxt-443.webvpn.fjut.edu.cn";
  static const _loopback1 = "webvpn.fjut.edu.cn";
  static const _loopback2 = "nids-443.webvpn.fjut.edu.cn";

  final _localRawDataRepository = getIt<LocalRawDataRepository>();

  Future<Either<login_failure.SchoolLoginFailure, FjutLoginResult>> login(
    FjutLoginParameter? newParameter,
  ) async {
    final parameter =
        newParameter ??
        FjutLoginParameter(
          await _localRawDataRepository.getData(FjutDataKey.studentId),
          await _localRawDataRepository.getData(FjutDataKey.password),
        );
    final result = await _login(parameter.studentId, parameter.password);
    await result.match((_) {}, (right) async {
      await _localRawDataRepository.setData(FjutDataKey.studentId, parameter.studentId);
      await _localRawDataRepository.setData(FjutDataKey.password, parameter.password);
    });
    return result;
  }

  Future<Either<login_failure.SchoolLoginFailure, FjutLoginResult>> _login(
    String studentId,
    String password,
  ) async =>
      TaskEither<dynamic, FjutLoginResult>.Do(($) async {
            for (final _ in 0.to(5)) {
              final (loopbackLevel, loopbackResponse) = await _checkLoopback($);
              if (loopbackLevel == 1) {
                await _vpnLogin(studentId, password, loopbackResponse, $);
                continue;
              }
              if (loopbackLevel == 2) {
                await _casLogin(studentId, password, loopbackResponse, $);
                continue;
              }
              return FjutLoginResult();
            }
            $(TaskEither.left(login_failure.OtherFailure("Too many trials, unknown error")));
            throw AssertionError("Unreachable code");
          })
          .mapLeft(
            (err) => switch (err) {
              wrapper.RequestFailure() => err.asLoginFailure(),
              _ => login_failure.OtherFailure("Unknown failure"),
            },
          )
          .run();

  Future<(int, HttpResponse<dynamic>)> _checkLoopback(
    Future<A> Function<A>(TaskEither<dynamic, A>) $,
  ) async {
    final initLoginPage = await $(_casRaw.getLoginPage().wrapNetworkSafeTask());
    return await $(switch (initLoginPage.response.realUri.host) {
      _loopback1 =>
        TaskEither<login_failure.SchoolLoginFailure, (int, HttpResponse<dynamic>)>.right((
          1,
          initLoginPage,
        )),
      _loopback2 =>
        TaskEither<login_failure.SchoolLoginFailure, (int, HttpResponse<dynamic>)>.right((
          2,
          initLoginPage,
        )),
      _loopback0 =>
        TaskEither<login_failure.SchoolLoginFailure, (int, HttpResponse<dynamic>)>.right((
          0,
          initLoginPage,
        )),
      final s => TaskEither<login_failure.SchoolLoginFailure, (int, HttpResponse<dynamic>)>.left(
        login_failure.OtherFailure("Unknown loop back host: $s"),
      ),
    });
  }

  Future<void> _vpnLogin(
    String studentId,
    String password,
    HttpResponse<dynamic> loopbackResponse,
    Future<A> Function<A>(TaskEither<dynamic, A>) $,
  ) async {
    final vpnLoginPage = loopbackResponse.data as String;
    final token = await $(
      vpnLoginPage
          .matchFirst(_vpnTokenRegex)
          .toTaskOption()
          .toTaskEither(() => login_failure.OtherFailure("token not found")),
    );
    final vpnLoginResultResponse = await $(
      _vpnRaw.login(token: token, username: studentId, password: password).wrapNetworkSafeTask(),
    );
    if (vpnLoginResultResponse.response.realUri.path.contains("sign_in")) {
      final vpnLoginResultPage = vpnLoginResultResponse.data;
      final error = await $(
        vpnLoginResultPage
            .matchFirst(_vpnDataInvalidRegex)
            .toTaskOption()
            .toTaskEither(() => login_failure.OtherFailure("error not found")),
      );
      await $(switch (error) {
        final s when s.contains("不能为空") => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.other, true),
        ),
        final s when s.contains("错误") => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.other, false),
        ),
        _ => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.other, false, "Unknown error"),
        ),
      });
    }
  }

  Future<void> _casLogin(
    String studentId,
    String password,
    HttpResponse<dynamic> loopbackResponse,
    Future<A> Function<A>(TaskEither<dynamic, A>) $,
  ) async {
    final loginPage = loopbackResponse.data as String;
    final document = BeautifulSoup(loginPage);
    final loginForm = document.find("*", id: "pwdLoginDiv");
    if (loginForm == null) {
      await $(TaskEither.left(login_failure.OtherFailure("login form not found")));
      throw AssertionError("Unreachable code");
    }
    final loginExecution = loginForm.find("*", id: "execution")?.getAttrValue("value");
    final loginSalt = loginForm.find("*", id: "pwdEncryptSalt")?.getAttrValue("value");
    if (loginExecution == null) {
      await $(TaskEither.left(login_failure.OtherFailure("execution not found")));
      throw AssertionError("Unreachable code");
    }
    if (loginSalt == null) {
      await $(TaskEither.left(login_failure.OtherFailure("salt not found")));
      throw AssertionError("Unreachable code");
    }
    final loginResult = await $(
      _casRaw
          .login(
            username: studentId,
            password: _encryptPassword(password, loginSalt),
            execution: loginExecution,
          )
          .wrapNetworkSafeTask(),
    );
    if (loginResult.response.statusCode == 401) {
      await $(switch (loginResult.data) {
        final s when s.contains("该账号非常用账号或用户名密码有误") => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.both, false),
        ),
        final s when s.contains("入密码") => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.password, true),
        ),
        final s when s.contains("入用户名") => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.username, true),
        ),
        _ => TaskEither.left(login_failure.BadDataFailure(login_failure.BadDataType.other, false)),
      });
      throw AssertionError("Unreachable code");
    }
  }

  String _encryptPassword(String password, String salt) {
    final plain = "0000000000000000000000000000000000000000000000000000000000000000$password";
    final iv = encrypt.IV.fromUtf8("0000000000000000");
    final key = encrypt.Key.fromUtf8(salt);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return encrypted.base64;
  }
}
