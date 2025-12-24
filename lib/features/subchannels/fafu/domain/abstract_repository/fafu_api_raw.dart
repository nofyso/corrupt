/*
 * WARNING
 * This file implements a VERY OUT DATED interface, and all of its work is to
 * hide the shit-like backend interactive logic. Avoid modification if at ALL
 * POSSIBLE.
 *
 * 警告
 * 此文件为一个极度老旧的接口提供实现，这个文件旨在隐藏过时且脱离现代的后端交互，如非必要，
 * 请勿修改。
 */

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'fafu_api_raw.g.dart';

@RestApi(baseUrl: "http://jwgl.fafu.edu.cn")
abstract class FafuApiRaw {
  static const _viewState = "__VIEWSTATE";
  static const _eventTarget = "__EVENTTARGET";
  static const _eventTArgument = "__EVENTARGUMENT";
  static const _functionModuleCode = "gnmkdm";
  static const _studentId = "xh";
  static const _studentName = "xm";
  static const _academicYear = "xnd";
  static const _semester = "xqd";
  static const _academicYearInScore = "ddlxn";
  static const _semesterInScore = "ddlxq";
  static const _token = "token";
  static const _referer = "Referer";

  factory FafuApiRaw(Dio dio, {String baseUrl}) = _FafuApiRaw;

  @GET("/")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getLoginPage();

  @GET("/({$_token})/CheckCode.aspx")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getCheckCode({@Path(_token) required String token});

  @GET("/({$_token})/xs_main.aspx")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getMainPage({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
  });

  @GET("/({$_token})/xskbcx.aspx?$_functionModuleCode=N121603")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getClassesPageDefault({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Header(_referer) required String referer,
  });

  @POST("/({$_token})/xskbcx.aspx?$_functionModuleCode=N121603")
  @DioResponseType(ResponseType.bytes)
  @FormUrlEncoded()
  Future<HttpResponse<dynamic>> getClassesPage({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Field(_viewState) required String viewState,
    @Field(_academicYear) required String academicYear,
    @Field(_semester) required String semester,
    @Field(_eventTarget) String eventTarget = "",
    @Field(_eventTArgument) String eventTArgument = "",
    @Header(_referer) required String referer,
  });

  @GET("/({$_token})/xskscx.aspx?$_functionModuleCode=N121604")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getExamPageDefault({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Header(_referer) required String referer,
  });

  @POST("/({$_token})/xskscx.aspx?$_functionModuleCode=N121604")
  @DioResponseType(ResponseType.bytes)
  @FormUrlEncoded()
  Future<HttpResponse<dynamic>> getExamPage({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Field(_viewState) required String viewState,
    @Field(_academicYear) required String academicYear,
    @Field(_semester) required String semester,
    @Field(_eventTarget) String eventTarget = "",
    @Field(_eventTArgument) String eventTArgument = "",
    @Header(_referer) required String referer,
  });

  @GET("/({$_token})/xscjcx_dq_fafu.aspx?$_functionModuleCode=N121605")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getScorePageDefault({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Header(_referer) required String referer,
  });

  @POST("/({$_token})/xscjcx_dq_fafu.aspx?$_functionModuleCode=N121605")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<dynamic>> getScorePage({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Field(_viewState) required String viewState,
    @Field(_academicYearInScore) required String academicYear,
    @Field(_semesterInScore) required String semester,
    @Field(_eventTarget) String eventTarget = "",
    @Field(_eventTArgument) String eventTArgument = "",
    @Field("btnCx") String queryButton="+%B2%E9++%D1%AF+",
    @Header(_referer) required String referer,
  });

  @POST("/({$_token})/xscjcx_dq_fafu.aspx?$_functionModuleCode=N121605")
  @DioResponseType(ResponseType.bytes)
  @FormUrlEncoded()
  Future<HttpResponse<dynamic>> getScorePageManually({
    @Path(_token) required String token,
    @Query(_studentId) required String studentId,
    @Query(_studentName) required String studentName,
    @Header(_referer) required String referer,
    @Body() required String body
  });

  @POST("/({$_token})/default2.aspx")
  @DioResponseType(ResponseType.bytes)
  @FormUrlEncoded()
  Future<HttpResponse<dynamic>> submitLogin({
    @Path(_token) required String token,
    @Header(_referer) required String referer,
    @Body() required String body,
  });
}
