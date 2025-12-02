
part of 'settings_page.dart';

class SettingComponentsGen {
  static final themeSwitch = SettingComponent<String>(
    settingsKey: SettingKeysGen.themeSwitch,
    leading: Icon(Icons.dark_mode),
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_theme),
    description: null,
  );
  static Map<String,String> themeSwitchValues(AppLocalizations i18n) => <String,String>{
    "follow_system": i18n.settings_customize_theme_1,
    "light": i18n.settings_customize_theme_2,
    "dark": i18n.settings_customize_theme_3
  };
  static final colorScheme = SettingComponent<String>(
    settingsKey: SettingKeysGen.colorScheme,
    leading: Icon(Icons.color_lens),
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_color),
    description: null,
  );
  static Map<String,String> colorSchemeValues(AppLocalizations i18n) => <String,String>{
    "corrupt_default": i18n.settings_customize_color_1,
    "dynamic": i18n.settings_customize_color_2,
    "background": i18n.settings_customize_color_3,
    "iota": i18n.settings_customize_color_4,
    "miku": i18n.settings_customize_color_5
  };
  static final backgroundSwitch = SettingComponent<bool>(
    settingsKey: SettingKeysGen.backgroundSwitch,
    leading: Icon(Icons.image),
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_background_switch),
    description: null,
  );
  static final backgroundSelect = SettingComponent<void>(
    settingsKey: null,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_background_select),
    description: null,
  );
  static final backgroundAlpha = SettingComponent<double>(
    settingsKey: SettingKeysGen.backgroundAlpha,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_background_alpha),
    description: null,
  );
  static final appbarAlpha = SettingComponent<double>(
    settingsKey: SettingKeysGen.appbarAlpha,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_appbar_alpha),
    description: null,
  );
  static final navigationBarAlpha = SettingComponent<double>(
    settingsKey: SettingKeysGen.navigationBarAlpha,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_navigation_bar_alpha),
    description: null,
  );
  static final settingsCustomizeLegacyColorSwitch = SettingComponent<bool>(
    settingsKey: SettingKeysGen.settingsCustomizeLegacyColorSwitch,
    leading: Icon(Icons.history),
    trailing: null,
    title: (i18n)=>Text(i18n.settings_customize_legacy_color_switch),
    description: (i18n)=>Text(i18n.settings_customize_legacy_color_switch_subtitle),
  );
  static final classesCardStyle = SettingComponent<String>(
    settingsKey: SettingKeysGen.classesCardStyle,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_home_classes_card_style),
    description: null,
  );
  static Map<String,String> classesCardStyleValues(AppLocalizations i18n) => <String,String>{
    "linear_below": i18n.settings_home_classes_card_style_1,
    "linear_above": i18n.settings_home_classes_card_style_2,
    "circular_right": i18n.settings_home_classes_card_style_3
  };
  static final classInspectorSwitch = SettingComponent<bool>(
    settingsKey: SettingKeysGen.classInspectorSwitch,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_classes_time_inspector_switch),
    description: (i18n)=>Text(i18n.settings_classes_time_inspector_switch_subtitle),
  );
  static final classInspectorAlpha = SettingComponent<double>(
    settingsKey: SettingKeysGen.classInspectorAlpha,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_classes_time_inspector_alpha),
    description: null,
  );
  static final dateInspectorSwitch = SettingComponent<bool>(
    settingsKey: SettingKeysGen.dateInspectorSwitch,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_classes_date_inspector_switch),
    description: (i18n)=>Text(i18n.settings_classes_date_inspector_switch_subtitle),
  );
  static final dateInspectorAlpha = SettingComponent<double>(
    settingsKey: SettingKeysGen.dateInspectorAlpha,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_classes_date_inspector_alpha),
    description: null,
  );
  static final classDataSource = SettingComponent<String>(
    settingsKey: SettingKeysGen.classDataSource,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_classes_data_source),
    description: null,
  );
  static Map<String,String> classDataSourceValues(AppLocalizations i18n) => <String,String>{
    "default": i18n.settings_classes_data_source_1,
    "date": i18n.settings_classes_data_source_2
  };
  static final refreshFrequency = SettingComponent<String>(
    settingsKey: SettingKeysGen.refreshFrequency,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_software_refresh_frequency),
    description: null,
  );
  static Map<String,String> refreshFrequencyValues(AppLocalizations i18n) => <String,String>{
    "always": i18n.settings_software_refresh_frequency_1,
    "5min": i18n.settings_software_refresh_frequency_2,
    "10min": i18n.settings_software_refresh_frequency_3,
    "30min": i18n.settings_software_refresh_frequency_4,
    "never": i18n.settings_software_refresh_frequency_5
  };
  static final updateChecking = SettingComponent<bool>(
    settingsKey: SettingKeysGen.updateChecking,
    leading: null,
    trailing: null,
    title: (i18n)=>Text(i18n.settings_software_update_checking_switch),
    description: (i18n)=>Text(i18n.settings_software_update_checking_switch_subtitle),
  );
}

class SettingComponent<T>{
  final CirnoPrefKey<T, T>? settingsKey;
  final Widget? leading;
  final Widget? trailing;
  final Widget Function(AppLocalizations i18n) title;
  final Widget Function(AppLocalizations i18n)? description;
  SettingComponent({this.settingsKey, this.leading, this.trailing,
    required this.title, this.description});
}

