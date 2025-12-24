// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fafu_api_raw.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _FafuApiRaw implements FafuApiRaw {
  _FafuApiRaw(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://jwgl.fafu.edu.cn';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<HttpResponse<dynamic>> getLoginPage() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCheckCode({required String token}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/CheckCode.aspx',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getMainPage({
    required String token,
    required String studentId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'xh': studentId};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xs_main.aspx',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getClassesPageDefault({
    required String token,
    required String studentId,
    required String studentName,
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xskbcx.aspx?gnmkdm=N121603',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getClassesPage({
    required String token,
    required String studentId,
    required String studentName,
    required String viewState,
    required String academicYear,
    required String semester,
    String eventTarget = "",
    String eventTArgument = "",
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      '__VIEWSTATE': viewState,
      'xnd': academicYear,
      'xqd': semester,
      '__EVENTTARGET': eventTarget,
      '__EVENTARGUMENT': eventTArgument,
    };
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xskbcx.aspx?gnmkdm=N121603',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getExamPageDefault({
    required String token,
    required String studentId,
    required String studentName,
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xskscx.aspx?gnmkdm=N121604',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getExamPage({
    required String token,
    required String studentId,
    required String studentName,
    required String viewState,
    required String academicYear,
    required String semester,
    String eventTarget = "",
    String eventTArgument = "",
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      '__VIEWSTATE': viewState,
      'xnd': academicYear,
      'xqd': semester,
      '__EVENTTARGET': eventTarget,
      '__EVENTARGUMENT': eventTArgument,
    };
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xskscx.aspx?gnmkdm=N121604',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getScorePageDefault({
    required String token,
    required String studentId,
    required String studentName,
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xscjcx_dq_fafu.aspx?gnmkdm=N121605',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getScorePage({
    required String token,
    required String studentId,
    required String studentName,
    required String viewState,
    required String academicYear,
    required String semester,
    String eventTarget = "",
    String eventTArgument = "",
    String queryButton = "+%B2%E9++%D1%AF+",
    required String referer,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      '__VIEWSTATE': viewState,
      'ddlxn': academicYear,
      'ddlxq': semester,
      '__EVENTTARGET': eventTarget,
      '__EVENTARGUMENT': eventTArgument,
      'btnCx': queryButton,
    };
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xscjcx_dq_fafu.aspx?gnmkdm=N121605',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getScorePageManually({
    required String token,
    required String studentId,
    required String studentName,
    required String referer,
    required String body,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'xh': studentId,
      r'xm': studentName,
    };
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    final _data = body;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/xscjcx_dq_fafu.aspx?gnmkdm=N121605',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> submitLogin({
    required String token,
    required String referer,
    required String body,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Referer': referer};
    _headers.removeWhere((k, v) => v == null);
    final _data = body;
    final _options = _setStreamType<HttpResponse<dynamic>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          )
          .compose(
            _dio.options,
            '/(${token})/default2.aspx',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
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
    if (baseUrl == null || baseUrl.trim().isEmpty) {
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
