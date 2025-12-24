// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_api_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRelease _$GithubReleaseFromJson(Map<String, dynamic> json) =>
    GithubRelease(
      json['tag_name'] as String,
      json['body'] as String,
      json['prerelease'] as bool,
      (json['assets'] as List<dynamic>)
          .map((e) => GithubReleaseAssets.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GithubReleaseToJson(GithubRelease instance) =>
    <String, dynamic>{
      'tag_name': instance.tagName,
      'body': instance.body,
      'prerelease': instance.prerelease,
      'assets': instance.assets,
    };

GithubReleaseAssets _$GithubReleaseAssetsFromJson(Map<String, dynamic> json) =>
    GithubReleaseAssets(
      json['url'] as String,
      json['browser_download_url'] as String,
      json['name'] as String,
      json['label'] as String,
      json['digest'] as String,
      json['updated_at'] as String,
      (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$GithubReleaseAssetsToJson(
  GithubReleaseAssets instance,
) => <String, dynamic>{
  'url': instance.url,
  'browser_download_url': instance.downloadUrl,
  'name': instance.name,
  'label': instance.label,
  'digest': instance.digest,
  'updated_at': instance.updateTimeStamp,
  'size': instance.size,
};
