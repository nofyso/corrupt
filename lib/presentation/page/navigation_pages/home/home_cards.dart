part of 'home_page.dart';

final List<FunctionCardEntry> functions = [
  FunctionCardEntry(
    cardTextFunction: (i18n) => i18n.page_home_functions_classes,
    icon: Icons.class_,
    jumpFunction: (context, ref) {
      ref.read(mainStateCurrentPage.notifier).state = 3;
    },
  ),
  FunctionCardEntry(
    cardTextFunction: (i18n) => i18n.page_home_functions_exams,
    icon: Icons.school,
    jumpFunction: (context, ref) {
      ref.read(mainStateCurrentPage.notifier).state = 4;
    },
  ),
  FunctionCardEntry(
    cardTextFunction: (i18n) => i18n.page_home_functions_scores,
    icon: Icons.star,
    jumpFunction: (context, ref) {
      ref.read(mainStateCurrentPage.notifier).state = 5;
    },
  ) /*
  FunctionCardEntry(
    cardTextFunction: (i18n) => i18n.page_home_functions_fafu_lib,
    icon: Icons.local_library,
    jumpFunction: (context, ref) {}, //TODO
  ),*/,
];

Widget _cardRequestLogin(BuildContext context) {
  final i18n = AppLocalizations.of(context)!;
  return cardWithPadding(
    child: Column(
      children: [
        cardHead(context, Icons.login, i18n.page_home_req_title),
        SizedBox(height: 8),
        Text(i18n.page_home_req_content),
        SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => Material(child: LoginScreen())),
              );
            },
            child: Text(i18n.page_home_req_button),
          ),
        ),
      ],
    ),
  );
}

