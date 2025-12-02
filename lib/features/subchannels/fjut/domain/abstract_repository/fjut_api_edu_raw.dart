import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'fjut_api_edu_raw.g.dart';

@RestApi(baseUrl: "https://jwxt-443.webvpn.fjut.edu.cn")
abstract class FjutEduApiRaw {
  static const _academicYear = "xnd";
  static const _semester = "xqd";
  static const _functionModuleCode = "gnmkdm";
  static const _layout = "layout";
  static const _doType = "doType";
  static const _classesReserved1 = "kzlx";
  static const _classesReserved2 = "xsdm";
  static const _examsReserved1 = "ksmcdmb_id";
  static const _examsReserved2 = "kch";
  static const _examsReserved3 = "kc";
  static const _examsReserved4 = "ksrq";
  static const _examsReserved5 = "kkbm_id";
  static const _examsReserved6 = "_search";
  static const _examsTimeStamp = "nd";
  static const _examsReserved7 = "queryModel.showCount";
  static const _examsReserved8 = "queryModel.currentPage";
  static const _examsReserved9 = "queryModel.sortName";
  static const _examsReserved10 = "queryModel.sortOrder";
  static const _examsReserved11 = "time";

  factory FjutEduApiRaw(Dio dio, {String baseUrl}) = _FjutEduApiRaw;

  @GET("/jwglxt/kbcx/xskbcx_cxXskbcxIndex.html")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getClassesPage({
    @Query(_functionModuleCode) String functionModuleCode = "N253508",
    @Query(_layout) String layout = "default",
  });

  @POST("/jwglxt/kbcx/xskbcx_cxXsgrkb.html")
  @FormUrlEncoded()
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getClassesData({
    @Query(_functionModuleCode) String functionModuleCode = "N2151",
    @Field(_academicYear) required String academicYear,
    @Field(_semester) required String semester,
    @Field(_classesReserved1) String reserved1 = "ck",
    @Field(_classesReserved2) String reserved2 = "",
  });

  @GET("/jwglxt/kwgl/kscx_cxXsksxxIndex.html")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getExamPage({
    @Query(_functionModuleCode) String functionModuleCode = "N358105",
    @Query(_layout) String layout = "default",
  });

  @POST("/jwglxt/kwgl/kscx_cxXsksxxIndex.html")
  @FormUrlEncoded()
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getExamData({
    @Query(_doType) String doType = "query",
    @Query(_functionModuleCode) String functionModuleCode = "N358105",
    @Field(_academicYear) required String academicYear,
    @Field(_semester) required String semester,
    @Field(_examsReserved1) String reserved1 = "",
    @Field(_examsReserved2) String reserved2 = "",
    @Field(_examsReserved3) String reserved3 = "",
    @Field(_examsReserved4) String reserved4 = "",
    @Field(_examsReserved5) String reserved5 = "",
    @Field(_examsReserved6) String reserved6 = "false",
    @Field(_examsTimeStamp) required String timeStamp,
    @Field(_examsReserved7) String reserved7 = "5000",
    @Field(_examsReserved8) String reserved8 = "1",
    @Field(_examsReserved9) String reserved9 = "",
    @Field(_examsReserved10) String reserved10 = "asc",
    @Field(_examsReserved11) String reserved11 = "0",
  });
}
