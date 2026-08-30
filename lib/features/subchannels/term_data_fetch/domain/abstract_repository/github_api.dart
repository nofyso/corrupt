import 'dart:convert';

import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'github_api.g.dart';

@RestApi(baseUrl: "https://hk.gh-proxy.org/https://raw.githubusercontent.com")
abstract class GithubApiRaw {
  factory GithubApiRaw(Dio dio, {String baseUrl}) = _GithubApiRaw;

  @GET("/nofyso/corrupt/main/term_data.json")
  @DioResponseType(ResponseType.plain)
  Future<String> fetchTermDataRaw();
}

class GithubApi {
  Future<List<TermData>> fetchTermData() async =>
      (jsonDecode(await getIt<GithubApiRaw>().fetchTermDataRaw()) as List<
          dynamic>)
          .map((it) => TermData.fromJson(it))
          .toList();
}