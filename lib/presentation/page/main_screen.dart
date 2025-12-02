// ignore_for_file: unused_element_parameter

import 'dart:io';

import 'package:corrupt/features/info/provider/path_provider.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/features/refresh/provider/refresh_provider.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/function_pages/function_classes_page.dart';
import 'package:corrupt/presentation/page/function_pages/function_exams_page.dart';
import 'package:corrupt/presentation/page/function_pages/function_scores_page.dart';
import 'package:corrupt/presentation/page/navigation_pages/settings_page.dart';
import 'package:corrupt/presentation/util/duration_consts.dart';
import 'package:corrupt/presentation/util/platform_util.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'navigation_pages/classes_page.dart';
import 'navigation_pages/home/home_page.dart';

final StateProvider<int> mainStateCurrentPage = StateProvider((_) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = AppLocalizations.of(context)!;
    final currentPage = ref.watch(mainStateCurrentPage);
    final navigationDestinations = <_CustomNavigationDestination>[
      _CustomNavigationDestination(
        icon: Icon(Icons.home),
        label: i18n.screen_main_tab_home,
        showOnNavigator: true,
      ),
      _CustomNavigationDestination(
        icon: Icon(Icons.class_),
        label: i18n.screen_main_tab_classes,
        showOnNavigator: true,
      ),
      _CustomNavigationDestination(
        icon: Icon(Icons.settings),
        label: i18n.screen_main_tab_settings,
        showOnNavigator: true,
      ),
      _CustomNavigationDestination(
        icon: Icon(Icons.class_),
        label: i18n.page_home_functions_classes,
      ),
      _CustomNavigationDestination(icon: Icon(Icons.school), label: i18n.page_home_functions_exams),
      _CustomNavigationDestination(icon: Icon(Icons.star), label: i18n.page_home_functions_scores),
    ];
    final showedDestinations = navigationDestinations.filter((it) => it.showOnNavigator).toList();
    final navigationScreen = <Widget>[
      const HomePage(),
      ClassesPage(),
      SettingsPage(),
      FunctionClassesPage(),
      FunctionExamsPage(),
      FunctionScoresPage(),
    ];
    final currentDestination = navigationDestinations[currentPage];
    final refreshState = ref.watch(refreshNotifierProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final enableBackgroundSetting = ref.watch(prefProvider(SettingKeysGen.backgroundSwitch));
    final backgroundAlphaSetting = ref.watch(prefProvider(SettingKeysGen.backgroundAlpha));
    final appbarAlphaSetting = ref.watch(prefProvider(SettingKeysGen.appbarAlpha));
    final navigationBarSetting = ref.watch(prefProvider(SettingKeysGen.navigationBarAlpha));
    final backgroundPath = ref.watch(applicationSupportPathProvider);
    final isLoggedResult = ref.watch(prefProvider(LocalDataKey.logged));
    final neededValue = <AsyncValue<Option<dynamic>>>[
      enableBackgroundSetting,
      backgroundAlphaSetting,
      appbarAlphaSetting,
      navigationBarSetting,
      backgroundPath,
      isLoggedResult,
    ];
    return Material(
      child: loadWaitingMask(
        context: context,
        values: neededValue,
        requiredValues: neededValue,
        child: (result) {
          final enableBackground = result[0] as bool;
          final backgroundAlpha = result[1] as double;
          final appbarAlpha = result[2] as double;
          final navigationBarAlpha = result[3] as double;
          final background = result[4] as Directory;
          final isLogged = result[5] as bool;
          final backgroundFile = File("${background.path}/background");
          final tooltipKey = GlobalKey<TooltipState>();
          return Stack(
            children: [
              if (enableBackground && backgroundFile.existsSync())
                SizedBox.expand(child: Image.file(backgroundFile, fit: BoxFit.cover)),
              Scaffold(
                backgroundColor: theme.canvasColor.withAlpha(((1 - backgroundAlpha) * 255).toInt()),
                appBar: _AppbarInkwell(
                  onTap: () {
                    ref.invalidate(refreshNotifierProvider);
                  },
                  child: AppBar(
                    backgroundColor: theme.canvasColor.withAlpha((appbarAlpha * 255).toInt()),
                    toolbarHeight: 64,
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              simpleAnimatedSize(
                                show:
                                    !currentDestination.showOnNavigator &&
                                    (PlatformUtils.isDesktop || Platform.isIOS),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ref.read(mainStateCurrentPage.notifier).state = 0;
                                      },
                                      icon: Icon(Icons.arrow_back),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      simpleAnimatedSize(
                                        show: !currentDestination.showOnNavigator,
                                        child: Row(
                                          children: [currentDestination.icon, SizedBox(width: 16)],
                                        ),
                                      ),
                                      Text(currentDestination.label),
                                    ],
                                  ),
                                  simpleAnimatedSize(
                                    show: refreshState.when(
                                      data: (x) => x.isRefreshing,
                                      error: (_, _) => false,
                                      loading: () => false,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 2.0),
                                        SizedBox(
                                          width: 12.0,
                                          height: 12.0,
                                          child: CircularProgressIndicator(strokeWidth: 2.0),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          refreshState.when(
                                            data: (it) => it.displayFunction(i18n),
                                            error: (a, b) {
                                              return i18n.screen_main_refresh_error;
                                            },
                                            loading: () => i18n.screen_main_refresh_waiting,
                                          ),
                                          style: textTheme.labelLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!isLogged)
                          Flexible(
                            flex: 0,
                            child: Tooltip(
                              key: tooltipKey,
                              triggerMode: TooltipTriggerMode.manual,
                              message: i18n.screen_main_tooltip_not_logged,
                              waitDuration: Duration.zero,
                              child: IconButton(
                                onPressed: () {
                                  tooltipKey.currentState?.ensureTooltipVisible();
                                },
                                icon: Icon(Icons.key_off_outlined),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                body: PopScope(
                  onPopInvokedWithResult: (_, _) {
                    ref.read(mainStateCurrentPage.notifier).state = 0;
                  },
                  canPop: currentPage == 0,
                  child: AnimatedSwitcher(
                    duration: MaterialDurations.short,
                    child: navigationScreen[currentPage],
                  ),
                ),
                bottomNavigationBar: simpleAnimatedSize(
                  show: !(currentDestination.isFullScreen || !currentDestination.showOnNavigator),
                  child: NavigationBar(
                    backgroundColor: theme.canvasColor.withAlpha(
                      (navigationBarAlpha * 255).toInt(),
                    ),
                    destinations: showedDestinations,
                    selectedIndex: currentPage.clamp(0, 2),
                    onDestinationSelected: (int dest) {
                      ref.read(mainStateCurrentPage.notifier).state = dest;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppbarInkwell extends InkWell implements PreferredSizeWidget {
  const _AppbarInkwell({
    super.key,
    super.child,
    super.onTap,
    super.onDoubleTap,
    super.onLongPress,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onSecondaryTap,
    super.onSecondaryTapUp,
    super.onSecondaryTapDown,
    super.onSecondaryTapCancel,
    super.onHighlightChanged,
    super.onHover,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.overlayColor,
    super.splashColor,
    super.splashFactory,
    super.radius,
    super.borderRadius,
    super.customBorder,
    super.enableFeedback,
    super.excludeFromSemantics,
    super.focusNode,
    super.canRequestFocus,
    super.onFocusChange,
    super.autofocus,
    super.statesController,
    super.hoverDuration,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.0);
}

class _CustomNavigationDestination extends NavigationDestination {
  final bool showOnNavigator;
  final bool isFullScreen;

  const _CustomNavigationDestination({
    required super.icon,
    required super.label,
    this.showOnNavigator = false,
    this.isFullScreen = false,
  });
}