Widget _cardClassTime(BuildContext context, DateTime time, WidgetRef ref) {
  (ClassEntity? current, ClassEntity? previous, ClassEntity? next, int msLeft, bool inClass)?
  getClassStatus(ClassTable classTable, List<TermData> termDataList, ClassTime classTime) {
    final currentTerm = ClassTimeUtil.selectCurrentTermData(time, termDataList);
    if (currentTerm == null) return null;
    final currentWeek = ClassTimeUtil.getCurrentWeek(time, currentTerm);
    final classes = classTable.classes
        .filter(
          (it) =>
              it.weeks.contains(currentWeek) &&
              it.dayOfWeek == DayOfWeek.fromDateTime(time.weekday),
        )
        .flatMap(
          (it) => it.duration > 1
              ? 0
                    .to(it.duration - 1)
                    .map(
                      (offset) => ClassEntity(
                        it.name,
                        it.teacher,
                        it.dayOfWeek,
                        it.time + offset,
                        1,
                        it.weeks,
                        it.place,
                        it.user,
                      ),
                    )
              : [it],
        )
        .sortWith((it) => it.time, Order.orderInt);
    if (classes.isEmpty) return (null, null, null, -1, false);
    final currentMillisecondOffset = time.let(
      (it) => it.hour * 60 * 60 * 1000 + it.minute * 60 * 1000 + it.second * 1000 + it.millisecond,
    );
    final classTimeMap = classTime.times;
    for (final (i, it) in classes.indexed) {
      final (fromMs, toMs) = classTimeMap[it.time];
      if (currentMillisecondOffset > fromMs && currentMillisecondOffset > toMs) continue;
      if (currentMillisecondOffset < fromMs) {
        return (null, classes.getOrNull(i - 1), it, fromMs - currentMillisecondOffset, false);
      }
      return (
        it,
        classes.getOrNull(i - 1),
        classes.getOrNull(i + 1),
        toMs - currentMillisecondOffset,
        true,
      );
    }
    return (null, null, null, -2, false);
  }

  final i18n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final colorTheme = theme.colorScheme;
  final isLoggedResult = ref.watch(prefProvider(LocalDataKey.logged));
  final neededValue = <AsyncValue<Option<dynamic>>>[
    ref.watch(classLocalProviderMap[DataFetchType.classes]!),
    ref.watch(classLocalProviderMap[DataFetchType.termData]!),
    ref.watch(classLocalProviderMap[DataFetchType.classTime]!),
    ref.watch(prefProvider(SettingKeysGen.classesCardStyle)),
    isLoggedResult,
  ];
  return cardWithPadding(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        cardHead(context, Icons.class_, i18n.page_home_class_title),
        SizedBox(height: 8),
        loadWaitingMask(
          values: neededValue,
          requiredValues: [isLoggedResult],
          context: context,
          child: (result) {
            final classTable = result[0] as ClassTable?;
            final termDataList = result[1] as List<TermData>?;
            final classTime = result[2] as ClassTime?;
            final isLogged = result[4] as bool;
            if (classTable == null || termDataList == null || classTime == null) {
              return Center(
                child: !isLogged
                    ? iconTitleAndSubtitle(
                        context: context,
                        icon: Icons.key_off,
                        title: i18n.page_home_class_error_no_content_title,
                        subtitle: i18n.page_home_class_error_no_content_not_logged,
                      )
                    : iconTitleAndSubtitle(
                        context: context,
                        icon: Icons.circle_outlined,
                        title: i18n.page_home_class_error_no_content_title,
                        subtitle: i18n.page_home_class_error_no_content_empty,
                      ),
              );
            }
            final cardStyle = result[3] as String;
            final classStatus = getClassStatus(classTable, termDataList, classTime);
            if (classStatus == null) {
              return Center(
                child: iconTitleAndSubtitle(
                  context: context,
                  icon: Icons.error_outline,
                  title: i18n.page_home_class_error_wrong_data_title,
                  subtitle: i18n.page_home_class_error_wrong_data_content_term,
                ),
              );
            }
            final (
              ClassEntity? current,
              ClassEntity? previous,
              ClassEntity? next,
              int msLeft,
              bool isInClass,
            ) = classStatus;
            final classTimeMap = classTime.times;
            final isNoClass = current == null && previous == null && next == null && msLeft == -1;
            final isAllFinished =
                current == null && previous == null && next == null && msLeft == -2;
            final List<Widget> textWidgets = isInClass
                ? [
                    Text(i18n.page_home_class_current_class("${current!.name}@${current.place}")),
                    Text(i18n.page_home_class_times_left(_formatTime(msLeft))),
                    ...next == null
                        ? []
                        : [Text(i18n.page_home_class_next_class("${next.name}@${next.place}"))],
                  ]
                : (isNoClass
                      ? [Text(i18n.page_home_class_empty)]
                      : (isAllFinished
                            ? [Text(i18n.page_home_class_all_finished)]
                            : next!.let(
                                (it) => [
                                  Text(i18n.page_home_class_next_class("${it.name}@${it.place}")),
                                  Text(i18n.page_home_class_times_coming(_formatTime(msLeft))),
                                ],
                              )));
            final progress = isInClass
                ? classTimeMap[current!.time].let((it) => msLeft / (it.$2 - it.$1))
                : (isNoClass
                      ? 0.0
                      : (isAllFinished
                            ? 0.0
                            : 1 -
                                  msLeft /
                                      (classTimeMap[next!.time].$1 -
                                          (previous == null
                                              ? 0
                                              : classTimeMap[previous.time].$2))));
            final weight = switch (cardStyle) {
              SettingKeysGen.classesCardStyleValue1 => Padding(
                padding: EdgeInsetsGeometry.directional(start: 0, end: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isAllFinished && !isNoClass) ...[
                      LinearProgressIndicator(value: progress),
                      SizedBox(height: 8),
                    ],
                    ...textWidgets,
                  ],
                ),
              ),
              SettingKeysGen.classesCardStyleValue2 => Padding(
                padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: textWidgets,
                      ),
                    ),
                    if (!isAllFinished && !isNoClass) ...[
                      SizedBox(width: 16),
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: progress,
                          backgroundColor: colorTheme.secondaryContainer,
                          strokeCap: StrokeCap.square,
                          strokeWidth: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SettingKeysGen.classesCardStyleValue0 || _ => Padding(
                padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...textWidgets,
                    if (!isAllFinished && !isNoClass) ...[
                      SizedBox(height: 8),
                      LinearProgressIndicator(value: progress),
                    ],
                  ],
                ),
              ),
            };
            return weight;
          },
        ),
      ],
    ),
  );
}

Widget _cardUpdate(BuildContext context, WidgetRef ref) {
  return HomeUpdateCard();
}

