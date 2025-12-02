import 'package:corrupt/features/update/domain/entity/github_api_entity.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'github_api.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class GithubApiRepository {
  static final Dio _dio = Dio();

  factory GithubApiRepository() => _GithubApiRepository(_dio);

  @GET("/repos/nofyso/corrupt/releases/latest")
  @Headers({"Accept": "application/vnd.github+json", "X-GitHub-Api-Version": "2022-11-28"})
  Future<GithubRelease> getLatestRelease();
}
