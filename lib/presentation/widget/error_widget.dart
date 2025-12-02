import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/collections.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

Widget commonSchoolDataFailureWidget({
  required BuildContext context,
  required List<data_fetch_failure.SchoolDataFetchFailure?> rawFailures,
  void Function()? onRefresh,
}) {
  final failures = rawFailures.mapNotNull((it) => it).toList(growable: false);
  Set<Type> types = {};
  for (final it in failures) {
    types.add(it.runtimeType);
  }
  if (failures.isEmpty) return SizedBox.shrink();
  final i18n = AppLocalizations.of(context)!;
  final textTheme = Theme.of(context).textTheme;
  final (icon, errorTitle, errorSubtitle) = _getDisplayTriple(failures.first, i18n);
  final isNotSingleFailureNorUnknown = _tryMerge(
    rawFailures: failures,
  ).match(() => false, _isUnknown);
  final o=["",1];

  return SizedBox.expand(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...isNotSingleFailureNorUnknown
              ? [] //TODO
              : [
                  iconTitleAndSubtitle(
                    context: context,
                    icon: icon,
                    title: errorTitle,
                    subtitle: errorSubtitle,
                  ),
                ],
          /*Icon(
            size: 32,
            types.length == 1 && failures.first is! data_fetch_failure.OtherFailure
                ? switch (failures.first) {
              data_fetch_failure.NetworkFailure() =>
              Icons.signal_wifi_connected_no_internet_4,
              data_fetch_failure.LoginFailure(loginFailure: final x) =>
              switch (x) {
                login_failure.NetworkFailure() => Icons.signal_wifi_connected_no_internet_4,
                login_failure.BadDataFailure() => Icons.key_off,
                login_failure.CaptchaFailure() => Icons.error,
                login_failure.OtherFailure() => Icons.error,
              },
              data_fetch_failure.LoopbackFailure() => Icons.error,
              data_fetch_failure.NotImplementedFailure() => Icons.not_interested,
              _ => Icons.error,
            }
                : Icons.error,
          ),
          ...types.length == 1 &&
              failures.first is! data_fetch_failure.OtherFailure &&
              failures.first is! data_fetch_failure.LoginFailure
              ? [
            Text(switch (failures.first) {
              data_fetch_failure.NetworkFailure() => i18n.widget_error_network,
              data_fetch_failure.LoginFailure(loginFailure: final x) =>
              switch (x) {
                login_failure.NetworkFailure() => i18n.widget_error_network,
                login_failure.BadDataFailure() => i18n.widget_error_login,
                login_failure.CaptchaFailure() => i18n.widget_error_captcha,
                login_failure.OtherFailure() => i18n.widget_error_other,
              },
              data_fetch_failure.NotImplementedFailure() => i18n.widget_error_unimplemented,
              data_fetch_failure.LoopbackFailure() => i18n.widget_error_loopback,
              _ => i18n.widget_error_unknown,
            }),
          ]
              : [
            Text(i18n.widget_error_unknown),
            ...failures.mapNotNull((it) => Text(it.asException().toString())),
          ],*/
          if (onRefresh != null) SizedBox(height: 8),
          if (onRefresh != null)
            SizedBox(
              height: 32,
              child: textIconButton(
                onPressed: onRefresh,
                icon: Icons.refresh,
                text: i18n.widget_error_retry,
              ),
            ),
        ],
      ),
    ),
  );
}

Option<data_fetch_failure.SchoolDataFetchFailure> _tryMerge({
  required List<data_fetch_failure.SchoolDataFetchFailure?> rawFailures,
}) {
  if (rawFailures.length == 1) return Option.fromNullable(rawFailures.first);
  return rawFailures.sublist(1).filterNotNull().all((it) => it == rawFailures.first)
      ? Option.fromNullable(rawFailures.first)
      : Option.none();
}

bool _isUnknown(data_fetch_failure.SchoolDataFetchFailure failure) => switch (failure) {
  data_fetch_failure.NetworkFailure() ||
  data_fetch_failure.LoopbackFailure() ||
  data_fetch_failure.NotImplementedFailure() ||
  data_fetch_failure.NotLoggedFailure() => false,
  data_fetch_failure.OtherFailure() => true,
  data_fetch_failure.LoginFailure(loginFailure: final x) => switch (x) {
    login_failure.NetworkFailure() ||
    login_failure.BadDataFailure() ||
    login_failure.CaptchaFailure() => false,
    login_failure.OtherFailure() => true,
  },
};

(IconData, String, String) _getDisplayTriple(
  data_fetch_failure.SchoolDataFetchFailure failure,
  AppLocalizations i18n,
) => switch (failure) {
  data_fetch_failure.NetworkFailure() => (
    Icons.signal_wifi_connected_no_internet_4,
    i18n.widget_error_network_title,
    i18n.widget_error_network_subtitle,
  ),
  data_fetch_failure.LoginFailure(loginFailure: final x) => switch (x) {
    login_failure.NetworkFailure() => (
      Icons.signal_wifi_connected_no_internet_4,
      i18n.widget_error_network_title,
      i18n.widget_error_network_subtitle,
    ),
    login_failure.BadDataFailure() => (
      Icons.key_off,
      i18n.widget_error_login_title,
      i18n.widget_error_login_subtitle,
    ),
    login_failure.CaptchaFailure() => (
      Icons.gpp_bad,
      i18n.widget_error_captcha_title,
      i18n.widget_error_captcha_subtitle,
    ),
    _ => (Icons.error, i18n.widget_error_unknown, i18n.widget_error_unknown),
  },
  data_fetch_failure.LoopbackFailure() => (
    Icons.error,
    i18n.widget_error_loopback_title,
    i18n.widget_error_loopback_subtitle,
  ),
  data_fetch_failure.NotLoggedFailure() => (
    Icons.key_off,
    i18n.page_classes_error_not_logged_title,
    i18n.page_classes_error_not_logged_content,
  ),
  data_fetch_failure.NotImplementedFailure() => (
    Icons.not_interested,
    i18n.widget_error_unimplemented_title,
    i18n.widget_error_unimplemented_subtitle,
  ),
  _ => (Icons.error, i18n.widget_error_unknown, i18n.widget_error_unknown),
};
