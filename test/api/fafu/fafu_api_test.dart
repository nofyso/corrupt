import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/subchannels/fafu/data/fafu_api.dart';
import 'package:corrupt/features/subchannels/fafu/domain/abstract_repository/fafu_api_raw.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_data_key.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_request_parameters.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

import 'fafu_api_moc_data.dart';
@GenerateNiceMocks([MockSpec<FafuApiRaw>(), MockSpec<LocalRawDataRepository>()])
import 'fafu_api_test.mocks.dart';

const _baseUrl = "http://jwgl.fafu.edu.cn";

void main() {
  late FafuApiRaw rawApi;
  late FafuApi api;
  late LocalRawDataRepository localRawDataRepository;
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencies();
    getIt.unregister<FafuApiRaw>();
    getIt.unregister<LocalRawDataRepository>();
    getIt.registerLazySingleton<FafuApiRaw>(() => MockFafuApiRaw());
    getIt.registerLazySingleton<LocalRawDataRepository>(() => MockLocalRawDataRepository());
    await getIt.allReady();
    localRawDataRepository = getIt();
    rawApi = getIt();
    api = getIt();
  });
  group('fafu login api', () {
    test('with valid data - should return valid login result', () async {
      _mockLoginCommon(rawApi, api, localRawDataRepository);
      _mockLoginResult(
        rawApi,
        FafuApiMockData.mockToken,
        FafuApiMockData.validLoginViewState,
        FafuApiMockData.validUserId,
        FafuApiMockData.validPassword,
        FafuApiMockData.validCaptcha,
        "main_page.html",
        "/xs_main.aspx?xh=${FafuApiMockData.validUserId}",
      );
      final result = await api.login(
        FafuLoginParameter(FafuApiMockData.validUserId, FafuApiMockData.validPassword),
      );
      expect(result.isRight(), true);
    });
    test(
      'with invalid username - should return BadDataFailure left with BadDataType.username',
      () async {
        _mockLoginCommon(rawApi, api, localRawDataRepository);
        _mockLoginResult(
          rawApi,
          FafuApiMockData.mockToken,
          FafuApiMockData.validLoginViewState,
          "invalidUsername",
          FafuApiMockData.validPassword,
          FafuApiMockData.validCaptcha,
          "login_page_invalid_username.html",
          "/",
        );
        final result = await api.login(
          FafuLoginParameter("invalidUsername", FafuApiMockData.validPassword),
        );
        expect(result.isLeft(), true);
        expect((result.getLeft().toNullable()!) is login_failure.BadDataFailure, true);
        expect(
          ((result.getLeft().toNullable()!) as login_failure.BadDataFailure).dataType ==
              login_failure.BadDataType.username,
          true,
        );
      },
    );
    test(
      'with invalid password - should return BadDataFailure left with BadDataType.password and extra',
      () async {
        _mockLoginCommon(rawApi, api, localRawDataRepository);
        _mockLoginResult(
          rawApi,
          FafuApiMockData.mockToken,
          FafuApiMockData.validLoginViewState,
          FafuApiMockData.validUserName,
          "invalidPassword",
          FafuApiMockData.validCaptcha,
          "login_page_invalid_password.html",
          "/",
        );
        final result = await api.login(
          FafuLoginParameter(FafuApiMockData.validUserName, "invalidPassword"),
        );
        expect(result.isLeft(), true);
        expect((result.getLeft().toNullable()!) is login_failure.BadDataFailure, true);
        final failure = result.getLeft().toNullable()! as login_failure.BadDataFailure;
        expect(failure.dataType == login_failure.BadDataType.password, true);
        expect(failure.extra == "4", true);
      },
    );
  });
  tearDown(() async {
    await getIt.reset(dispose: true);
  });
}

void _mockLoginResult(
  FafuApiRaw rawApi,
  String token,
  String viewState,
  String userId,
  String password,
  String captcha,
  String mockFile,
  String path,
) {
  when(
    rawApi.submitLogin(
      token: FafuApiMockData.mockToken,
      referer: "$_baseUrl/($token)/default2.aspx",
      body:
          "__VIEWSTATE=${Uri.encodeComponent(viewState)}&txtUserName=$userId&TextBox2=${Uri.encodeComponent(password)}&txtSecretCode=$captcha&loginType=%D1%A7%C9%FA&Button1=&lbLanguage=&hidPdrs=&hidsc=",
    ),
  ).thenAnswer((_) => _getFafuMockFile(mockFile, path));
}

void _mockLoginCommon(
  FafuApiRaw rawApi,
  FafuApi api,
  LocalRawDataRepository localRawDataRepository,
) {
  when(rawApi.getLoginPage()).thenAnswer((_) => _getFafuMockFile("login_page.html", "/"));
  when(
    rawApi.getCheckCode(token: FafuApiMockData.mockToken),
  ).thenAnswer((_) => _getFafuMockFile("check_code.gif", "/CheckCode.aspx"));
  when(localRawDataRepository.getData(FafuDataKey.studentId)).thenAnswer((_) async => "");
  when(localRawDataRepository.getData(FafuDataKey.password)).thenAnswer((_) async => "");
  when(
    localRawDataRepository.setData(FafuDataKey.studentId, FafuApiMockData.validUserId),
  ).thenAnswer((_) async {});
  when(
    localRawDataRepository.setData(FafuDataKey.password, FafuApiMockData.validPassword),
  ).thenAnswer((_) async {});
  when(
    localRawDataRepository.setData(FafuDataKey.studentName, FafuApiMockData.validUserName),
  ).thenAnswer((_) async {});
  when(
    localRawDataRepository.setData(FafuDataKey.token, FafuApiMockData.mockToken),
  ).thenAnswer((_) async {});
}

Future<HttpResponse<dynamic>> _getFafuMockFile(
  String fileName,
  String url, [
  bool decode = true,
]) async => rootBundle
    .load("test/api/fafu/test_data/$fileName")
    .then((data) => decode ? data.buffer.asUint8List() : data)
    .then(
      (data) => HttpResponse(
        data,
        Response(
          requestOptions: RequestOptions(
            baseUrl: _baseUrl,
            path: "/(${FafuApiMockData.mockToken})$url",
          ),
          data: data,
        ),
      ),
    );
