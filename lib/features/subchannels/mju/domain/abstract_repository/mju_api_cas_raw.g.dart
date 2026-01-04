// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mju_api_cas_raw.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _MjuCasApiRaw implements MjuCasApiRaw {
  _MjuCasApiRaw(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://authserver.mju.edu.cn';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<HttpResponse<String>> getLoginPage({
    String service = "https://jwgl.mju.edu.cn/sso/zfiotlogin",
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
    required String randomFloat,
    required String username,
    required String password,
    String reserved1 = "",
    String reserved2 = "submit",
    required String execution,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'v': randomFloat};
    final _headers = <String, dynamic>{};
    final _data = {
      'username': username,
      'password': password,
      'authcode': reserved1,
      '_eventId': reserved2,
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

  @override
  Future<MjuLoginPublicKey> getPublicKey() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MjuLoginPublicKey>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/authserver/v2/getPubKey',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MjuLoginPublicKey _value;
    try {
      _value = MjuLoginPublicKey.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
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
