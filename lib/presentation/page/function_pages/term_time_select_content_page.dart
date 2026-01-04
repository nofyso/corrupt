import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/presentation/widget/error_widget.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:dartlin/dartlin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class TermTimeSelectContentPage extends ConsumerStatefulWidget {
  final List<
    AsyncNotifierFamilyProvider<
      dynamic,
      Either<SchoolDataFetchFailure, dynamic>,
      dynamic
    >
  >
  Function(TermBasedFetchArgument? argument)
  providerFetcher;
  final AvailableTermTime Function(List<dynamic> t) availableTermTimeExtract;
  final (String, String) Function(List<dynamic> t) currentTermTimeExtract;
  final Widget Function(List<dynamic> t) child;

  const TermTimeSelectContentPage({
    super.key,
    required this.providerFetcher,
    required this.availableTermTimeExtract,
    required this.currentTermTimeExtract,
    required this.child,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermTimeSelectContentPageState();
}

class _TermTimeSelectContentPageState
    extends ConsumerState<TermTimeSelectContentPage> {
  String? selectedAcademicYear;
  String? selectedSemester;
  TermBasedFetchArgument? _argument;

  @override
  Widget build(BuildContext context) {
    final providers = widget.providerFetcher(_argument);
    final asyncValues = providers.map((it) => ref.watch(it));
    return onlineLoadWaitingMask(
      values: asyncValues.toList(),
      failedChild: (failures) {
        return commonSchoolDataFailureWidget(
          context: context,
          rawFailures: failures,
          onRefresh: () {
            setState(() {
              _argument = null;
            });
            for (final it in providers) {
              ref.invalidate(it);
            }
          },
        );
      },
      succeedChild: (result) {
        final availableTermTime = widget.availableTermTimeExtract(result);
        final (academicYear, semester) = widget.currentTermTimeExtract(result);
        setState(() {
          selectedAcademicYear = academicYear;
          selectedSemester = semester;
        });
        return Column(
          children: [
            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    items: availableTermTime.availableAcademicYear
                        .map(
                          (it) => DropdownMenuItem<String>(
                            value: it.$1,
                            child: Text(it.$1),
                          ),
                        )
                        .toList(),
                    value: academicYear,
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
                    items: availableTermTime.availableSemester
                        .map(
                          (it) => DropdownMenuItem<String>(
                            value: it.$1,
                            child: Text(it.$1),
                          ),
                        )
                        .toList(),
                    value: semester,
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
            Expanded(child: widget.child(result)),
          ],
        );
      },
    );
  }
}
