import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/features/channel/provider/online_school_data_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/error_widget.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intl/intl.dart';

class FunctionScoresPage extends ConsumerStatefulWidget {
  const FunctionScoresPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FunctionScoresPageState();
}

class _FunctionScoresPageState extends ConsumerState<FunctionScoresPage> {
  String? selectedAcademicYear;
  String? selectedSemester;
  TermBasedFetchArgument? _argument;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final i18n = AppLocalizations.of(context)!;
    final scoresProvider = onlineScoresNotifierProvider(_argument);
    final scoresValue = ref.watch(scoresProvider);
    return onlineLoadWaitingMask(
      values: [scoresValue],
      failedChild: (failures) {
        return commonSchoolDataFailureWidget(
          context: context,
          rawFailures: failures,
          onRefresh: () {
            setState(() {
              _argument = null;
            });
            ref.invalidate(scoresProvider);
          },
        );
      },
      succeedChild: (result) {
        final scoresGroup = result[0] as (AvailableTermTime, ScoresEntity);
        final availableSemester = scoresGroup.$1;
        final scores = scoresGroup.$2;
        setState(() {
          selectedAcademicYear = scores.academicYear;
          selectedSemester = scores.semester;
        });
        return Column(
          children: [
            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    items: availableSemester.availableAcademicYear
                        .map((it) => DropdownMenuItem<String>(value: it.$1, child: Text(it.$1)))
                        .toList(),
                    value: scores.academicYear,
                    onChanged: (v) {
                      setState(() {
                        if (v == selectedAcademicYear) return;
                        selectedAcademicYear = v;
                        selectedSemester.let((it) {
                          if (it != null && v != null) _argument = TermBasedFetchArgument(v, it);
                        });
                      });
                    },
                  ),
                  DropdownButton(
                    items: availableSemester.availableSemester
                        .map((it) => DropdownMenuItem<String>(value: it.$1, child: Text(it.$1)))
                        .toList(),
                    value: scores.semester,
                    onChanged: (v) {
                      if (v == selectedSemester) return;
                      setState(() {
                        selectedSemester = v;
                        selectedAcademicYear.let((it) {
                          if (it != null && v != null) _argument = TermBasedFetchArgument(it, v);
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: scores.entities.isNotEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsetsGeometry.directional(start: 8, end: 8),
                        child: Column(
                          spacing: 4,
                          children: scores.entities.map((it) => _ScoreCard(it)).toList(),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle_outlined, size: 32),
                        Text(i18n.page_exams_empty_title, style: textTheme.titleMedium),
                        Text(i18n.page_exams_empty_subtitle),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ScoreCard extends StatefulWidget {
  final ScoreEntity it;

  const _ScoreCard(this.it);

  @override
  State<StatefulWidget> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<_ScoreCard> {
  final dateFormat = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm");

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final it = widget.it;
    String emptyCheck(String ori) => ori.isEmpty ? i18n.page_exams_undeclared : ori;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Stack(
          children: [
            it.score.toDoubleOption.match(
              () => SizedBox.shrink(),
              (score) => LinearProgressIndicator(
                value: score / 100.0,
                color: switch (score) {
                  final s when s < 60.0 =>
                    it.elective ? Color.fromARGB(255, 127, 127, 127) : colorScheme.error,
                  final s when s == 100.0 => Color.fromARGB(255, 76, 175, 80),
                  _ => colorScheme.primary.withValues(alpha: 0.4),
                },
                backgroundColor: score == 0
                    ? (it.elective
                          ? Color.fromARGB(50, 127, 127, 127)
                          : colorScheme.error.withValues(alpha: 0.4))
                    : Color.fromARGB(0, 0, 0, 0),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.name, style: textTheme.titleMedium),
                        if (it.elective)
                          Text(i18n.page_scores_card_elective, style: textTheme.labelMedium),
                        simpleAnimatedSize(
                          show: isExpanded,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  _textWithIcon(i18n.page_scores_card_time, Icons.date_range),
                                  _textWithIcon(i18n.page_scores_card_place, Icons.location_on),
                                  _textWithIcon(i18n.page_scores_card_category, Icons.category),
                                  _textWithIcon(
                                    i18n.page_scores_card_credit,
                                    Icons.incomplete_circle,
                                  ),
                                  _textWithIcon(i18n.page_scores_card_gp, Icons.grade),
                                  if (it.note.trim() != ":" && it.note.isNotEmpty)
                                    _textWithIcon(i18n.page_scores_card_note, Icons.note),
                                  _textWithIcon(i18n.page_scores_card_code, Icons.numbers),
                                ],
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  _textWithIcon("${it.year} - ${it.term}"),
                                  _textWithIcon(it.place),
                                  _textWithIcon(
                                    "${it.type}${it.belong.let((s) => s.isEmpty ? "" : " $s")}",
                                  ),
                                  _textWithIcon(it.credit),
                                  _textWithIcon(it.gp),
                                  if (it.note.trim() != ":" && it.note.isNotEmpty)
                                    _textWithIcon(it.note),
                                  _textWithIcon(it.classId),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: it.score.toDoubleOption
                        .match(
                          () => null,
                          (score) => switch (score) {
                            final s when s < 60.0 =>
                              it.elective ? Color.fromARGB(255, 127, 127, 127) : colorScheme.error,
                            final s when s == 100.0 => Color.fromARGB(255, 76, 175, 80),
                            _ => colorScheme.primary,
                          },
                        )
                        .let(
                          (color) => Column(
                            children: [
                              Text(it.score, style: textTheme.titleLarge?.copyWith(color: color)),
                              simpleAnimatedSize(
                                show: isExpanded,
                                child: Text(
                                  i18n.page_scores_card_score,
                                  style: textTheme.labelLarge?.copyWith(color: color),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textWithIcon(String text, [IconData? iconData]) => Row(
    spacing: 8,
    children: [if (iconData != null) Icon(iconData), Text(text), if (iconData == null) Icon(null)],
  );
}
