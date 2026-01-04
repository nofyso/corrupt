import 'dart:async';

import 'package:app_version_compare/app_version_compare.dart';
import 'package:corrupt/features/update/domain/abstract_repository/github_api.dart';
import 'package:corrupt/features/update/domain/entity/github_api_entity.dart';
import 'package:corrupt/features/update/domain/entity/update_states.dart';
import 'package:corrupt/util/wrapper.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AndroidUpdateUseCase {
  static final Dio _dio = Dio(BaseOptions(responseType: ResponseType.stream));

  Stream<AndroidUpdateState> perform(String filename, String uri) async* {
    try {
      yield AndroidUpdateState(true, false, 0, 0);
      final controller = StreamController<AndroidUpdateState>();
      var error = false;
      final outputPath = await getApplicationCacheDirectory().then(
        (it) => path.join(it.absolute.path, filename),
      );
      _dio
          .download(
            uri,
            outputPath,
            onReceiveProgress: (received, total) {
              controller.add(AndroidUpdateState(true, false, received, total));
            },
          )
          .then(
            (_) => controller.close(),
            onError: (e) {
              error = true;
              controller.close();
              throw e;
            },
          );
      yield* controller.stream;
      if (error) {
        yield AndroidUpdateState(false, false, 0, 0);
      } else {
        yield AndroidUpdateState(false, true, 0, 0);
      }
    } catch (o) {
      yield AndroidUpdateState(false, false, 0, 0);
    }
  }
}

class UpdateCheckUseCase {
  final GithubApiRepository _githubRepository;

  UpdateCheckUseCase(this._githubRepository);

  Future<Option<UpdateInfo>> checkUpdate() async {
    final latest = await _githubRepository
        .getLatestRelease()
        .wrapNetworkSafeTask()
        .run();
    switch (latest) {
      case Right<RequestFailure, GithubRelease>(value: final value):
        final tagName = value.tagName;
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = AppVersion.fromString(packageInfo.version);
        final targetVersion = AppVersion.fromString(tagName);
        return Option.of(UpdateInfo(currentVersion < targetVersion, value));
      case Left<RequestFailure, GithubRelease>():
        return Option.none();
    }
  }
}
