import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/features/channel/provider/local_school_data_provider.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/features/refresh/provider/refresh_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/widget/classes_widget.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:corrupt/util/class_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;

class ClassesPage extends ConsumerStatefulWidget {
  const ClassesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassesPageState();
}

class _ClassesPageState extends ConsumerState<ClassesPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final classTableResult = ref.watch(
      classLocalProviderMap[DataFetchType.classes]!,
    );
    final termDataResult = ref.watch(
      classLocalProviderMap[DataFetchType.termData]!,
    );
    final classTimeResult = ref.watch(
      classLocalProviderMap[DataFetchType.classTime]!,
    );
    final showTimeInspector = ref.watch(
      prefProvider(SettingKeysGen.classInspectorSwitch),
    );
    final showDateInspector = ref.watch(
      prefProvider(SettingKeysGen.dateInspectorSwitch),
    );
    final timeInspectorAlpha = ref.watch(
      prefProvider(SettingKeysGen.classInspectorAlpha),
    );
    final dateInspectorAlpha = ref.watch(
      prefProvider(SettingKeysGen.dateInspectorAlpha),
    );
    final dataSource = ref.watch(prefProvider(SettingKeysGen.classDataSource));
    final isLoggedResult = ref.watch(prefProvider(LocalDataKey.logged));
    final neededValue = <AsyncValue<Option<dynamic>>>[
      classTableResult,
      termDataResult,
      classTimeResult,
      showTimeInspector,
      showDateInspector,
      timeInspectorAlpha,
      dateInspectorAlpha,
      dataSource,
      isLoggedResult,
    ];
    return loadWaitingMask(
      values: neededValue,
      requiredValues: [isLoggedResult, dataSource],
      context: context,
      child: (list) {
        final classTable = list[0] as ClassTable?;
        final termDataList = list[1] as List<TermData>?;
        final classTime = list[2] as ClassTime?;
        final showTimeInspector = list[3] as bool?;
        final showDateInspector = list[4] as bool?;
        final timeInspectorAlpha = list[5] as double?;
        final dateInspectorAlpha = list[6] as double?;
        final dataSource = list[7] as String;
        final isLogged = list[8] as bool;
        if (classTime == null ||
            termDataList == null ||
            classTable == null ||
            showTimeInspector == null ||
            showDateInspector == null ||
            timeInspectorAlpha == null ||
            dateInspectorAlpha == null) {
          return isLogged
              ? _noClassesPage(context, dataSource)
              : _notLoggedPage(context);
        }
        final time = DateTime.timestamp().toLocal();
        final termData = ClassTimeUtil.selectCurrentTermData(
          time,
          termDataList,
        );
        final initialPageIndex = termData.match(
          () => 0,
          (td) => ClassTimeUtil.getCurrentWeek(time, td),
        );
        return (classTable.classes.isNotEmpty || false
            ? ClassesWidget(
                classTable: classTable,
                classTime: classTime,
                termData: termData.toNullable(),
                showTimeInspector: showTimeInspector,
                showDateInspector: showDateInspector,
                timeInspectorAlpha: timeInspectorAlpha,
                dateInspectorAlpha: dateInspectorAlpha,
                initialPageIndex: initialPageIndex,
              )
            : _noClassesPage(context, dataSource));
      },
    );
  }

  Widget _noClassesPage(BuildContext context, String dataSourceRaw) {
    final i18n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final dataSource = ClassesDataSource.fromRawValue(dataSourceRaw);
    return Center(
      child: dataSource == ClassesDataSource.default_
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.blur_circular_outlined, size: 32),
                Text(
                  i18n.page_classes_error_main_empty_title,
                  style: textTheme.titleMedium,
                ),
                Text(
                  i18n.page_classes_error_main_empty_subtitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                textIconButton(
                  onPressed: () async {
                    await getIt<LocalRawDataRepository>().setData(
                      SettingKeysGen.classDataSource,
                      SettingKeysGen.classDataSourceValue1,
                    );
                    ref.invalidate(refreshNotifierProvider);
                  },
                  icon: Icons.settings,
                  text: i18n.page_classes_error_main_empty_button,
                ),
                SizedBox(
                  width: 256,
                  child: Text(
                    i18n.page_classes_error_main_empty_button_hint,
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle_outlined, size: 32),
                Text(
                  i18n.page_classes_error_main_empty_with_pref_title,
                  style: textTheme.titleMedium,
                ),
                Text(
                  i18n.page_classes_error_main_empty_with_pref_subtitle,
                  textAlign: TextAlign.center,
                ),
                textIconButton(
                  onPressed: () {
                    ref.invalidate(refreshNotifierProvider);
                  },
                  icon: Icons.refresh,
                  text: i18n.page_classes_error_main_empty_button,
                ),
              ],
            ),
    );
  }

  Widget _notLoggedPage(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.key_off, size: 32),
          Text(
            i18n.page_classes_error_not_logged_title,
            style: textTheme.titleMedium,
          ),
          Text(i18n.page_classes_error_not_logged_content),
        ],
      ),
    );
  }
}
