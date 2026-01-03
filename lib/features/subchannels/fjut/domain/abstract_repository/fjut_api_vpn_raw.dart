import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'fjut_api_vpn_raw.g.dart';

@RestApi(baseUrl: "https://webvpn.fjut.edu.cn")
abstract class FjutVpnApiRaw {
  static const _authenticityToken = "authenticity_token";
  static const _username = "user[login]";
  static const _password = "user[password]";
  static const _reserved1 = "utf8";
  static const _reserved2 = "user[dymatice_code]";
  static const _reserved3 = "user[otp_with_capcha]";
  static const _reserved4 = "commit";

  factory FjutVpnApiRaw(Dio dio, {String baseUrl}) = _FjutVpnApiRaw;

  @GET("/users/sign_in")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getLoginPage();

  @POST("/users/sign_in")
  @DioResponseType(ResponseType.plain)
  @FormUrlEncoded()
  Future<HttpResponse<String>> login({
    @Header("Origin") String origin = "https://webvpn.fjut.edu.cn",
    @Header("Referer")
    String referer = "https://webvpn.fjut.edu.cn/users/sign_in",
    @Field(_reserved1) String reserved1 = "✓",
    @Field(_authenticityToken) required String token,
    @Field(_username) required String username,
    @Field(_password) required String password,
    @Field(_reserved2) String reserved2 = "unknown",
    @Field(_reserved3) String reserved3 = "false",
    @Field(_reserved4) String reserved4 = "登录 Login",
  });

  @GET("/")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getRootPage();
}
