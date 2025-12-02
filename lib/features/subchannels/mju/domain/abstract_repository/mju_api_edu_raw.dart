import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mju_api_edu_raw.g.dart';

@RestApi(baseUrl: "https://jwgl.mju.edu.cn")
abstract class MjuEduApiRaw {
  static const _functionModuleCode = "gnmkdm";
  static const _layout = "layout";
  static const _academicYear = "xnm";
  static const _semester = "xqm";
  static const _doType = "doType";

  factory MjuEduApiRaw(Dio dio, {String baseUrl}) = _MjuEduApiRaw;

  @GET("/jwglxt/kbcx/xskbcx_cxXskbcxIndex.html")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getClassesPage({
    @Query(_functionModuleCode) String functionModuleCode = "N2151",
    @Query(_layout) String layout = "default",
  });

  @POST("/jwglxt/kbcx/xskbcx_cxXsgrkb.html")
  @FormUrlEncoded()
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getClassesData({
    @Query(_functionModuleCode) String functionModuleCode = "N2151",
    @Field(_academicYear) required String academicYear,
    @Field(_semester) required String semester,
    @Field("kzlx") String reserved1 = "ck",
    @Field("xsdm") String reserved2 = "",
    @Field("kclbdm") String reserved3 = "",
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
    @Field("ksmcdmb_id") String reserved1 = "",
    @Field("kch") String reserved2 = "",
    @Field("kc") String reserved3 = "",
    @Field("ksrq") String reserved4 = "",
    @Field("kkbm_id") String reserved5 = "",
    @Field("_search") String reserved6 = "false",
    @Field("nd") required String timestamp,
    @Field("queryModel.showCount") String reserved7 = "5000",
    @Field("queryModel.currentPage") String reserved8 = "1",
    @Field("queryModel.sortName") String reserved9 = "",
    @Field("queryModel.sortOrder") String reserved10 = "asc",
    @Field("time") String reserved11 = "0",
  });
}
