import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/util/duration_consts.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

Widget loadWaitingMask({
  required List<AsyncValue<Option<dynamic>>> values,
  required List<AsyncValue<Option<dynamic>>> requiredValues,
  required BuildContext context,
  required Widget Function(List<dynamic> finishedValuess) child,
}) {
  final finished = values.all((it) => !it.isLoading);
  final i18n = AppLocalizations.of(context)!;
  final left = values.filter((it) => it.isLoading).length;
  final valueResults = values.map((it) => it.valueOrNull?.toNullable()).toList();
  final requiredValueResults = requiredValues.map((it) => it.valueOrNull?.toNullable()).toList();
  final requiredFinished = requiredValueResults.all((it) => it != null);
  return Stack(
    children: [
      Center(
        child: finished
            ? SizedBox.shrink()
            : AnimatedOpacity(
                opacity: finished ? 0 : 1,
                duration: MaterialDurations.short,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(i18n.widget_load_waiting_entry("$left")),
                  ],
                ),
              ),
      ),
      Center(
        child: !requiredFinished
            ? AnimatedOpacity(
                opacity: !requiredFinished && finished ? 1 : 0,
                duration: MaterialDurations.short,
                child: iconTitleAndSubtitle(
                  context: context,
                  icon: Icons.error_outline,
                  title: i18n.widget_load_not_fully_loaded,
                ),
              )
            : SizedBox.shrink(),
      ),
      AnimatedOpacity(
        opacity: finished && requiredFinished ? 1 : 0,
        duration: MaterialDurations.short,
        child: requiredFinished ? child(valueResults) : SizedBox.shrink(),
      ),
    ],
  );
}

Widget onlineLoadWaitingMask({
  required List<AsyncValue<Either<SchoolDataFetchFailure, dynamic>>> values,
  required Widget Function(List<SchoolDataFetchFailure?> failures) failedChild,
  required Widget Function(List<dynamic> values) succeedChild,
}) {
  final isLoading = values.any((it) => it.isLoading);
  final errors = values.map(
    (it) => it.hasError
        ? OtherFailure.fromException(
            it.error.let((e) => e != null && e is Exception ? e : Exception("Unknown failure")),
          )
        : it.value.let((v) => v?.getLeft().toNullable()),
  );
  final hasError = errors.any((it) => it != null);
  final valuesOut = values.map((it) => it.value?.getRight().toNullable());
  return Stack(
    children: [
      Center(
        child: simpleAnimatedOpacity(show: isLoading, child: CircularProgressIndicator()),
      ),
      Center(
        child: simpleAnimatedOpacity(
          show: !isLoading && hasError,
          child: !isLoading && hasError ? failedChild(errors.toList()) : SizedBox.shrink(),
        ),
      ),
      simpleAnimatedOpacity(
        show: !isLoading && !hasError,
        child: !isLoading && !hasError ? succeedChild(valuesOut.toList()) : SizedBox.shrink(),
      ),
    ],
  );
}
