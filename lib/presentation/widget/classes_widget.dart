import 'dart:async' show Timer;
import 'dart:math';

import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/util/class_time_util.dart';
import 'package:corrupt/presentation/util/platform_util.dart';
import 'package:dartlin/dartlin.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intl/intl.dart';

class ClassesWidget extends ConsumerStatefulWidget {
  final ClassTable classTable;
  final ClassTime classTime;
  final TermData? termData;
  final bool showTimeInspector;
  final bool showDateInspector;
  final double timeInspectorAlpha;
  final double dateInspectorAlpha;
  final int initialPageIndex;

  const ClassesWidget({
    super.key,
    required this.classTable,
    required this.classTime,
    required this.termData,
    required this.showTimeInspector,
    required this.showDateInspector,
    required this.timeInspectorAlpha,
    required this.dateInspectorAlpha,
    required this.initialPageIndex,
  });

  @override
  ConsumerState<ClassesWidget> createState() => _ClassesWidgetState();
}

class _ClassesWidgetState extends ConsumerState<ClassesWidget> with SingleTickerProviderStateMixin {
  static const int firstColWeight = 2;
  static const int normalClassColWeight = 3;
  static const int firstRowWeight = 4;
  static const int normalClassRowWeight = 5;
  static final DateFormat _dateFormat = DateFormat("HH:mm:ss");

  late final TabController _tabController;
  late final Timer _timer;

