import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/provider/online_school_data_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/function_pages/term_time_select_content_page.dart';
import 'package:corrupt/presentation/widget/classes_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class FunctionClassesPage extends ConsumerStatefulWidget {
  const FunctionClassesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FunctionClassesPageState();
}

class _FunctionClassesPageState extends ConsumerState<FunctionClassesPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final i18n = AppLocalizations.of(context)!;
    return TermTimeSelectContentPage(
      providerFetcher: (arg) => [
        onlineClassTableNotifierProvider(arg),
        onlineClassTimeNotifierProvider(unit),
      ],
      availableTermTimeExtract: (t) =>
          (t[0] as (AvailableTermTime, ClassTable)).$1,
      currentTermTimeExtract: (t) => (t[0] as (AvailableTermTime, ClassTable))
          .$2
          .let((it) => (it.academicYear, it.semester)),
      child: (t) {
        final classTable = (t[0] as (AvailableTermTime, ClassTable)).$2;
        final classTime = (t[1] as ClassTime);
        return classTable.classes.isNotEmpty
            ? ClassesWidget(
                classTable: classTable,
                classTime: classTime,
                termData: null,
                showTimeInspector: false,
                showDateInspector: false,
                timeInspectorAlpha: 0,
                dateInspectorAlpha: 0,
                initialPageIndex: 0,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle_outlined, size: 32),
                  Text(
                    i18n.page_classes_error_empty_title,
                    style: textTheme.titleMedium,
                  ),
                  Text(i18n.page_classes_error_empty_subtitle),
                ],
              );
      },
    );
  }
}
