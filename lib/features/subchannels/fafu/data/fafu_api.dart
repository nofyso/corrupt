import 'dart:typed_data';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:charset/charset.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/features/larva/domain/abstract_repository/larva_repository.dart';
import 'package:corrupt/features/larva/domain/entity/larva_failure.dart' as larva;
import 'package:corrupt/features/pref/domain/use_case/prefs_usecase.dart';
import 'package:corrupt/features/subchannels/fafu/data/fafu_analyzer.dart';
import 'package:corrupt/features/subchannels/fafu/domain/abstract_repository/fafu_api_raw.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_data_key.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_request_parameters.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/util/regex_helper.dart';
import 'package:corrupt/util/wrapper.dart' as wrapper;
import 'package:dartlin/collections.dart';
import 'package:dartlin/control_flow.dart';
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

class FafuApi {
  static final _passwordRetryRegex = RegExp("(?<=您还有).*?(?=次尝试机会)");
  static final _alertRegex = RegExp("(?<=alert\\(\\').*?(?=\\')");
  static final _viewStateRegex = RegExp("(?<=__VIEWSTATE\" value=\").*?(?=\")");

  final _prefReadUseCase = getIt<PrefReadUseCase>();
  final _prefWriteUseCase = getIt<PrefWriteUseCase>();
  final _larvaUsecase = getIt<LarvaRepository>();
  final _raw = getIt<FafuApiRaw>();

  Future<Either<login_failure.SchoolLoginFailure, FafuLoginResult>> login(
    FafuLoginParameter? newParameter,
  ) async {
    final parameter =
        newParameter ??
        FafuLoginParameter(
          await _prefReadUseCase.read(FafuDataKey.studentId),
          await _prefReadUseCase.read(FafuDataKey.password),
        );
    final result = await _login(parameter.studentId, parameter.password);
    await result.match((_) {}, (right) async {
      await _prefWriteUseCase.write(FafuDataKey.studentId, parameter.studentId);
      await _prefWriteUseCase.write(FafuDataKey.password, parameter.password);
      await _prefWriteUseCase.write(FafuDataKey.studentName, right.studentName);
      await _prefWriteUseCase.write(FafuDataKey.token, right.token);
    });
    return result;
  }

