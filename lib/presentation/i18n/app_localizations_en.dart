// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get school_fafu => 'Fujian Agricultural and Forestry University';

  @override
  String get school_mju => 'Minjiang University';

  @override
  String get screen_main_tab_home => 'Corrupt';

  @override
  String get screen_main_tab_classes => 'Classes';

  @override
  String get screen_main_tab_settings => 'Settings';

  @override
  String get screen_main_refresh_classes => 'Updating classes';

  @override
  String get screen_main_refresh_exams => 'Updating exams';

  @override
  String get screen_main_refresh_terms => 'Updating terms';

  @override
  String get screen_main_refresh_class_time => 'Updating class time';

  @override
  String get screen_main_refresh_gate => '...';

  @override
  String get screen_main_refresh_update_check => 'Checking update';

  @override
  String get screen_main_refresh_error => 'Error';

  @override
  String get screen_main_refresh_waiting => 'Loading';

  @override
  String get screen_main_tooltip_not_logged =>
      'Not logged in, all you can see are caches...';

  @override
  String get screen_login_page1_title => 'Select your school';

  @override
  String get screen_login_page1_subtitle => 'Where are you now?';

  @override
  String get screen_login_page2_title => 'Login';

  @override
  String get screen_login_page2_subtitle_fafu =>
      'Log in the Educational Administration Management System of Fujian Agricultural and Forestry University via corrupt as a student.';

  @override
  String get screen_login_page2_back => 'Back to schools...';

  @override
  String get screen_login_page2_studentId => 'StudentID';

  @override
  String get screen_login_page2_password => 'Password';

  @override
  String get screen_login_page2_login => 'corrupt';

  @override
  String get screen_login_page2_hint => 'Logging in...';

  @override
  String get page_home_greeting_deep_night_title => 'What..?';

  @override
  String get page_home_greeting_deep_night_content =>
      'Don\'t kidding me, it does bad to your health...';

  @override
  String get page_home_greeting_early_morning_title => 'Good morning..?';

  @override
  String get page_home_greeting_early_morning_content =>
      'It\'s too early now... But do not tell me that you didn\'t sleep last night...';

  @override
  String get page_home_greeting_morning_title => 'Good morning!';

  @override
  String get page_home_greeting_morning_content =>
      'Did you have your breakfast? Have a nice day!';

  @override
  String get page_home_greeting_morning_class_title => 'A brand new day!';

  @override
  String get page_home_greeting_morning_class_content =>
      'Working? Studying? Or just playing? Hope everything is fine!';

  @override
  String get page_home_greeting_lunch_title => 'Feel hungry?';

  @override
  String get page_home_greeting_lunch_content =>
      'Yes, nothing is more important than having a lunch now!';

  @override
  String get page_home_greeting_after_lunch_title => 'Golden leisure time!';

  @override
  String get page_home_greeting_after_lunch_content =>
      'Time after lunch, the best time to have a rest!';

  @override
  String get page_home_greeting_afternoon_title => 'Good afternoon!';

  @override
  String get page_home_greeting_afternoon_content => 'Keep your determination!';

  @override
  String get page_home_greeting_evening_title => 'Did you noticed...';

  @override
  String get page_home_greeting_evening_content =>
      'Twilight is the most romantic time, nofyso said...';

  @override
  String get page_home_greeting_night_title => 'Free time!';

  @override
  String get page_home_greeting_night_content =>
      'Maybe you have some other activities?';

  @override
  String get page_home_greeting_sleeping_title => 'It\'s time to...';

  @override
  String get page_home_greeting_sleeping_content => 'go to the bed, exactly!';

  @override
  String get page_home_greeting_guest => 'Guest';

  @override
  String get page_home_class_title => 'Classes';

  @override
  String page_home_class_current_class(Object clazz) {
    return 'Current class: $clazz';
  }

  @override
  String page_home_class_next_class(Object clazz) {
    return 'Next class: $clazz';
  }

  @override
  String page_home_class_times_coming(Object time) {
    return 'Start after: $time';
  }

  @override
  String page_home_class_times_left(Object time) {
    return 'End after: $time';
  }

  @override
  String get page_home_class_all_finished => 'All classes are finished today!';

  @override
  String get page_home_class_empty => 'No classes today';

  @override
  String get page_home_class_error_no_content_title =>
      'Here\'s nothing but the void';

  @override
  String get page_home_class_error_no_content_not_logged =>
      'You\'re not logged in';

  @override
  String get page_home_class_error_no_content_empty => 'Try refresh?';

  @override
  String get page_home_class_error_wrong_data_title =>
      'Something went wrong...?';

  @override
  String get page_home_class_error_wrong_data_content_term =>
      'Contact to nofyso then let it add term data';

  @override
  String get page_home_req_title => 'Login';

  @override
  String get page_home_req_content =>
      'Login to get access to more information~';

  @override
  String get page_home_req_button => 'Login now';

  @override
  String get page_home_functions_title => 'Functions';

  @override
  String get page_home_functions_classes => 'Raw classes';

  @override
  String get page_home_functions_exams => 'Exams';

  @override
  String get page_home_functions_scores => 'Scores';

  @override
  String get page_home_functions_fafu_lib => 'Fafu Lib';

  @override
  String get page_home_update_title => 'Update';

  @override
  String get page_home_update_content => 'A new update available';

  @override
  String get page_home_update_os_android =>
      'An Android phone? Great! Here\'s our brand new build for you.';

  @override
  String get page_home_update_os_ios =>
      'You maybe know I have no money to pay 99\$ per year... So could you please download it and sign it again?';

  @override
  String get page_home_update_os_fuchsia =>
      'A brand new mobile phone, right? Btw, I\'m wondering how you got this build...?';

  @override
  String get page_home_update_os_linux =>
      'You built this application by yourself? Awesome, but the bad news is that you have to build it yourself again...';

  @override
  String get page_home_update_os_macos =>
      'You built this application by yourself? Awesome, but the bad news is that you have to build it yourself again...';

  @override
  String get page_home_update_os_windows =>
      'Guess what, automatically update is not supported on Windows platform, but upgrading is simple...';

  @override
  String get page_home_update_link_jump => 'Go to GitHub repository';

  @override
  String get page_home_update_link => 'https://github.com/nofyso/corrupt';

  @override
  String get page_home_update_release_empty => 'No release assets... What?';

  @override
  String get page_home_update_jump => 'Open link...';

  @override
  String get page_home_update_best_match =>
      'Recommend for your current platform!';

  @override
  String get page_home_update_download => 'Download';

  @override
  String get page_home_update_download_expand =>
      'Show other builds (not compatible)';

  @override
  String get page_home_update_download_expand_warning =>
      'These builds may not compatible with your current environment';

  @override
  String get page_home_update_complete => 'Package downloaded';

  @override
  String get page_home_update_install => 'Install now';

  @override
  String get page_home_update_platform_not_match_title => 'Wait a moment...!';

  @override
  String get page_home_update_platform_not_match_content =>
      'This package may not be compatible with current environment! We strongly recommend downloading the package that matches your current platform (usually the first one). Would you still want to download it??';

  @override
  String get page_classes_error_not_logged_title =>
      'Here\'s nothing but the void';

  @override
  String get page_classes_error_not_logged_content => 'You\'re not logged';

  @override
  String get page_classes_error_wrong_data_title => 'Something went wrong...?';

  @override
  String get page_classes_error_wrong_data_content_term =>
      'Sorry, corrupt couldn\'t fetch the term date data, please contact to the nofyso';

  @override
  String get page_classes_error_main_empty_title =>
      'Here\'s nothing but the void? Maybe not';

  @override
  String get page_classes_error_main_empty_subtitle =>
      'Changing data source may help...?';

  @override
  String get page_classes_error_main_empty_button => 'Fix and refresh';

  @override
  String get page_classes_error_main_empty_button_hint =>
      'By clicking this button, corrupt will change the data source to \'current date\', then trigger refresh';

  @override
  String get page_classes_error_main_empty_with_pref_title =>
      'Here\'s nothing but the void, oh no...';

  @override
  String get page_classes_error_main_empty_with_pref_subtitle =>
      'Maybe classes are not arranged yet, or there\'re some bug with corrupt, try refresh anyway?';

  @override
  String get page_classes_error_main_empty_with_pref_button => 'Refresh';

  @override
  String get page_classes_error_empty_title => 'Here\'s nothing but the void';

  @override
  String get page_classes_error_empty_subtitle =>
      'Chose a wrong date, or just not arranged yet?';

  @override
  String get page_classes_week => 'Week';

  @override
  String get page_exams_undeclared => 'Undeclared';

  @override
  String get page_exams_empty_title => 'Here\'s nothing but the void';

  @override
  String get page_exams_empty_subtitle => 'Work hard anyway, please';

  @override
  String get widget_load_not_fully_loaded =>
      'Some of data have not loaded yet, try to refresh';

  @override
  String widget_load_waiting_entry(Object left) {
    return 'Waiting for data ($left left)';
  }

  @override
  String get widget_error_network_title => 'Network error';

  @override
  String get widget_error_network_subtitle =>
      'Considering change your network environment?';

  @override
  String get widget_error_login_title => 'Login error';

  @override
  String get widget_error_login_subtitle =>
      'Are you changed your password? Re-login if necessary, please';

  @override
  String get widget_error_loopback_title => 'Login looped back';

  @override
  String get widget_error_loopback_subtitle => 'Oh no... try again?';

  @override
  String get widget_error_captcha_title => 'Captcha error';

  @override
  String get widget_error_captcha_subtitle => 'What a bad tensor... try again?';

  @override
  String get widget_error_unknown => 'Unknown error';

  @override
  String get widget_error_unimplemented_title =>
      'The feature is not implemented';

  @override
  String get widget_error_unimplemented_subtitle =>
      'Well, you just rua nofyso, then you\'ll get the implementation';

  @override
  String get widget_error_other => 'Other error';

  @override
  String get widget_error_retry => 'Retry';

  @override
  String get settings_group_customize => 'Customize';

  @override
  String get settings_customize_theme => 'Theme override';

  @override
  String get settings_customize_theme_1 => 'Follow system';

  @override
  String get settings_customize_theme_2 => 'Light';

  @override
  String get settings_customize_theme_3 => 'Dark';

  @override
  String get settings_customize_color => 'Color theme';

  @override
  String get settings_customize_color_1 => 'Corrupt default';

  @override
  String get settings_customize_color_2 => 'Dynamic theme (Android 12+)';

  @override
  String get settings_customize_color_3 =>
      'Extract from background (Experimental)';

  @override
  String get settings_customize_color_4 => 'Iota (Builtin)';

  @override
  String get settings_customize_color_5 => 'Miku (Builtin)';

  @override
  String get settings_customize_background_switch => 'Enable background';

  @override
  String get settings_customize_background_select => 'Select background image';

  @override
  String get settings_customize_background_alpha => 'Background alpha';

  @override
  String get settings_customize_appbar_alpha => 'Appbar alpha';

  @override
  String get settings_customize_navigation_bar_alpha => 'Navigation bar alpha';

  @override
  String get settings_customize_legacy_color_switch => 'Enable legacy color';

  @override
  String get settings_customize_legacy_color_switch_subtitle =>
      'Use legacy color scheme';

  @override
  String get settings_group_home => 'Home';

  @override
  String get settings_home_classes_card_style => 'Classes card style';

  @override
  String get settings_home_classes_card_style_1 =>
      'Linear indicator below the text';

  @override
  String get settings_home_classes_card_style_2 =>
      'Linear indicator above the text';

  @override
  String get settings_home_classes_card_style_3 =>
      'Circular indicator to the right of the text';

  @override
  String get settings_group_classes => 'Classes';

  @override
  String get settings_classes_time_inspector_switch => 'Enable time inspector';

  @override
  String get settings_classes_time_inspector_switch_subtitle =>
      'Highlight the current time on Classes page';

  @override
  String get settings_classes_time_inspector_alpha => 'Time inspector alpha';

  @override
  String get settings_classes_date_inspector_switch => 'Enable date inspector';

  @override
  String get settings_classes_date_inspector_switch_subtitle =>
      'Highlight the current day on Classes page';

  @override
  String get settings_classes_date_inspector_alpha => 'Day inspector alpha';

  @override
  String get settings_classes_data_source => 'Class data source';

  @override
  String get settings_classes_data_source_1 => 'Default page';

  @override
  String get settings_classes_data_source_2 => 'Current date (Experimental)';

  @override
  String get settings_group_software => 'Software';

  @override
  String get settings_software_refresh_frequency => 'Refresh frequency';

  @override
  String get settings_software_refresh_frequency_1 => 'Always';

  @override
  String get settings_software_refresh_frequency_2 => 'Every 5 minutes';

  @override
  String get settings_software_refresh_frequency_3 => 'Every 10 minutes';

  @override
  String get settings_software_refresh_frequency_4 => 'Every 30 minutes';

  @override
  String get settings_software_refresh_frequency_5 => 'Never (manual only)';

  @override
  String get settings_software_update_checking_switch =>
      'Enable update checking';

  @override
  String get settings_software_update_checking_switch_subtitle =>
      'Check update on refreshing';

  @override
  String get settings_software_language => 'Language';

  @override
  String get settings_software_language_1 => 'Follow system';

  @override
  String get settings_software_language_2 => 'English';

  @override
  String get error_network_normal =>
      'Network error, please check your network connection';

  @override
  String error_network_bad_request(Object code, Object message) {
    return 'Oops, the legacy server we connect to is acting up again, or your network is interfering. Try to toggle your network and retry? ($code: $message)';
  }

  @override
  String get error_data_incorrect_id => 'Incorrect user name';

  @override
  String get error_data_empty_id => 'Empty user name';

  @override
  String get error_data_incorrect_password => 'Incorrect password';

  @override
  String error_data_incorrect_password_with_time(Object times) {
    return 'Incorrect password, $times trial(s) left';
  }

  @override
  String get error_data_empty_password => 'Empty password';

  @override
  String get error_data_incorrect_id_or_password =>
      'Incorrect username or password';

  @override
  String get error_data_empty_id_or_password => 'Empty username or password';

  @override
  String error_data_bad_data(Object response) {
    return 'Server: $response';
  }

  @override
  String get error_captcha => 'Too many failure of captcha detection';

  @override
  String error_unknown(Object detail) {
    return 'Unknown exception: $detail';
  }

  @override
  String get common_next => 'Next';

  @override
  String get common_mon => 'Mon';

  @override
  String get common_tue => 'Tue';

  @override
  String get common_wed => 'Wed';

  @override
  String get common_thu => 'Thu';

  @override
  String get common_fri => 'Fri';

  @override
  String get common_sat => 'Sat';

  @override
  String get common_sun => 'Sun';
}
