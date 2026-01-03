import 'package:json_annotation/json_annotation.dart';

part 'github_api_entity.g.dart';

@JsonSerializable()
class GithubRelease {
  @JsonKey(name: "tag_name")
  final String tagName;
  @JsonKey(name: "body")
  final String body;
  @JsonKey(name: "prerelease")
  final bool prerelease;
  @JsonKey(name: "assets")
  final List<GithubReleaseAssets> assets;

  GithubRelease(this.tagName, this.body, this.prerelease, this.assets);

  factory GithubRelease.fromJson(Map<String, dynamic> json) =>
      _$GithubReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$GithubReleaseToJson(this);
}

@JsonSerializable()
class GithubReleaseAssets {
  @JsonKey(name: "url")
  final String url;
  @JsonKey(name: "browser_download_url")
  final String downloadUrl;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "label")
  final String label;
  @JsonKey(name: "digest")
  final String digest;
  @JsonKey(name: "updated_at")
  final String updateTimeStamp;
  @JsonKey(name: "size")
  final int size;

  GithubReleaseAssets(
    this.url,
    this.downloadUrl,
    this.name,
    this.label,
    this.digest,
    this.updateTimeStamp,
    this.size,
  );

  factory GithubReleaseAssets.fromJson(Map<String, dynamic> json) =>
      _$GithubReleaseAssetsFromJson(json);

  Map<String, dynamic> toJson() => _$GithubReleaseAssetsToJson(this);
}
