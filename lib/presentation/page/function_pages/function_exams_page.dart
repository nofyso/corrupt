import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/provider/online_school_data_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'term_time_select_content_page.dart';

class FunctionExamsPage extends ConsumerStatefulWidget {
  const FunctionExamsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FunctionExamsPageState();
}

class _FunctionExamsPageState extends ConsumerState<FunctionExamsPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final i18n = AppLocalizations.of(context)!;
    return TermTimeSelectContentPage(
      providerFetcher: (arg) => [onlineExamsNotifierProvider(arg)],
      availableTermTimeExtract: (t) =>
          (t[0] as (AvailableTermTime, ExamsEntity)).$1,
      currentTermTimeExtract: (t) => (t[0] as (AvailableTermTime, ExamsEntity))
          .$2
          .let((it) => (it.academicYear, it.semester)),
      child: (t) {
        final r = (t[0] as (AvailableTermTime, ExamsEntity));
        return r.$2.entities.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.directional(start: 8, end: 8),
                  child: Column(
                    children: r.$2.entities.map((it) => _ExamCard(it)).toList(),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle_outlined, size: 32),
                  Text(
                    i18n.page_exams_empty_title,
                    style: textTheme.titleMedium,
                  ),
                  Text(i18n.page_exams_empty_subtitle),
                ],
              );
      },
    );
  }
}

class _ExamCard extends StatefulWidget {
  final ExamEntity it;

  const _ExamCard(this.it);

  @override
  State<StatefulWidget> createState() => _ExamCardState();
}

class _ExamCardState extends State<_ExamCard> {
  final dateFormat = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm");

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final it = widget.it;
    String emptyCheck(String ori) =>
        ori.isEmpty ? i18n.page_exams_undeclared : ori;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(it.name, style: textTheme.titleMedium),
                  SizedBox(height: 4),
                  _textWithIcon(
                    it.fromTime?.let((it) => dateFormat.format(it)) ??
                        i18n.page_exams_undeclared,
                    Icons.calendar_month,
                  ),
                  _textWithIcon(
                    it.fromTime != null && it.toTime != null
                        ? "${timeFormat.format(it.fromTime!)}-${timeFormat.format(it.toTime!)}"
                        : i18n.page_exams_undeclared,
                    Icons.timelapse,
                  ),
                  _textWithIcon(
                    "${emptyCheck(it.campus)}:${emptyCheck(it.place)}-${emptyCheck(it.seat)}",
                    Icons.location_on,
                  ),
                  simpleAnimatedSize(
                    show: isExpanded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textWithIcon(it.classId, Icons.numbers),
                        _textWithIcon(it.studentName, Icons.account_circle),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textWithIcon(String text, IconData iconData) =>
      Row(spacing: 8, children: [Icon(iconData), Text(text)]);
}