final dateFormat = DateFormat("yyyy-MM-dd EEE");
final timeFormat = DateFormat("HH:mm:ss");

Widget _cardTime(BuildContext context, DateTime dateTime) {
  final textTheme = Theme.of(context).textTheme;
  return cardWithPadding(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(dateTime.timeZoneName),
        Text(dateFormat.format(dateTime)),
        Text(timeFormat.format(dateTime), style: textTheme.bodyLarge),
      ],
    ),
  ); //TODO add timing card
}

Widget _cardGreeting(BuildContext context, DateTime time) {
  final i18n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  (String, String) selectPair() {
    final hour = time.hour;
    return switch (hour) {
      final x when (0 <= x && x <= 1) || x >= 23 => (
        i18n.page_home_greeting_sleeping_title,
        i18n.page_home_greeting_sleeping_content,
      ),
      final x when 2 <= x && x <= 4 => (
        i18n.page_home_greeting_deep_night_title,
        i18n.page_home_greeting_deep_night_content,
      ),
      final x when 5 <= x && x <= 6 => (
        i18n.page_home_greeting_early_morning_title,
        i18n.page_home_greeting_early_morning_content,
      ),
      final x when 7 <= x && x <= 8 => (
        i18n.page_home_greeting_morning_title,
        i18n.page_home_greeting_morning_content,
      ),
      final x when 9 <= x && x <= 11 => (
        i18n.page_home_greeting_morning_class_title,
        i18n.page_home_greeting_morning_class_content,
      ),
      final x when 12 <= x && x <= 12 => (
        i18n.page_home_greeting_lunch_title,
        i18n.page_home_greeting_lunch_content,
      ),
      final x when 13 <= x && x <= 13 => (
        i18n.page_home_greeting_after_lunch_title,
        i18n.page_home_greeting_after_lunch_content,
      ),
      final x when 14 <= x && x <= 16 => (
        i18n.page_home_greeting_afternoon_title,
        i18n.page_home_greeting_afternoon_content,
      ),
      final x when 17 <= x && x <= 18 => (
        i18n.page_home_greeting_evening_title,
        i18n.page_home_greeting_evening_content,
      ),
      final x when 19 <= x && x <= 22 => (
        i18n.page_home_greeting_night_title,
        i18n.page_home_greeting_night_content,
      ),
      _ => ("", ""),
    };
  }

  final (title, content) = selectPair();
  return cardWithPadding(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        Text(content),
      ],
    ),
  );
}

Widget _cardFunctions(BuildContext context, WidgetRef ref) {
  //TODO
  final impl = getIt<SchoolImplSelectUseCase>();
  final i18n = AppLocalizations.of(context)!;
  return cardWithPadding(
    child: Column(
      children: [
        cardHead(context, Icons.functions, i18n.page_home_functions_title),
        SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          children: [
            ...functions.map(
              (it) => InkResponse(
                onTap: () {
                  it.jumpFunction(context, ref);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(it.icon), Text(it.cardTextFunction(i18n))],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget cardHead(BuildContext context, IconData iconData, String text) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  return Row(
    children: [
      Icon(iconData),
      SizedBox(width: 8),
      Text(text, style: textTheme.titleMedium),
    ],
  );
}

Widget cardWithPadding({required Widget child}) {
  return Padding(
    padding: EdgeInsetsGeometry.all(0),
    child: Card(
      child: Padding(padding: EdgeInsetsGeometry.all(16), child: child),
    ),
  );
}

String _formatTime(int millisecond) => (millisecond / 1000 / 60 / 60).let(
  (hour) => (millisecond / 1000 / 60 - hour.toInt() * 60).let(
    (min) => ((millisecond / 1000) - hour.toInt() * 60 * 60 - min.toInt() * 60).let(
      (sec) =>
          "${_addZero(hour.toInt().toString())}:${_addZero(min.toInt().toString())}:${_addZero(sec.toInt().toString())}",
    ),
  ),
);

String _addZero(String s) => s.length == 1 ? "0$s" : s;

class FunctionCardEntry {
  final String Function(AppLocalizations i18n) cardTextFunction;
  final IconData icon;
  final void Function(BuildContext context, WidgetRef ref) jumpFunction;

  FunctionCardEntry({
    required this.cardTextFunction,
    required this.icon,
    required this.jumpFunction,
  });
}
