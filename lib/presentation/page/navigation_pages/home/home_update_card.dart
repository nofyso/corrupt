import 'package:corrupt/features/info/provider/device_info_provider.dart';
import 'package:corrupt/features/update/domain/entity/github_api_entity.dart';
import 'package:corrupt/features/update/provider/android_update_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/navigation_pages/home/home_page.dart';
import 'package:corrupt/presentation/widget/expand_more_widget.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeUpdateCard extends ConsumerStatefulWidget {
  const HomeUpdateCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeUpdateCardState();
}

class _HomeUpdateCardState extends ConsumerState<HomeUpdateCard> {
  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final updateAvailability = ref.watch(updateAvailabilityProvider);
    return updateAvailability.needsUpdate
        ? cardWithPadding(
            child: Column(
              children: [
                cardHead(context, Icons.upgrade, i18n.page_home_update_title),
                SizedBox(height: 8),
                switch (defaultTargetPlatform) {
                  TargetPlatform.android => _cardAndroidUpdate(),
                  TargetPlatform.fuchsia ||
                  TargetPlatform.iOS ||
                  TargetPlatform.linux ||
                  TargetPlatform.macOS ||
                  TargetPlatform.windows => _cardNonAndroidUpdate(),
                },
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget _cardAndroidUpdate() {
    final i18n = AppLocalizations.of(context)!;
    final updateAvailability = ref.watch(updateAvailabilityProvider);
    final neededValue = [ref.watch(androidInfoProvider)];
    int checkPlatform(AndroidDeviceInfo androidInfo, String name) {
      final abi = ["armeabi-v7a", "arm64-v8a", "x86"];
      for (final i in abi.reversed) {
        if (androidInfo.supportedAbis.any((it) => it.contains(i))) {
          if (name.contains(i) && name.contains("apk")) {
            return 0;
          }
          return 1;
        }
      }
      return 1;
    }

    final releaseInfo = updateAvailability.releaseInfo;
    if (releaseInfo == null) {
      return Text(i18n.page_home_update_release_empty);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(i18n.page_home_update_os_android),
        SizedBox(height: 8),
        Text(releaseInfo.body,textAlign:TextAlign.start,),
        SizedBox(height: 8),
        loadWaitingMask(
          values: neededValue,
          requiredValues: neededValue,
          context: context,
          child: (result) {
            final androidInfo = result[0] as AndroidDeviceInfo;
            return ExpandMoreColumn(
              showMoreText: i18n.page_home_update_download_expand,
              children: [
                ...releaseInfo.assets
                    .sortWith((it) => it.name, Order.from<String>((a, b) => a.compareTo(b)))
                    .sortWith((it) => checkPlatform(androidInfo, it.name), Order.orderInt)
                    .map((it) => _releaseEntry(it, checkPlatform(androidInfo, it.name) == 0)),
              ],
            );

            /*return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!updateState.isDownloading && !updateState.isComplete) ...[
              Text(i18n.page_home_update_content),
              ElevatedButton(
                onPressed: () async {
                  /*final useCase = AndroidUpdateUseCase();
                            await for (final state in useCase.perform("1145141919810")) {
                              ref.read(updateStateProvider.notifier).state = state;
                            }*/
                },
                child: Text(i18n.page_home_update_download),
              ),
            ],
            if (updateState.isDownloading) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${updateState.received == 0 ? "-" : updateState.received}/${updateState.total == 0 ? "-" : updateState.total}",
                  ),
                  Text(
                    "(${updateState.received == 0 ? "-" : (updateState.received / 1024 / 1024).toStringAsFixed(2)}/${updateState.total == 0 ? "-" : (updateState.total / 1024 / 1024).toStringAsFixed(2)}MB)",
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: updateState.total == 0
                    ? null
                    : updateState.total < updateState.received
                    ? null
                    : updateState.received / updateState.total,
              ),
            ],
            if (!updateState.isDownloading && updateState.isComplete) ...[
              Text(i18n.page_home_update_complete),
              ElevatedButton(onPressed: () {}, child: Text(i18n.page_home_update_install)),
            ],
          ],
        );*/
          },
        ),
        textIconButton(
          onPressed: () async {
            await launchUrl(Uri.parse(i18n.page_home_update_link));
          },
          icon: Icons.link,
          text: i18n.page_home_update_link_jump,
        ),
      ],
    );
  }

  Widget _cardNonAndroidUpdate() {
    final i18n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(switch (defaultTargetPlatform) {
          TargetPlatform.android => "",
          TargetPlatform.fuchsia => i18n.page_home_update_os_fuchsia,
          TargetPlatform.iOS => i18n.page_home_update_os_ios,
          TargetPlatform.linux => i18n.page_home_update_os_linux,
          TargetPlatform.macOS => i18n.page_home_update_os_macos,
          TargetPlatform.windows => i18n.page_home_update_os_windows,
        }),
        SizedBox(height: 8),
        _cardReleaseComp(),
        textIconButton(
          onPressed: () async {
            await launchUrl(Uri.parse(i18n.page_home_update_link));
          },
          icon: Icons.link,
          text: i18n.page_home_update_link_jump,
        ),
      ],
    );
  }

  Widget _cardReleaseComp() {
    final i18n = AppLocalizations.of(context)!;
    final updateAvailability = ref.watch(updateAvailabilityProvider);
    final releaseInfo = updateAvailability.releaseInfo;
    if (releaseInfo == null) {
      return Text(i18n.page_home_update_release_empty);
    }
    int checkPlatform(String assetName) {
      final platform = switch (defaultTargetPlatform) {
        TargetPlatform.iOS => "ipa",
        TargetPlatform.windows => "win",
        _ => "",
      };
      return assetName.contains(platform) ? 0 : 1;
    }

    return ExpandMoreColumn(
      showMoreText: i18n.page_home_update_download_expand,
      children: [
        ...releaseInfo.assets
            .sortWith((it) => it.name, Order.from<String>((a, b) => a.compareTo(b)))
            .sortWith((it) => checkPlatform(it.name), Order.orderInt)
            .map((it) {
              final isCurrentPlatform = checkPlatform(it.name) == 0;
              return _releaseEntry(it, isCurrentPlatform);
            }),
      ].toList(),
    );
  }

  Widget _releaseEntry(GithubReleaseAssets it, bool isCurrentPlatform) {
    void Function() downloadJump(String url) {
      return () => (launchUrl(Uri.parse(url)));
    }
    final i18n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(isCurrentPlatform ? Icons.inventory : Icons.inventory_2_outlined),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(it.name, style: textTheme.titleMedium),
              if (isCurrentPlatform)
                Text(
                  i18n.page_home_update_best_match,
                  style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                ),
              //Text(it.digest, overflow: TextOverflow.fade, style: textTheme.labelSmall),
            ],
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          fit: FlexFit.tight,
          flex: 0,
          child: Column(
            children: [
              isCurrentPlatform
                  ? FilledButton(
                      onPressed: downloadJump(it.downloadUrl),
                      child: textIconWidget(icon: Icons.link, text: i18n.page_home_update_jump),
                    )
                  : OutlinedButton(
                      onPressed: downloadJump(it.downloadUrl),
                      child: textIconWidget(icon: Icons.link, text: i18n.page_home_update_jump),
                    ),
              Text(
                "${(it.size / 1024 / 1024).toStringAsFixed(2)} MB",
                style: textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
