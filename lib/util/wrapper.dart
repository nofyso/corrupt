import 'dart:convert';

import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:dartlin/dartlin.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

Option<dynamic> jsonDecodeSafe(String text) =>
    tryy(() => Option.of(jsonDecode(text))).orElse(() => Option.none());

Option<String> jsonEncodeSafe(dynamic object) =>
    tryy(() => Option.of(jsonEncode(object))).orElse(() => Option.none());

Option<T> jsonDecodeSafeDirect<T>(
  String text,
  T Function(Map<String, dynamic>) fromJson,
) => tryy(
  () => Option.of(fromJson(jsonDecode(text))),
).orElse(() => Option.none());

extension LoopbackWrapper<T, LR>
    on Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> Function() {
  Future<Either<data_fetch_failure.SchoolDataFetchFailure, T>> loopbackSafe(
    Future<Either<login_failure.SchoolLoginFailure, LR>> Function()
    loginFunction,
  ) async {
    data_fetch_failure.SchoolDataFetchFailure? lastError;
    for (final _ in 1.to(5)) {
      final trial = await this();
      switch (trial) {
        case Right<data_fetch_failure.SchoolDataFetchFailure, T>(
          value: final value,
        ):
          return Either.right(value);
        case Left<data_fetch_failure.SchoolDataFetchFailure, T>(
          value: final error,
        ):
          lastError = error;
          switch (error) {
            case data_fetch_failure.NetworkFailure() ||
                data_fetch_failure.LoginFailure() || //This never happen
                data_fetch_failure.NotImplementedFailure() ||
                data_fetch_failure.NotLoggedFailure() ||
                data_fetch_failure.OtherFailure():
              //TODO add exception handle and data invalidate when login data error
              return Either.left(error);
            case data_fetch_failure.LoopbackFailure():
              final loginResult = await loginFunction();
              switch (loginResult) {
                case Right<login_failure.SchoolLoginFailure, LR>():
                  continue;
                case Left<login_failure.SchoolLoginFailure, LR>(
                  value: final error,
                ):
                  lastError = data_fetch_failure.LoginFailure(error);
                  switch (error) {
                    case login_failure.NetworkFailure(
                      badResponse: final badResponse,
                    ):
                      if (badResponse != null) {
                        return Either.left(
                          data_fetch_failure.LoginFailure(error),
                        );
                      }
                      continue;
                    case login_failure.CaptchaFailure():
                      continue;
                    case login_failure.BadDataFailure():
                    case login_failure.OtherFailure():
                      return Either.left(
                        data_fetch_failure.LoginFailure(error),
                      );
                  }
              }
          }
      }
    }
    return Either.left(lastError ?? data_fetch_failure.LoopbackFailure());
  }
}

extension Wrapper<T> on Future<T> {
  Future<Either<RequestFailure, T>> wrapNetworkSafe() async {
    try {
      return Either.right(await this);
    } on DioException catch (e) {
      return switch (e.type) {
        DioExceptionType.badResponse => Either.left(
          NetworkFailure(badResponse: e.response),
        ),
        DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => Either.left(NetworkFailure()),
        _ => Either.left(OtherFailure(e)),
      };
    } on Exception catch (e) {
      return Either.left(OtherFailure(e));
    }
  }

  TaskEither<RequestFailure, T> wrapNetworkSafeTask() =>
      wrapNetworkSafe().wrapToTaskEither();
}

extension WrapTaskEither<L, R> on Future<Either<L, R>> {
  TaskEither<L, R> wrapToTaskEither() => TaskEither(() => this);
}

sealed class RequestFailure {
  login_failure.SchoolLoginFailure asLoginFailure() => switch (this) {
    NetworkFailure(badResponse: final badResponse) =>
      login_failure.NetworkFailure(badResponse),
    OtherFailure(error: final error) =>
      login_failure.OtherFailure.fromException(error),
  };

  data_fetch_failure.SchoolDataFetchFailure asDataFetchFailure() =>
      switch (this) {
        NetworkFailure(badResponse: final badResponse) =>
          data_fetch_failure.NetworkFailure(badResponse),
        OtherFailure(error: final error) =>
          data_fetch_failure.OtherFailure.fromException(error),
      };
}

class NetworkFailure extends RequestFailure {
  Response<dynamic>? badResponse;

  NetworkFailure({this.badResponse});
}

class OtherFailure extends RequestFailure {
  Exception error;

  OtherFailure(this.error);
}
