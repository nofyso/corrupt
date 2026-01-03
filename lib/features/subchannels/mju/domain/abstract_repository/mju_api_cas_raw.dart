import 'package:corrupt/features/subchannels/mju/domain/entity/mju_json_object.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mju_api_cas_raw.g.dart';

@RestApi(baseUrl: "https://authserver.mju.edu.cn")
abstract class MjuCasApiRaw {
  static const _serviceQuery = "service";
  static const _username = "username";
  static const _password = "password";
  static const _random = "v";
  static const _reserved1 = "authcode";
  static const _reserved2 = "_eventId";
  static const _execution = "execution";

  factory MjuCasApiRaw(Dio dio, {String baseUrl}) = _MjuCasApiRaw;

  @GET("/authserver/login")
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> getLoginPage({
    @Query(_serviceQuery)
    String service = "https://jwgl.mju.edu.cn/sso/zfiotlogin",
  });

  @POST("/authserver/login")
  @FormUrlEncoded()
  @DioResponseType(ResponseType.plain)
  Future<HttpResponse<String>> login({
    @Query(_random) required String randomFloat,
    @Field(_username) required String username,
    @Field(_password) required String password,
    @Field(_reserved1) String reserved1 = "",
    @Field(_reserved2) String reserved2 = "submit",
    @Field(_execution) required String execution,
  });

  @GET("/authserver/v2/getPubKey")
  Future<MjuLoginPublicKey> getPublicKey();
}
