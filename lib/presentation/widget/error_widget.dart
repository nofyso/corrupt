import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final (icon, errorTitle, errorSubtitle) = _getDisplayTriple(failures.first, i18n);
  final isNotSingleFailureNorUnknown = _tryMerge(rawFailures: failures).isNone();
  return SizedBox.expand(
    child: Padding(
      padding: EdgeInsetsGeometry.directional(start: 32, end: 32),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...isNotSingleFailureNorUnknown
                ? [_multiFailuresWidget(context, i18n)]
                : [
                    iconTitleAndSubtitle(
                      context: context,
                      icon: icon,
                      title: errorTitle,
                      subtitle: errorSubtitle,
                    ),
                  ],
            SizedBox(height: 8),
            textIconButton(
              onPressed: () {
                final error = failures
                    .map((it) => "$it: ${it.asException().toString()}\n${it.stackTrace.toString()}")
                    .join("\n\n====I'm a divider====\n\n");
                Clipboard.setData(ClipboardData(text: error));
              },
              icon: Icons.copy,
              text: i18n.widget_error_copy,
            ),
            if (onRefresh != null)
              textIconButton(
                onPressed: onRefresh,
                icon: Icons.refresh,
                text: i18n.widget_error_retry,
              ),
          ],
        ),
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

// bool _isUnknown(data_fetch_failure.SchoolDataFetchFailure failure) => switch (failure) {
//   data_fetch_failure.NetworkFailure() ||
//   data_fetch_failure.LoopbackFailure() ||
//   data_fetch_failure.NotImplementedFailure() ||
//   data_fetch_failure.NotLoggedFailure() => false,
//   data_fetch_failure.OtherFailure() => true,
//   data_fetch_failure.LoginFailure(loginFailure: final x) => switch (x) {
//     login_failure.NetworkFailure() ||
//     login_failure.BadDataFailure() ||
//     login_failure.CaptchaFailure() => false,
//     login_failure.OtherFailure() => true,
//   },
// };

Widget _multiFailuresWidget(BuildContext context, AppLocalizations i18n) => iconTitleAndSubtitle(
  context: context,
  icon: Icons.error,
  title: i18n.widget_error_multi_title,
  subtitle: i18n.widget_error_multi_subtitle,
);

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
    login_failure.NetworkFailure(badResponse: final badResponse) =>
      badResponse != null
          ? (
              Icons.signal_wifi_statusbar_connected_no_internet_4,
              i18n.widget_error_network_bad_response_title,
              i18n.widget_error_network_bad_response_subtitle,
            )
          : (
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
    _ => (Icons.error, i18n.widget_error_other_title, i18n.widget_error_other_subtitle),
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
  data_fetch_failure.OtherFailure() => _geDataFetchUnknownDisplayTriple(failure, i18n),
};

(IconData, String, String) _geDataFetchUnknownDisplayTriple(
  data_fetch_failure.OtherFailure failure,
  AppLocalizations i18n,
) => switch (failure.preset) {
  null => (Icons.error, i18n.widget_error_other_title, i18n.widget_error_other_subtitle),
  data_fetch_failure.Preset.fafuTeaching => (
    Icons.no_accounts,
    i18n.widget_error_other_fafu_teaching_title,
    i18n.widget_error_other_fafu_teaching_subtitle,
  ),
  data_fetch_failure.Preset.fafuAnalyzing => (
    Icons.running_with_errors,
    i18n.widget_error_other_fafu_analyzing_title,
    i18n.widget_error_other_fafu_analyzing_subtitle,
  ),
};
