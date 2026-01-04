import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/infrastructure/event_bus.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/main_screen.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await getIt.allReady();
  setupEventListener();
  final app = Corrupt();
  runApp(
    UncontrolledProviderScope(
      container: getIt<ProviderContainer>(),
      child: app,
    ),
  );
}

class Corrupt extends ConsumerWidget {
  const Corrupt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neededValue = [
      ref.watch(prefProvider(SettingKeysGen.colorScheme)),
      ref.watch(
        prefProvider(SettingKeysGen.settingsCustomizeLegacyColorSwitch),
      ),
    ];
    return Material(
      child: emptyLoadWaitingMask(
        values: neededValue,
        child: (value) {
          final theme = value[0] as String?;
          final legacyColor = value[1] as bool?;
          final (lightTheme, darkTheme) = getThemeData(
            theme,
            legacyColor == true,
          );
          final themeSetting = ref.watch(
            prefProvider(SettingKeysGen.themeSwitch),
          );
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
            theme: lightTheme,
            darkTheme: darkTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: themeMode,
            home: MainScreen(),
          );
        },
      ),
    );
  }

  (ThemeData, ThemeData) getThemeData(
    String? theme,
    bool legacy,
  ) => switch (theme) {
    SettingKeysGen.colorSchemeValue1 => (
      ThemeData.from(colorScheme: ColorScheme.fromSwatch(), useMaterial3: true),
      ThemeData.dark(useMaterial3: true),
    ),
    SettingKeysGen.colorSchemeValue3 => (
      ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  accentColor: Colors.cyan.shade200,
                  brightness: Brightness.light,
                  cardColor: Color.fromARGB(255, 250, 250, 250),
                  backgroundColor: Color.fromARGB(255, 250, 250, 250),
                )
                .copyWith(
                  surfaceContainerHighest: Color.fromARGB(255, 200, 200, 200),
                )
                .let((it) => legacy ? it.legacyTransform() : it),
      ),
      ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  accentColor: Colors.cyan.shade900,
                  brightness: Brightness.dark,
                  backgroundColor: Color.fromARGB(255, 20, 20, 20),
                  cardColor: Color.fromARGB(255, 20, 20, 20),
                )
                .copyWith(
                  surfaceContainerHighest: Color.fromARGB(255, 77, 77, 77),
                )
                .let((it) => legacy ? it.legacyTransform() : it),
      ),
    ),
    SettingKeysGen.colorSchemeValue4 => (
      ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(
                  primarySwatch: _mikuGreen,
                  accentColor: Colors.pink.shade200,
                  brightness: Brightness.light,
                  cardColor: Color.fromARGB(255, 250, 250, 250),
                  backgroundColor: Color.fromARGB(255, 250, 250, 250),
                )
                .copyWith(
                  surfaceContainerHighest: Color.fromARGB(255, 200, 200, 200),
                )
                .let((it) => legacy ? it.legacyTransform() : it),
      ),
      ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(
                  primarySwatch: _mikuGreen,
                  accentColor: Colors.pink.shade900,
                  brightness: Brightness.dark,
                  backgroundColor: Color.fromARGB(255, 20, 20, 20),
                  cardColor: Color.fromARGB(255, 20, 20, 20),
                )
                .copyWith(
                  surfaceContainerHighest: Color.fromARGB(255, 77, 77, 77),
                )
                .let((it) => legacy ? it.legacyTransform() : it),
      ),
    ),
    _ => (
      ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5E18AB),
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).let((it) => legacy ? it.legacyTransform() : it),
      ),
      ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5E18AB),
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).let((it) => legacy ? it.legacyTransform() : it),
      ),
    ),
  };
}

const Map<int, Color> _mikuGreenSwatch = {
  50: Color(0xFFE0F8F6),
  100: Color(0xFFB3EBE6),
  200: Color(0xFF80DDD5),
  300: Color(0xFF4DCFC4),
  400: Color(0xFF26C5B9),
  500: Color(0xFF39C5BB),
  600: Color(0xFF33B3A9),
  700: Color(0xFF2DA094),
  800: Color(0xFF278C80),
  900: Color(0xFF1D6A5D),
};
const MaterialColor _mikuGreen = MaterialColor(0xFF39C5BB, _mikuGreenSwatch);

extension on ColorScheme {
  ColorScheme legacyTransform() => copyWith(
    errorContainer: errorContainer.legacyTransform(),
    primaryContainer: primaryContainer.legacyTransform(),
    secondaryContainer: secondaryContainer.legacyTransform(),
    surfaceContainer: surfaceContainer.legacyTransform(),
    tertiaryContainer: tertiaryContainer.legacyTransform(),
    surface: surface.legacyTransform(),
    surfaceBright: surfaceBright.legacyTransform(),
    surfaceContainerHigh: surfaceContainerHigh.legacyTransform(),
    surfaceContainerHighest: surfaceContainerHighest.legacyTransform(),
    surfaceContainerLow: surfaceContainerLow.legacyTransform(),
    surfaceContainerLowest: surfaceContainerLowest.legacyTransform(),
    surfaceDim: surfaceDim.legacyTransform(),
    surfaceTint: surfaceTint.legacyTransform(),
  );
}

extension on Color {
  Color legacyTransform() => ((r + g + b) / 3.0).let(
    (it) => Color.from(alpha: a, red: it, green: it, blue: it),
  );
}
