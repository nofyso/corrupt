import 'dart:io';

import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart' as settings_provider;
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:dartlin/control_flow.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';

part 'settings_page.g.dart';

final _switchSettingsProviderFamily = FutureProviderFamily<bool, CirnoPrefKey<bool, bool>>(
  (ref, arg) async => await arg.read(null),
);
final _selectSettingsProviderFamily = FutureProviderFamily<String, CirnoPrefKey<String, String>>(
  (ref, arg) async => await arg.read(null),
);
final _sliderSettingsProviderFamily = FutureProviderFamily<double, CirnoPrefKey<double, double>>(
  (ref, arg) async => await arg.read(null),
);

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  final map = <String, double>{};
  late AppLocalizations i18n;

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    ref.invalidate(_switchSettingsProviderFamily);
    ref.invalidate(_selectSettingsProviderFamily);
    ref.invalidate(_sliderSettingsProviderFamily);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final listTheme = SettingsThemeData(
      settingsListBackground: Color(0x00000000),
      titleTextColor: colorScheme.primary,
    );
    return SettingsList(
      platform: PlatformUtils.detectPlatform(
        context,
      ).let((it) => it == DevicePlatform.windows ? DevicePlatform.android : it),
      applicationType: ApplicationType.material,
      lightTheme: listTheme,
      darkTheme: listTheme,
      brightness: theme.brightness,
      sections: <SettingsSection>[
        SettingsSection(
          title: Text(i18n.settings_group_customize),
          tiles: <AbstractSettingsTile>[
            selectTile(
              component: SettingComponentsGen.themeSwitch,
              valueFun: SettingComponentsGen.themeSwitchValues,
            ),
            selectTile(
              component: SettingComponentsGen.colorScheme,
              valueFun: SettingComponentsGen.colorSchemeValues,
            ),
            switchTile(component: SettingComponentsGen.backgroundSwitch),
            navigationTile(
              component: SettingComponentsGen.backgroundSelect,
              onPressed: (context) async {
                final typeGroup = XTypeGroup(
                  label: 'images',
                  extensions: <String>['jpg', 'png'],
                  uniformTypeIdentifiers: <String>['public.jpeg', 'public.png'],
                );
                final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                if (file == null) return;
                final dataPath = await getApplicationSupportDirectory();
                File(file.path).copySync("${dataPath.path}/background");
              },
            ),
            sliderTile(
              component: SettingComponentsGen.backgroundAlpha,
              range: SettingKeysGen.backgroundAlphaRange,
            ),
            sliderTile(
              component: SettingComponentsGen.appbarAlpha,
              range: SettingKeysGen.appbarAlphaRange,
            ),
            sliderTile(
              component: SettingComponentsGen.navigationBarAlpha,
              range: SettingKeysGen.navigationBarAlphaRange,
            ),
            switchTile(component: SettingComponentsGen.settingsCustomizeLegacyColorSwitch),
          ],
        ),
        SettingsSection(
          title: Text(i18n.settings_group_home),
          tiles: <AbstractSettingsTile>[
            selectTile(
              component: SettingComponentsGen.classesCardStyle,
              valueFun: SettingComponentsGen.classesCardStyleValues,
            ),
          ],
        ),
        SettingsSection(
          title: Text(i18n.settings_group_classes),
          tiles: <AbstractSettingsTile>[
            switchTile(component: SettingComponentsGen.classInspectorSwitch),
            switchTile(component: SettingComponentsGen.dateInspectorSwitch),
            sliderTile(
              component: SettingComponentsGen.dateInspectorAlpha,
              range: SettingKeysGen.dateInspectorAlphaRange,
            ),
            sliderTile(
              component: SettingComponentsGen.classInspectorAlpha,
              range: SettingKeysGen.classInspectorAlphaRange,
            ),
            selectTile(
              component: SettingComponentsGen.classDataSource,
              valueFun: SettingComponentsGen.classDataSourceValues,
            ),
          ],
        ),
        SettingsSection(
          title: Text(i18n.settings_group_software),
          tiles: <AbstractSettingsTile>[
            selectTile(
              component: SettingComponentsGen.refreshFrequency,
              valueFun: SettingComponentsGen.refreshFrequencyValues,
            ),
            switchTile(component: SettingComponentsGen.updateChecking),
          ],
        ),
      ],
    );
  }

  AbstractSettingsTile sliderTile({
    required SettingComponent<double> component,
    required (double, double) range,
  }) {
    final settingsKey = component.settingsKey!;
    final settingsProvider = _sliderSettingsProviderFamily(settingsKey);
    final settingsValue = ref.watch(settingsProvider);
    final settingsData = settingsValue.when(
      data: (d) => d,
      error: (_, _) => settingsKey.defaultValueOT,
      loading: () => settingsKey.defaultValueOT,
    );
    return SettingsTile(
      title: component.title(i18n),
      description: Column(
        children: [
          ?component.description?.call(i18n),
          Slider(
            min: range.$1,
            max: range.$2,
            value: map[settingsKey.keyName] ?? settingsData,
            onChanged: (value) {
              setState(() {
                map[settingsKey.keyName] = value;
              });
            },
            onChangeEnd: (value) async {
              ref.invalidate(settingsProvider);
              await settingsKey.write(null, value);
              setState(() {
                map[settingsKey.keyName] = value;
              });
              ref.invalidate(settings_provider.prefProvider);
            },
          ),
        ],
      ),
    );
  }

  AbstractSettingsTile navigationTile({
    required SettingComponent<void> component,
    dynamic Function(BuildContext context)? onPressed,
  }) {
    return SettingsTile.navigation(
      title: component.title(i18n),
      leading: component.leading,
      description: component.description?.call(i18n),
      onPressed: onPressed,
      enabled: onPressed != null,
    );
  }

  AbstractSettingsTile selectTile({
    required SettingComponent<String> component,
    required Map<String, String> Function(AppLocalizations) valueFun,
  }) {
    final menuController = MenuController();
    final settingsKey = component.settingsKey!;
    final provider = _selectSettingsProviderFamily(settingsKey);
    final value = ref.watch(provider);
    final displayTextMap = valueFun(i18n);
    final data = value.when(
      data: (d) => displayTextMap[d] ?? "<Error>",
      error: (_, _) => displayTextMap[settingsKey.defaultValueOT] ?? "<Error>",
      loading: () => "...",
    );
    return SettingsTile.navigation(
      title: component.title(i18n),
      leading: component.leading,
      trailing: Stack(
        children: [
          MenuAnchor(
            controller: menuController,
            menuChildren: [
              ...displayTextMap
                  .map(
                    (key, it) => MapEntry(
                      key,
                      MenuItemButton(
                        child: Padding(padding: EdgeInsetsGeometry.all(16), child: Text(it)),
                        onPressed: () async {
                          await settingsKey.write(null, key);
                          ref.invalidate(provider);
                          ref.invalidate(settings_provider.prefProvider);
                        },
                      ),
                    ),
                  )
                  .values,
            ],
          ),
        ],
      ),
      //component.trailing,
      description: component.description?.call(i18n) ?? Text(data),
      onPressed: (context) {
        menuController.open();
      },
    );
  }

  AbstractSettingsTile switchTile({required SettingComponent<bool> component}) {
    final settingsKey = component.settingsKey!;
    final provider = _switchSettingsProviderFamily(settingsKey);
    final value = ref.watch(provider);
    final data = value.when(
      data: (d) => d,
      error: (_, _) => settingsKey.defaultValueOT,
      loading: () => settingsKey.defaultValueOT,
    );
    return SettingsTile.switchTile(
      initialValue: data,
      onToggle: (value) async {
        await settingsKey.write(null, value);
        ref.invalidate(provider);
        ref.invalidate(settings_provider.prefProvider);
      },
      title: component.title(i18n),
      leading: component.leading,
      trailing: component.trailing,
      description: component.description?.call(i18n),
    );
  }
}
