// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fjut_api_cas_raw.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _FjutCasApiRaw implements FjutCasApiRaw {
  _FjutCasApiRaw(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://nids-443.webvpn.fjut.edu.cn';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<HttpResponse<String>> getLoginPage({
    String service = "https://jwxt-443.webvpn.fjut.edu.cn/sso/jziotlogin",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'service': service};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<String>>(
      Options(
        method: 'GET',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.plain,
      )
          .compose(
        _dio.options,
        '/authserver/login',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<String>> login({
    String service = "https://jwxt-443.webvpn.fjut.edu.cn/sso/jziotlogin",
    required String username,
    required String password,
    String reserved1 = "",
    String reserved2 = "submit",
    String reserved3 = "userNameLogin",
    String reserved4 = "generalLogin",
    String reserved5 = "",
    required String execution,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'service': service};
    final _headers = <String, dynamic>{};
    final _data = {
      'username': username,
      'password': password,
      'captcha': reserved1,
      '_eventId': reserved2,
      'cllt': reserved3,
      'dllt': reserved4,
      'lt': reserved5,
      'execution': execution,
    };
    final _options = _setStreamType<HttpResponse<String>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded',
        responseType: ResponseType.plain,
      )
          .compose(
        _dio.options,
        '/authserver/login',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl
        .trim()
        .isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
