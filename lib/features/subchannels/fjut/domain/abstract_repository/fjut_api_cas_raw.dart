import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'fjut_api_cas_raw.g.dart';

@RestApi(baseUrl: "https://nids-443.webvpn.fjut.edu.cn")
abstract class FjutCasApiRaw {
  static const _serviceQuery = "service";
  static const _username = "username";
  static const _password = "password";
  static const _reserved1 = "captcha";
  static const _reserved2 = "_eventId";
  static const _reserved3 = "cllt";
  static const _reserved4 = "dllt";
  static const _reserved5 = "lt";
  static const _execution = "execution";

  factory FjutCasApiRaw(Dio dio, {String baseUrl}) = _FjutCasApiRaw;

  @GET("/authserver/login")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getLoginPage({
    @Query(_serviceQuery) String service = "https://jwxt-443.webvpn.fjut.edu.cn/sso/jziotlogin",
  });

  @POST("/authserver/login")
  @FormUrlEncoded()
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> login({
    @Query(_serviceQuery) String service = "https://jwxt-443.webvpn.fjut.edu.cn/sso/jziotlogin",
    @Field(_username) required String username,
    @Field(_password) required String password,
    @Field(_reserved1) String reserved1 = "",
    @Field(_reserved2) String reserved2 = "submit",
    @Field(_reserved3) String reserved3 = "userNameLogin",
    @Field(_reserved4) String reserved4 = "generalLogin",
    @Field(_reserved5) String reserved5 = "",
    @Field(_execution) required String execution,
  });
}
