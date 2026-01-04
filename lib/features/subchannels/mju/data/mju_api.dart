import 'dart:math';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/features/pref/domain/use_case/prefs_usecase.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_analyzer.dart';
import 'package:corrupt/features/subchannels/mju/data/mju_encrypt_util.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_api_cas_raw.dart';
import 'package:corrupt/features/subchannels/mju/domain/abstract_repository/mju_api_edu_raw.dart';
import 'package:corrupt/features/subchannels/mju/domain/entity/mju_data_key.dart';
import 'package:corrupt/features/subchannels/mju/domain/entity/mju_request_parameter.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/util/regex_helper.dart';
import 'package:corrupt/util/wrapper.dart' as wrapper;
import 'package:dartlin/dartlin.dart';
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/dio.dart';

class MjuApi {
  static final _executionRegex =
      "(?<=name=\"execution\" value=\").*?(?=\")".asRegExp;
  static final _errorMsgRegex = "(?<=<span id=\"msg\">).*?(?=</span>)".asRegExp;
  static const _loopback0 = "jwgl.mju.edu.cn";
  static const _loopback1 = "authserver.mju.edu.cn";

  final _casRaw = getIt<MjuCasApiRaw>();
  final _eduRaw = getIt<MjuEduApiRaw>();
  final _prefReadUseCase = getIt<PrefReadUseCase>();
  final _prefWriteUseCase = getIt<PrefWriteUseCase>();

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> loopBackSafe<T>(
    Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> Function()
    function,
  ) async => (() => function()).loopbackSafe(() async => login(null));

  Future<Either<login_failure.SchoolLoginFailure, MjuLoginResult>> login(
    MjuLoginParameter? newParameter,
  ) async {
    final parameter =
        newParameter ??
        MjuLoginParameter(
          await _prefReadUseCase.read(MjuDataKey.studentId),
          await _prefReadUseCase.read(MjuDataKey.password),
        );
    final result = await _login(parameter.studentId, parameter.password);
    await result.match((_) {}, (right) async {
      await _prefWriteUseCase.write(MjuDataKey.studentId, parameter.studentId);
      await _prefWriteUseCase.write(MjuDataKey.password, parameter.password);
    });
    return result;
  }

  Future<Either<login_failure.SchoolLoginFailure, MjuLoginResult>> _login(
    String studentId,
    String password,
  ) async =>
      TaskEither<dynamic, MjuLoginResult>.Do(($) async {
            for (final _ in 0.to(5)) {
              final (loopbackLevel, loopbackResponse) = await _checkLoopback($);
              if (loopbackLevel == 1) {
                await _casLogin(studentId, password, loopbackResponse, $);
                continue;
              }
              return MjuLoginResult();
            }
            await $(
              TaskEither.left(
                login_failure.OtherFailure("Too many trials, unknown error"),
              ),
            );
            throw AssertionError("Unreachable code");
          })
          .mapLeft(
            (err) => switch (err) {
              login_failure.SchoolLoginFailure() => err,
              wrapper.RequestFailure() => err.asLoginFailure(),
              _ => login_failure.OtherFailure("Unknown failure"),
            },
          )
          .run();

  Future<void> _casLogin(
    String studentId,
    String password,
    HttpResponse<dynamic> loopbackResponse,
    Future<A> Function<A>(TaskEither<dynamic, A>) $,
  ) async {
    final casLoginPage = loopbackResponse.data as String;
    final execution = await $(
      casLoginPage
          .matchFirst(_executionRegex)
          .toTaskOption()
          .toTaskEither(
            () => login_failure.OtherFailure("execution not found"),
          ),
    );
    final publicKey = await $(_casRaw.getPublicKey().wrapNetworkSafeTask());
    final encryptedPassword = MjuEncryptUtil.encrypt(
      publicKey.modulus,
      publicKey.exponent,
      password,
    );
    final random = Random();
    final casLoginResponse = await $(
      _casRaw
          .login(
            randomFloat: "${random.nextDouble()}",
            username: studentId,
            password: encryptedPassword,
            execution: execution,
          )
          .wrapNetworkSafeTask(),
    );
    if (casLoginResponse.response.realUri.host == _loopback1) {
      final errorMsg = await $(
        casLoginResponse.data
            .matchFirst(_errorMsgRegex)
            .toTaskOption()
            .toTaskEither(
              () => login_failure.OtherFailure("errorMsg not found"),
            ),
      );
      await $(
        TaskEither.left(switch (errorMsg) {
          final s when s.contains("录入密码") => login_failure.BadDataFailure(
            login_failure.BadDataType.password,
            true,
          ),
          final s when s.contains("录入用户名") => login_failure.BadDataFailure(
            login_failure.BadDataType.username,
            true,
          ),
          final s when s.contains("错误") => login_failure.BadDataFailure(
            login_failure.BadDataType.both,
            false,
          ),
          _ => login_failure.OtherFailure("Unknown error"),
        }),
      );
      throw AssertionError("Unreachable code");
    }
  }

  int _getLoopbackLevel(Uri uri) {
    return switch (uri.host) {
      _loopback1 => 1,
      _loopback0 => 0,
      _ => -1,
    };
  }

  Future<(int, HttpResponse<dynamic>)> _checkLoopback(
    Future<A> Function<A>(TaskEither<dynamic, A>) $,
  ) async {
    final initLoginPage = await $(_casRaw.getLoginPage().wrapNetworkSafeTask());
    final loopbackLevel = _getLoopbackLevel(initLoginPage.response.realUri);
    if (loopbackLevel == -1) {
      await $(
        TaskEither<
          login_failure.SchoolLoginFailure,
          (int, HttpResponse<dynamic>)
        >.left(
          login_failure.OtherFailure(
            "Unknown loop back host: ${initLoginPage.response.realUri.toString()}",
          ),
        ),
      );
    }
    return (loopbackLevel, initLoginPage);
  }

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
                timestamp: "$timestamp",
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