  Future<Either<login_failure.SchoolLoginFailure, FafuLoginResult>> _login(
    String studentId,
    String password,
  ) async =>
      TaskEither<dynamic, FafuLoginResult>.Do(($) async {
            final loginPageResult = await $(_raw.getLoginPage().wrapNetworkSafeTask());
            final loginPage = loginPageResult.asGbkString();
            final uri = loginPageResult.response.realUri;
            final token = (uri.pathSegments.getOrNull(0) ?? "(invalid)").let(
              (it) => it.length < 2 ? "()" : it.substring(1, it.length - 1),
            );
            final viewState = await $(
              loginPage
                  .matchFirst(_viewStateRegex)
                  .toTaskOption()
                  .toTaskEither(() => login_failure.OtherFailure("viewState not found")),
            );
            final checkCodeDataPage = await $(
              _raw.getCheckCode(token: token).wrapNetworkSafeTask(),
            );
            final checkCodeData = checkCodeDataPage.response.data as Uint8List;
            final captcha = await $(
              _larvaUsecase
                  .predict(imageData: checkCodeData, modelPath: "assets/net")
                  .wrapToTaskEither(),
            );
            final loginResponse = await $(
              submitLogin(
                token: token,
                studentId: studentId,
                password: password,
                captcha: captcha,
                viewState: viewState,
              ).wrapNetworkSafeTask(),
            );
            final loginResponseUrl = loginResponse.response.realUri;
            final loginResponseDocument = BeautifulSoup(loginResponse.asGbkString());
            if (_isLoopback(loginResponseUrl)) {
              final alert = await $(
                loginResponse
                    .asGbkString()
                    .matchFirst(_alertRegex)
                    .toTaskOption()
                    .toTaskEither(() => Exception("alert not found")),
              );
              await $(switch (alert) {
                final s when s.contains("验证码") => TaskEither.left(login_failure.CaptchaFailure()),
                final s when s.contains("用户名不存在") => TaskEither.left(
                  login_failure.BadDataFailure(login_failure.BadDataType.username, false),
                ),
                final s when s.contains("密码错误") => TaskEither.left(
                  login_failure.BadDataFailure(
                    login_failure.BadDataType.password,
                    false,
                    alert.matchFirst(_passwordRetryRegex).toNullable(),
                  ),
                ),
                final s when s.contains("用户名不能为空") => TaskEither.left(
                  login_failure.BadDataFailure(login_failure.BadDataType.username, true),
                ),
                final s when s.contains("密码不能为空") => TaskEither.left(
                  login_failure.BadDataFailure(login_failure.BadDataType.password, true),
                ),
                final s => TaskEither.left(
                  login_failure.BadDataFailure(login_failure.BadDataType.other, false, s),
                ),
              });
            }
            final internalErrorResult = loginResponseDocument
                .find("div", id: "content_no")
                ?.find("p", class_: "t14");
            if (internalErrorResult != null) {
              final rawErrorString = internalErrorResult.string;
              final errorString = rawErrorString.substring(
                rawErrorString.lastIndexOf("：").let((it) => it == -1 ? 0 : it + 1),
              );
              await $(
                TaskEither.left(login_failure.OtherFailure("server internal error: $errorString")),
              );
            }
            final nameElementList = loginResponseDocument.find("*", id: "xhxm");
            if (nameElementList == null) {
              await $(TaskEither.left(login_failure.NetworkFailure(loginResponse.response)));
            }
            final name = ((nameElementList?.text ?? "")).replaceAll("同学", "");
            return FafuLoginResult(name, token);
          })
          .mapLeft(
            (err) => switch (err) {
              larva.LarvaFailure() => switch (err) {
                larva.FileFailure() => login_failure.OtherFailure("Larva error: corrupted file"),
                larva.TensorFailure() => login_failure.OtherFailure(
                  "Larva error: bad tensor procession",
                ),
              },
              wrapper.RequestFailure() => err.asLoginFailure(),
              login_failure.SchoolLoginFailure() => err,
              _ => login_failure.OtherFailure("Unexpected exception"),
            },
          )
          .run();

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, (AvailableTermTime, ClassTable)>>
  fetchClassTable({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ClassTable)>.Do(($) async {
        final token = await _prefReadUseCase.read(FafuDataKey.token);
        final studentId = await _prefReadUseCase.read(FafuDataKey.studentId);
        final studentName = await _prefReadUseCase.read(FafuDataKey.studentName);
        final referer = _getReferer(token: token, studentId: studentId);
        final defaultPageResult = await $(
          _raw
              .getClassesPageDefault(
                token: token,
                studentId: studentId,
                studentName: studentName,
                referer: referer,
              )
              .wrapNetworkSafeTask(),
        );
        if (_isLoopback(defaultPageResult.response.realUri)) {
          await $(TaskEither.left(data_fetch_failure.LoopbackFailure()));
        }
        final defaultPage = defaultPageResult.asGbkString();
        final (academicYearDefault, semesterDefault) = await $(
          FafuAnalyzer.getSelectedTime(defaultPage).toTaskOption().toTaskEither(
            () => data_fetch_failure.OtherFailure(
              "failed to fetch default academic year and semester",
            ),
          ),
        );
        if (dataPair == null ||
            (dataPair.$1 == academicYearDefault && dataPair.$2 == semesterDefault)) {
          return await $(FafuAnalyzer.analyzeClassTable(defaultPage).toTaskEither());
        }
        final viewState = _getViewState(defaultPage);
        final (academicYear, semester) = dataPair;
        final selectedClassPageResult = await $(
          _raw
              .getClassesPage(
                token: token,
                studentId: studentId,
                studentName: studentName,
                viewState: viewState,
                academicYear: academicYear,
                semester: semester,
                referer: referer,
              )
              .wrapNetworkSafeTask(),
        );
        if (_isLoopback(selectedClassPageResult.response.realUri)) {
          await $(TaskEither.left(data_fetch_failure.LoopbackFailure()));
        }
        final selectedClassPage = selectedClassPageResult.asGbkString();
        return await $(FafuAnalyzer.analyzeClassTable(selectedClassPage).toTaskEither());
      }).mapLeft(_defaultErrorMapper).run();

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, (AvailableTermTime, ExamsEntity)>>
  fetchExams({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ExamsEntity)>.Do(($) async {
        final token = await _prefReadUseCase.read(FafuDataKey.token);
        final studentId = await _prefReadUseCase.read(FafuDataKey.studentId);
        final studentName = await _prefReadUseCase.read(FafuDataKey.studentName);
        final referer = _getReferer(token: token, studentId: studentId);
        final defaultPageResult = await $(
          _raw
              .getExamPageDefault(
                token: token,
                studentId: studentId,
                studentName: studentName,
                referer: referer,
              )
              .wrapNetworkSafeTask(),
        );
        if (_isLoopback(defaultPageResult.response.realUri)) {
          await $(TaskEither.left(data_fetch_failure.LoopbackFailure()));
        }
        final defaultPage = defaultPageResult.asGbkString();
        final (academicYearDefault, semesterDefault) = await $(
          FafuAnalyzer.getSelectedTime(defaultPage).toTaskOption().toTaskEither(
            () => data_fetch_failure.OtherFailure(
              "failed to fetch default academic year and semester",
            ),
          ),
        );
        if (dataPair == null ||
            (dataPair.$1 == academicYearDefault && dataPair.$2 == semesterDefault)) {
          return await $(FafuAnalyzer.analyzeExams(defaultPage).toTaskEither());
        }
        final viewState = _getViewState(defaultPage);
        final (academicYear, semester) = dataPair;
        final selectedClassPageResult = await $(
          _raw
              .getExamPage(
                token: token,
                studentId: studentId,
                studentName: studentName,
                viewState: viewState,
                academicYear: academicYear,
                semester: semester,
                referer: referer,
              )
              .wrapNetworkSafeTask(),
        );
        if (_isLoopback(selectedClassPageResult.response.realUri)) {
          await $(TaskEither.left(data_fetch_failure.LoopbackFailure()));
        }
        final selectedClassPage = selectedClassPageResult.asGbkString();
        return await $(FafuAnalyzer.analyzeExams(selectedClassPage).toTaskEither());
      }).mapLeft(_defaultErrorMapper).run();

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, (AvailableTermTime, ScoresEntity)>>
  fetchScores({(String academicYear, String semester)? dataPair}) async =>
      TaskEither<dynamic, (AvailableTermTime, ScoresEntity)>.Do(($) async {
        final token = await _prefReadUseCase.read(FafuDataKey.token);
        final studentId = await _prefReadUseCase.read(FafuDataKey.studentId);
        final studentName = await _prefReadUseCase.read(FafuDataKey.studentName);
        final defaultPageResult = await $(
          _raw
              .getScorePageDefault(
                token: token,
                studentId: studentId,
                studentName: studentName,
                referer: _getReferer(token: token, studentId: studentId),
              )
              .wrapNetworkSafeTask(),
        );
        if (_isLoopback(defaultPageResult.response.realUri)) {
          await $(TaskEither.left(data_fetch_failure.LoopbackFailure()));
        }
        final defaultPage = defaultPageResult.asGbkString();
        final (academicYearDefault, semesterDefault) = await $(
          FafuAnalyzer.getSelectedTime(
            defaultPage,
            academicYearId: "ddlxn",
            semesterId: "ddlxq",
          ).toTaskOption().toTaskEither(
            () => data_fetch_failure.OtherFailure(
              "failed to fetch default academic year and semester",
            ),
          ),
        );
        //TODO add scores
        return await $(FafuAnalyzer.analyzeScores(defaultPage).toTaskEither());
      }).mapLeft(_defaultErrorMapper).run();

  data_fetch_failure.SchoolDataFetchFailure _defaultErrorMapper(dynamic error) => switch (error) {
    wrapper.RequestFailure() => error.asDataFetchFailure(),
    data_fetch_failure.SchoolDataFetchFailure() => error,
    _ => data_fetch_failure.OtherFailure("Unknown failure"),
  };

  String _getViewState(String htmlString) => (_viewStateRegex.firstMatch(htmlString)?.group(0))!;

  /// Motherfucker website, GB2312 encoding??? come on...
  /// I HAVE TO write such ugly code for your son of bitch api,
  /// or modify the dart.retrofit library(?), so fuck you the website.
  /// Can you see these motherfucking arg names? I'll show you:
  /// txtUserName TextBox2 txtSecretCode loginType Button1 lbLanguage hidPdrs
  /// Did they just use default name given by IDE from 2003 without thinking
  /// more for just a bit more time??? And, token in path without HTTPS??? You
  /// just want to expose users' secrets to ANYONE, right?!
  /// Anyway, fuck the shit.
  Future<HttpResponse<dynamic>> submitLogin({
    required String token,
    required String studentId,
    required String password,
    required String captcha,
    required String viewState,
  }) async => _raw.submitLogin(
    token: token,
    body:
        "__VIEWSTATE=${Uri.encodeComponent(viewState)}&txtUserName=$studentId&TextBox2=${Uri.encodeComponent(password)}&txtSecretCode=$captcha&loginType=%D1%A7%C9%FA&Button1=&lbLanguage=&hidPdrs=&hidsc=",
    referer: "http://jwgl.fafu.edu.cn/($token)/default2.aspx",
  );

  Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> loopBackSafe<T>(
    Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> Function() function,
  ) async => function().loopbackSafe(() async => login(null));

  String _getReferer({required String token, required String studentId}) =>
      "http://jwgl.fafu.edu.cn/($token)/xs_main.aspx?xh=$studentId";

  bool _isLoopback(Uri uri) =>
      uri.pathSegments.lastOrNull == "default2.aspx" ||
      uri.pathSegments.lastOrNull?.isEmpty == true;
}

extension on HttpResponse<dynamic> {
  String asGbkString() => gbk.decode(data as Uint8List);
}
