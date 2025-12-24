import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/infrastructure/event_bus.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await getIt.allReady();
  setupEventListener();
  final app = Corrupt();
  runApp(UncontrolledProviderScope(container: getIt<ProviderContainer>(), child: app));
}

class Corrupt extends ConsumerWidget {
  const Corrupt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = 0xFF5E18AB;
    final lightColorTheme = ColorScheme.fromSeed(
      seedColor: Color(color),
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final darkColorTheme = ColorScheme.fromSeed(
      seedColor: Color(color),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final themeSetting = ref.watch(prefProvider(SettingKeysGen.themeSwitch));
    final themeMode = switch (themeSetting.when(
      data: (d) => d.toNullable()!,
      error: (_, _) => SettingKeysGen.themeSwitchValue0,
      loading: () => SettingKeysGen.themeSwitchValue0,
    )) {
      SettingKeysGen.themeSwitchValue1 => ThemeMode.light,
      SettingKeysGen.themeSwitchValue2 => ThemeMode.dark,
      SettingKeysGen.themeSwitchValue0 || _ => ThemeMode.system,
    };
    return MaterialApp(
      title: 'corrupt',
      theme: ThemeData(colorScheme: lightColorTheme),
      darkTheme: ThemeData(colorScheme: darkColorTheme),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: themeMode,
      home: MainScreen(),
    );
  }
}
