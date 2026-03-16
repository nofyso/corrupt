import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_api_cas_raw.dart';
import 'package:corrupt/features/subchannels/fjut/domain/abstract_repository/fjut_api_vpn_raw.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_data_key.dart';
import 'package:corrupt/features/subchannels/fjut/domain/entity/fjut_request_parameter.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_analyzer.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/util/regex_helper.dart';
import 'package:corrupt/util/wrapper.dart' as wrapper;
import 'package:dartlin/dartlin.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/dio.dart';

import '../domain/abstract_repository/fjut_api_edu_raw.dart';

class FjutApi {
  final _vpnRaw = getIt<FjutVpnApiRaw>();
  final _casRaw = getIt<FjutCasApiRaw>();
  final _eduRaw = getIt<FjutEduApiRaw>();

  static final _vpnTokenRegex =
      "(?<=name=\"csrf-token\" content=\").*?(?=\" />)".asRegExp;
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
      await _localRawDataRepository.setData(
        FjutDataKey.studentId,
        parameter.studentId,
      );
      await _localRawDataRepository.setData(
        FjutDataKey.password,
        parameter.password,
      );
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
            $(
              TaskEither.left(
                login_failure.OtherFailure("Too many trials, unknown error"),
              ),
            );
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
        TaskEither<
          login_failure.SchoolLoginFailure,
          (int, HttpResponse<dynamic>)
        >.right((1, initLoginPage)),
      _loopback2 =>
        TaskEither<
          login_failure.SchoolLoginFailure,
          (int, HttpResponse<dynamic>)
        >.right((2, initLoginPage)),
      _loopback0 =>
        TaskEither<
          login_failure.SchoolLoginFailure,
          (int, HttpResponse<dynamic>)
        >.right((0, initLoginPage)),
      final s =>
        TaskEither<
          login_failure.SchoolLoginFailure,
          (int, HttpResponse<dynamic>)
        >.left(login_failure.OtherFailure("Unknown loop back host: $s")),
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
      _vpnRaw
          .login(token: token, username: studentId, password: password)
          .wrapNetworkSafeTask(),
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
          login_failure.BadDataFailure(
            login_failure.BadDataType.other,
            false,
            "Unknown error",
          ),
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
      await $(
        TaskEither.left(login_failure.OtherFailure("login form not found")),
      );
      throw AssertionError("Unreachable code");
    }
    final loginExecution = loginForm
        .find("*", id: "execution")
        ?.getAttrValue("value");
    final loginSalt = loginForm
        .find("*", id: "pwdEncryptSalt")
        ?.getAttrValue("value");
    if (loginExecution == null) {
      await $(
        TaskEither.left(login_failure.OtherFailure("execution not found")),
      );
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
          login_failure.BadDataFailure(
            login_failure.BadDataType.password,
            true,
          ),
        ),
        final s when s.contains("入用户名") => TaskEither.left(
          login_failure.BadDataFailure(
            login_failure.BadDataType.username,
            true,
          ),
        ),
        _ => TaskEither.left(
          login_failure.BadDataFailure(login_failure.BadDataType.other, false),
        ),
      });
      throw AssertionError("Unreachable code");
    }
  }

  String _encryptPassword(String password, String salt) {
    final plain =
        "0000000000000000000000000000000000000000000000000000000000000000$password";
    final iv = encrypt.IV.fromUtf8("0000000000000000");
    final key = encrypt.Key.fromUtf8(salt);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return encrypted.base64;
  }

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> loopBackSafe<T>(
    Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> Function()
    function,
  ) async => (() => function()).loopbackSafe(() async => login(null));

  Future<
    Either<
      data_fetch_failure.SchoolDataFetchFailure,
      (AvailableTermTime, ClassTable)
    >
  >
  fetchClassTable({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ClassTable)>.Do(($) async {
        await $(
          login(null).wrapToTaskEither().mapLeft(
            (it) => data_fetch_failure.LoginFailure(it),
          ),
        );
        final defaultPageResult = await $(
          _eduRaw.getClassesPage().wrapNetworkSafeTask(),
        );
        final document = BeautifulSoup(defaultPageResult.data);
        final (
          availableTime,
          academicIndex,
          semesterIndex,
        ) = MjuAnalyzer.getClassAvailableTermTimeAndSelected(
          document,
          "xnm",
          "xqm",
        );
        final defaultAcademicYear =
            availableTime.availableAcademicYear[academicIndex];
        final defaultSemester = availableTime.availableSemester[semesterIndex];
        final (selectedAcademicYearRaw, selectedSemesterRaw) =
            dataPair ?? (null, null);
        final selectedAcademicYear =
            (selectedAcademicYearRaw ?? defaultAcademicYear.$1).let(
              (it) => availableTime.availableAcademicYear
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final selectedSemester = (selectedSemesterRaw ?? defaultSemester.$1)
            .let(
              (it) => availableTime.availableSemester
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final realAcademicYear = selectedAcademicYear.$2;
        final realSemester = selectedSemester.$2;
        final classesDataResult = await $(
          _eduRaw
              .getClassesData(
                academicYear: realAcademicYear,
                semester: realSemester,
              )
              .wrapNetworkSafeTask(),
        );
        final jsonData = classesDataResult.data;
        final classTable = await $(
          MjuAnalyzer.analyzeClassTable(
            jsonData,
            selectedAcademicYear.$1,
            selectedSemester.$1,
          ).toTaskEither(),
        );
        return (availableTime, classTable);
      }).mapLeft(_defaultFailureMapper).run();

  Future<
    Either<
      data_fetch_failure.SchoolDataFetchFailure,
      (AvailableTermTime, ExamsEntity)
    >
  >
  fetchExams({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ExamsEntity)>.Do(($) async {
        await $(
          login(null).wrapToTaskEither().mapLeft(
            (it) => data_fetch_failure.LoginFailure(it),
          ),
        );
        final defaultPageResult = await $(
          _eduRaw.getExamPage().wrapNetworkSafeTask(),
        );
        final document = BeautifulSoup(defaultPageResult.data);
        final (
          availableTime,
          academicIndex,
          semesterIndex,
        ) = MjuAnalyzer.getClassAvailableTermTimeAndSelected(
          document,
          "cx_xnm",
          "cx_xqm",
        );
        final defaultAcademicYear =
            availableTime.availableAcademicYear[academicIndex];
        final defaultSemester = availableTime.availableSemester[semesterIndex];
        final (selectedAcademicYearRaw, selectedSemesterRaw) =
            dataPair ?? (null, null);
        final selectedAcademicYear =
            (selectedAcademicYearRaw ?? defaultAcademicYear.$1).let(
              (it) => availableTime.availableAcademicYear
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final selectedSemester = (selectedSemesterRaw ?? defaultSemester.$1)
            .let(
              (it) => availableTime.availableSemester
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final realAcademicYear = selectedAcademicYear.$2;
        final realSemester = selectedSemester.$2;
        final timestamp = DateTime.timestamp().millisecondsSinceEpoch;
        final examsDataResult = await $(
          _eduRaw
              .getExamData(
                academicYear: realAcademicYear,
                semester: realSemester,
                timeStamp: "$timestamp",
              )
              .wrapNetworkSafeTask(),
        );
        final jsonData = examsDataResult.data;
        final classTable = await $(
          MjuAnalyzer.analyzeExams(
            jsonData,
            selectedAcademicYear.$1,
            selectedSemester.$1,
          ).toTaskEither(),
        );
        return (availableTime, classTable);
      }).mapLeft(_defaultFailureMapper).run();

  Future<
    Either<
      data_fetch_failure.SchoolDataFetchFailure,
      (AvailableTermTime, ScoresEntity)
    >
  >
  fetchScores({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ScoresEntity)>.Do(($) async {
        await $(
          login(null).wrapToTaskEither().mapLeft(
            (it) => data_fetch_failure.LoginFailure(it),
          ),
        );
        final defaultPageResult = await $(
          _eduRaw.getScorePage().wrapNetworkSafeTask(),
        );
        final document = BeautifulSoup(defaultPageResult.data);
        final (
          availableTime,
          academicIndex,
          semesterIndex,
        ) = MjuAnalyzer.getClassAvailableTermTimeAndSelected(
          document,
          "xnm",
          "xqm",
        );
        final defaultAcademicYear =
            availableTime.availableAcademicYear[academicIndex];
        final defaultSemester = availableTime.availableSemester[semesterIndex];
        final (selectedAcademicYearRaw, selectedSemesterRaw) =
            dataPair ?? (null, null);
        final selectedAcademicYear =
            (selectedAcademicYearRaw ?? defaultAcademicYear.$1).let(
              (it) => availableTime.availableAcademicYear
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final selectedSemester = (selectedSemesterRaw ?? defaultSemester.$1)
            .let(
              (it) => availableTime.availableSemester
                  .filter((x) => x.$1 == it)
                  .first,
            );
        final realAcademicYear = selectedAcademicYear.$2;
        final realSemester = selectedSemester.$2;
        final timestamp = DateTime.timestamp().millisecondsSinceEpoch;
        final scoresDataResult = await $(
          _eduRaw
              .getScoreData(
                academicYear: realAcademicYear,
                semester: realSemester,
                timestamp: "$timestamp",
              )
              .wrapNetworkSafeTask(),
        );
        final jsonData = scoresDataResult.data;
        final scores = await $(
          MjuAnalyzer.analyzeScores(
            jsonData,
            selectedAcademicYear.$1,
            selectedSemester.$1,
          ).toTaskEither(),
        );
        return (availableTime, scores);
      }).mapLeft(_defaultFailureMapper).run();

  data_fetch_failure.SchoolDataFetchFailure _defaultFailureMapper(
    dynamic error,
  ) => switch (error) {
    wrapper.RequestFailure() => error.asDataFetchFailure(),
    data_fetch_failure.SchoolDataFetchFailure() => error,
    _ => data_fetch_failure.OtherFailure("Unknown failure"),
  };
}