  var _timeCount = DateTime.timestamp().toLocal();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 20, vsync: this);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
      setState(() {
        _timeCount = DateTime.timestamp().toLocal();
      });
    });
    _tabController.index = widget.initialPageIndex;
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final termData = widget.termData;
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (PlatformUtils.isDesktop)
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: TabBar(
                    tabs: [for (final i in 0.to(19)) Tab(child: Text("${i + 1}"))],
                    controller: _tabController,
                  ),
                ),
              Flexible(
                flex: 95,
                fit: FlexFit.tight,
                child: _classTable(
                  context,
                  ref,
                  widget.classTable,
                  widget.classTime,
                  termData,
                  widget.showTimeInspector,
                  widget.showDateInspector,
                  widget.timeInspectorAlpha,
                  widget.dateInspectorAlpha,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getCurrentTimeWeight(ClassTime classTime) {
    final currentMillisecondOffset = _timeCount.let(
      (it) => it.hour * 60 * 60 * 1000 + it.minute * 60 * 1000 + it.second * 1000 + it.millisecond,
    );
    final classesLength = classTime.times.length;
    for (final (i, (fromMs, toMs)) in classTime.times.indexed) {
      if (fromMs < currentMillisecondOffset && toMs < currentMillisecondOffset) continue;
      if (fromMs > currentMillisecondOffset) {
        return i.toDouble() / classesLength;
      }
      if (fromMs <= currentMillisecondOffset && currentMillisecondOffset <= toMs) {
        final time = currentMillisecondOffset - fromMs;
        final length = toMs - fromMs;
        final weight = time / length.toDouble();
        return (i + weight) / classesLength;
      }
    }
    return classTime.times.length.toDouble() / classesLength;
  }

  Widget _classTable(
    BuildContext context,
    WidgetRef ref,
    ClassTable classTable,
    ClassTime classTime,
    TermData? currentTerm,
    bool showTimeInspector,
    bool showDateInspector,
    double timeInspectorAlpha,
    double dateInspectorAlpha,
  ) {
    return TabBarView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        for (final i in 0.to(19))
          _Page(
            _classTablePage(
              context,
              i,
              classTable,
              classTime,
              currentTerm,
              showTimeInspector,
              showDateInspector,
              timeInspectorAlpha,
              dateInspectorAlpha,
            ),
          ),
      ].toList(),
    );
  }

  Widget _classTablePage(
    BuildContext context,
    int weekIndex,
    ClassTable classTable,
    ClassTime classTime,
    TermData? currentTerm,
    bool showTimeInspector,
    bool showDateInspector,
    double timeInspectorAlpha,
    double dateInspectorAlpha,
  ) {
    final isCurrentWeek = currentTerm == null
        ? false
        : ClassTimeUtil.getCurrentWeek(_timeCount, currentTerm) == weekIndex;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: firstRowWeight,
              fit: FlexFit.tight,
              child: _classTimeRow(context, classTime, weekIndex),
            ),
            ...0
                .to(6)
                .map(
                  (dayIndex) => Flexible(
                    flex: normalClassRowWeight,
                    fit: FlexFit.tight,
                    child: _classRow(
                      context,
                      classTable,
                      classTime,
                      currentTerm,
                      weekIndex,
                      dayIndex,
                      showDateInspector,
                      dateInspectorAlpha,
                    ),
                  ),
                ),
          ],
        ),
        if (showTimeInspector && isCurrentWeek)
          _timeIndicator(context, classTime, timeInspectorAlpha),
      ],
    );
  }

  Widget _timeIndicator(BuildContext context, ClassTime classTime, double timeIndicatorAlpha) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final totalClasses = classTime.times.length;
    final weight = _getCurrentTimeWeight(classTime);
    final totalFlex = 1000;
    final unitFlex = totalFlex / ((totalClasses * normalClassColWeight) + firstColWeight);
    final reservedFlex = 30;
    final topFlex = unitFlex * firstColWeight;
    final baseFlex = topFlex - reservedFlex;
    final leftFlex = totalFlex - topFlex;
    return Column(
      children: [
        Flexible(flex: baseFlex.toInt(), fit: FlexFit.tight, child: SizedBox.shrink()),
        Flexible(flex: (weight * leftFlex).toInt(), fit: FlexFit.tight, child: SizedBox.shrink()),
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.directional(end: 8.0),
                child: Text(
                  _dateFormat.format(_timeCount),
                  style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((timeIndicatorAlpha * 255).toInt()),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: (leftFlex - weight * leftFlex).toInt(),
          fit: FlexFit.tight,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _classRow(
    BuildContext context,
    ClassTable classTable,
    ClassTime classTime,
    TermData? currentTerm,
    int weekIndex,
    int dayIndex,
    bool showDateInspector,
    double dateInspectorAlpha,
  ) {
    final i18n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final firstDay = currentTerm?.theFirstDay;
    final targetDay = firstDay?.add(Duration(days: 7 * weekIndex + dayIndex));
    final targetClasses = classTable.classes
        .filter((it) => it.weeks.contains(weekIndex) && it.dayOfWeek == DayOfWeek.valueOf(dayIndex))
        .mergeClasses();
    final currentDay = _timeCount;
    final showIndicator =
        currentDay.day == targetDay?.day &&
        currentDay.year == targetDay?.year &&
        currentDay.month == targetDay?.month &&
        showDateInspector;
    return Container(
      decoration: showIndicator
          ? BoxDecoration(
              color: colorScheme.primary.withAlpha((dateInspectorAlpha * 255).toInt()),
              borderRadius: BorderRadius.circular(8.0),
            )
          : null,
      child: Column(
        children: [
          Flexible(
            flex: firstColWeight,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(switch (DayOfWeek.valueOf(dayIndex)) {
                  DayOfWeek.mon => i18n.common_mon,
                  DayOfWeek.tue => i18n.common_tue,
                  DayOfWeek.wed => i18n.common_wed,
                  DayOfWeek.thu => i18n.common_thu,
                  DayOfWeek.fri => i18n.common_fri,
                  DayOfWeek.sat => i18n.common_sat,
                  DayOfWeek.sun || _ => i18n.common_sun,
                }),
                if (targetDay != null)
                  Text(
                    "${targetDay.day == 1 ? "${targetDay.month}." : ""}${targetDay.day}",
                    style: textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Flexible(
            flex: normalClassColWeight * classTime.times.length,
            fit: FlexFit.tight,
            child: Stack(children: [..._singleClassCol(targetClasses, context, classTime)]),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _singleClassCol(
    Iterable<ClassEntity> classList,
    BuildContext context,
    ClassTime classTime,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return classList.map(
      (it) => Column(
        children: [
          Flexible(flex: it.time, fit: FlexFit.tight, child: SizedBox.shrink()),
          Flexible(
            flex: it.duration,
            fit: FlexFit.tight,
            child: SizedBox.expand(
              child: Card(
                margin: EdgeInsetsGeometry.all(2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(4.0)),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(it.name, style: textTheme.labelSmall, textAlign: TextAlign.center),
                      Text(it.place, style: textTheme.labelSmall, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: classTime.times.length - it.duration - it.time,
            fit: FlexFit.tight,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _classTimeRow(BuildContext context, ClassTime classTime, int weekIndex) {
    final i18n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    String toTimeString(int time) => (time / 1000 / 60).let(
      (min) => (min / 60).toInt().let(
        (hour) =>
            "${hour.toString().let((s) => s.length == 1 ? "0$s" : s)}:${((min - hour * 60).toInt()).toString().let((s) => s.length == 1 ? "0$s" : s)}",
      ),
    );
    return Column(
      children: [
        Flexible(
          flex: firstColWeight,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(i18n.page_classes_week),
              Text("${weekIndex + 1}", style: textTheme.bodySmall),
            ],
          ),
        ),
        ...classTime.times.mapIndexed(
          (index, time) => Flexible(
            flex: normalClassColWeight,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("${index + 1}"), Text(toTimeString(time.$1))],
            ),
          ),
        ),
      ],
    );
  }
}

class _Page extends StatefulWidget {
  final Widget widget;

  const _Page(this.widget);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<_Page> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.widget;
  }

  @override
  bool get wantKeepAlive => true;
}

extension on Iterable<ClassEntity> {
  Iterable<ClassEntity> mergeClasses() {
    final result = <ClassEntity>[];
    0.to(6).forEach((index) {
      final aDow = filter(
        (it) => it.dayOfWeek.value == index,
      ).sortWith((it) => it.time, Order.orderInt);
      var lastClass = null as ClassEntity?;
      for (final it in aDow) {
        if (lastClass == null) {
          lastClass = it;
          continue;
        }
        if (lastClass.name == it.name &&
            lastClass.dayOfWeek == it.dayOfWeek &&
            lastClass.place == it.place &&
            lastClass.teacher == it.teacher &&
            lastClass.duration + lastClass.time == it.time) {
          lastClass = ClassEntity(
            it.name,
            it.teacher,
            it.dayOfWeek,
            min(it.time, lastClass.time),
            it.duration + lastClass.duration,
            it.weeks,
            it.place,
            it.user,
          );
          continue;
        }
        result.add(lastClass);
        lastClass = it;
      }
      if (lastClass != null) result.add(lastClass);
    });
    return result;
  }
}
