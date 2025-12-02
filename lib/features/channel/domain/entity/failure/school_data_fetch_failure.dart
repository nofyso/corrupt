import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:dio/dio.dart';

sealed class SchoolDataFetchFailure {
  Exception asException() => switch (this) {
    final NetworkFailure x => Exception("Network failure: ${x.badResponse?.toString()}"),
    final LoginFailure x => x.loginFailure.asException(),
    LoopbackFailure() => Exception("Loop backed"),
    final OtherFailure x => x.exception,
    NotImplementedFailure() => Exception("Not implemented"),
    NotLoggedFailure() => Exception("Not logged"),
  };
}

class NetworkFailure extends SchoolDataFetchFailure {
  Response<dynamic>? badResponse;

  NetworkFailure(this.badResponse);
}

class LoginFailure extends SchoolDataFetchFailure {
  login_failure.SchoolLoginFailure loginFailure;

  LoginFailure(this.loginFailure);
}

class LoopbackFailure extends SchoolDataFetchFailure {}

class NotImplementedFailure extends SchoolDataFetchFailure {}

class NotLoggedFailure extends SchoolDataFetchFailure {}

class OtherFailure extends SchoolDataFetchFailure {
  late Exception exception;

  OtherFailure.fromException(this.exception);

  OtherFailure(String message) {
    exception = Exception(message);
  }
}
