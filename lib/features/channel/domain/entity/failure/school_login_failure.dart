import 'package:dio/dio.dart';

sealed class SchoolLoginFailure {
  Exception asException() => switch (this) {
    final NetworkFailure x => Exception("Network failure: ${x.badResponse?.toString()}"),
    final BadDataFailure x => Exception(
      "Bad data: type: ${x.dataType}, empty: ${x.isEmpty}, extra: ${x.extra}",
    ),
    CaptchaFailure() => Exception("Captcha failure"),
    final OtherFailure x => x.exception,
  };
}

class NetworkFailure extends SchoolLoginFailure {
  Response<dynamic>? badResponse;

  NetworkFailure(this.badResponse);
}

enum BadDataType { username, password, both, other }

class BadDataFailure extends SchoolLoginFailure {
  BadDataType dataType;
  bool isEmpty;
  String? extra;

  BadDataFailure(this.dataType, this.isEmpty, [this.extra]);
}

class CaptchaFailure extends SchoolLoginFailure {}

class OtherFailure extends SchoolLoginFailure {
  late Exception exception;

  OtherFailure.fromException(this.exception);

  OtherFailure(String message) {
    exception = Exception(message);
  }
}
