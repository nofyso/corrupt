import 'package:corrupt/features/update/domain/entity/github_api_entity.dart';

class AndroidUpdateState {
  bool isDownloading;
  bool isComplete;
  int received;
  int total;

  AndroidUpdateState(
    this.isDownloading,
    this.isComplete,
    this.received,
    this.total,
  );
}

class UpdateInfo {
  bool needsUpdate;
  GithubRelease? releaseInfo;

  UpdateInfo(this.needsUpdate, this.releaseInfo);
}
