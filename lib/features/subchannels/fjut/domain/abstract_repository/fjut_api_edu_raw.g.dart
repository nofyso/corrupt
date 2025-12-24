// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fjut_api_edu_raw.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _FjutEduApiRaw implements FjutEduApiRaw {
  _FjutEduApiRaw(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://jwxt-443.webvpn.fjut.edu.cn';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<HttpResponse<String>> getClassesPage({
    String functionModuleCode = "N253508",
    String layout = "default",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'gnmkdm': functionModuleCode,
      r'layout': layout,
    };
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
            '/jwglxt/kbcx/xskbcx_cxXskbcxIndex.html',
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
  Future<HttpResponse<String>> getClassesData({
    String functionModuleCode = "N2151",
    required String academicYear,
    required String semester,
    String reserved1 = "ck",
    String reserved2 = "",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'gnmkdm': functionModuleCode};
    final _headers = <String, dynamic>{};
    final _data = {
      'xnd': academicYear,
      'xqd': semester,
      'kzlx': reserved1,
      'xsdm': reserved2,
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
            '/jwglxt/kbcx/xskbcx_cxXsgrkb.html',
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
  Future<HttpResponse<String>> getExamPage({
    String functionModuleCode = "N358105",
    String layout = "default",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'gnmkdm': functionModuleCode,
      r'layout': layout,
    };
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
            '/jwglxt/kwgl/kscx_cxXsksxxIndex.html',
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
  Future<HttpResponse<String>> getExamData({
    String doType = "query",
    String functionModuleCode = "N358105",
    required String academicYear,
    required String semester,
    String reserved1 = "",
    String reserved2 = "",
    String reserved3 = "",
    String reserved4 = "",
    String reserved5 = "",
    String reserved6 = "false",
    required String timeStamp,
    String reserved7 = "5000",
    String reserved8 = "1",
    String reserved9 = "",
    String reserved10 = "asc",
    String reserved11 = "0",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'doType': doType,
      r'gnmkdm': functionModuleCode,
    };
    final _headers = <String, dynamic>{};
    final _data = {
      'xnd': academicYear,
      'xqd': semester,
      'ksmcdmb_id': reserved1,
      'kch': reserved2,
      'kc': reserved3,
      'ksrq': reserved4,
      'kkbm_id': reserved5,
      '_search': reserved6,
      'nd': timeStamp,
      'queryModel.showCount': reserved7,
      'queryModel.currentPage': reserved8,
      'queryModel.sortName': reserved9,
      'queryModel.sortOrder': reserved10,
      'time': reserved11,
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
            '/jwglxt/kwgl/kscx_cxXsksxxIndex.html',
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
