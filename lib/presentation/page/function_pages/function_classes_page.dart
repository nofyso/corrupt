import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/features/channel/provider/online_school_data_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/classes_widget.dart';
import 'package:corrupt/presentation/widget/error_widget.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class FunctionClassesPage extends ConsumerStatefulWidget {
  const FunctionClassesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FunctionClassesPageState();
}

class _FunctionClassesPageState extends ConsumerState<FunctionClassesPage> {
  String? selectedAcademicYear;
  String? selectedSemester;
  TermBasedFetchArgument? _argument;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final i18n = AppLocalizations.of(context)!;
    final classTimeProvider = onlineClassTimeNotifierProvider(unit);
    final classTimeValue = ref.watch(classTimeProvider);
    final classTableProvider = onlineClassTableNotifierProvider(_argument);
    final classTableValue = ref.watch(classTableProvider);
    return SizedBox.expand(
      child: onlineLoadWaitingMask(
        values: [classTableValue, classTimeValue],
        failedChild: (failures) => commonSchoolDataFailureWidget(
          context: context,
          rawFailures: failures,
          onRefresh: () {
            setState(() {
              _argument = null;
            });
            ref.invalidate(classTableProvider);
            ref.invalidate(classTimeProvider);
          },
        ),
        succeedChild: (result) {
          final classTableGroup = result[0] as (AvailableTermTime, ClassTable);
          final availableSemester = classTableGroup.$1;
          final classTable = classTableGroup.$2;
          final classTime = result[1] as ClassTime;
          setState(() {
            selectedAcademicYear = classTable.academicYear;
            selectedSemester = classTable.semester;
          });
          return Column(
            children: [
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      items: availableSemester.availableAcademicYear
                          .map((it) => DropdownMenuItem<String>(value: it.$1, child: Text(it.$1)))
                          .toList(),
                      value: classTable.academicYear,
                      onChanged: (v) {
                        setState(() {
                          if (v == selectedAcademicYear) return;
                          selectedAcademicYear = v;
                          selectedSemester.let((it) {
                            if (it != null && v != null) {
                              _argument = TermBasedFetchArgument(v, it);
                            }
                          });
                        });
                      },
                    ),
                    DropdownButton(
                      items: availableSemester.availableSemester
                          .map((it) => DropdownMenuItem<String>(value: it.$1, child: Text(it.$1)))
                          .toList(),
                      value: classTable.semester,
                      onChanged: (v) {
                        if (v == selectedSemester) return;
                        setState(() {
                          selectedSemester = v;
                          selectedAcademicYear.let((it) {
                            if (it != null && v != null) {
                              _argument = TermBasedFetchArgument(it, v);
                            }
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: classTable.classes.isNotEmpty
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
                          Text(i18n.page_classes_error_empty_title, style: textTheme.titleMedium),
                          Text(i18n.page_classes_error_empty_subtitle),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
