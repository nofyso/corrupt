import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @school_fafu.
  ///
  /// In en, this message translates to:
  /// **'Fujian Agricultural and Forestry University'**
  String get school_fafu;

  /// No description provided for @school_mju.
  ///
  /// In en, this message translates to:
  /// **'Minjiang University'**
  String get school_mju;

  /// No description provided for @screen_main_tab_home.
  ///
  /// In en, this message translates to:
  /// **'Corrupt'**
  String get screen_main_tab_home;

  /// No description provided for @screen_main_tab_classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get screen_main_tab_classes;

  /// No description provided for @screen_main_tab_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get screen_main_tab_settings;

  /// No description provided for @screen_main_refresh_classes.
  ///
  /// In en, this message translates to:
  /// **'Updating classes'**
  String get screen_main_refresh_classes;

  /// No description provided for @screen_main_refresh_exams.
  ///
  /// In en, this message translates to:
  /// **'Updating exams'**
  String get screen_main_refresh_exams;

  /// No description provided for @screen_main_refresh_terms.
  ///
  /// In en, this message translates to:
  /// **'Updating terms'**
  String get screen_main_refresh_terms;

  /// No description provided for @screen_main_refresh_class_time.
  ///
  /// In en, this message translates to:
  /// **'Updating class time'**
  String get screen_main_refresh_class_time;

  /// No description provided for @screen_main_refresh_gate.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get screen_main_refresh_gate;

  /// No description provided for @screen_main_refresh_update_check.
  ///
  /// In en, this message translates to:
  /// **'Checking update'**
  String get screen_main_refresh_update_check;

  /// No description provided for @screen_main_refresh_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get screen_main_refresh_error;

  /// No description provided for @screen_main_refresh_waiting.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get screen_main_refresh_waiting;

  /// No description provided for @screen_main_tooltip_not_logged.
  ///
  /// In en, this message translates to:
  /// **'Not logged in, all you can see are caches...'**
  String get screen_main_tooltip_not_logged;

  /// No description provided for @screen_login_page1_title.
  ///
  /// In en, this message translates to:
  /// **'Select your school'**
  String get screen_login_page1_title;

  /// No description provided for @screen_login_page1_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you now?'**
  String get screen_login_page1_subtitle;

  /// No description provided for @screen_login_page2_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get screen_login_page2_title;

  /// No description provided for @screen_login_page2_subtitle_fafu.
  ///
  /// In en, this message translates to:
  /// **'Log in the Educational Administration Management System of Fujian Agricultural and Forestry University via corrupt as a student.'**
  String get screen_login_page2_subtitle_fafu;

  /// No description provided for @screen_login_page2_back.
  ///
  /// In en, this message translates to:
  /// **'Back to schools...'**
  String get screen_login_page2_back;

  /// No description provided for @screen_login_page2_studentId.
  ///
  /// In en, this message translates to:
  /// **'StudentID'**
  String get screen_login_page2_studentId;

  /// No description provided for @screen_login_page2_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get screen_login_page2_password;

  /// No description provided for @screen_login_page2_login.
  ///
  /// In en, this message translates to:
  /// **'corrupt'**
  String get screen_login_page2_login;

  /// No description provided for @screen_login_page2_hint.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get screen_login_page2_hint;

  /// No description provided for @page_home_greeting_deep_night_title.
  ///
  /// In en, this message translates to:
  /// **'What..?'**
  String get page_home_greeting_deep_night_title;

  /// No description provided for @page_home_greeting_deep_night_content.
  ///
  /// In en, this message translates to:
  /// **'Don\'t kidding me, it does bad to your health...'**
  String get page_home_greeting_deep_night_content;

  /// No description provided for @page_home_greeting_early_morning_title.
  ///
  /// In en, this message translates to:
  /// **'Good morning..?'**
  String get page_home_greeting_early_morning_title;

  /// No description provided for @page_home_greeting_early_morning_content.
  ///
  /// In en, this message translates to:
  /// **'It\'s too early now... But do not tell me that you didn\'t sleep last night...'**
  String get page_home_greeting_early_morning_content;

  /// No description provided for @page_home_greeting_morning_title.
  ///
  /// In en, this message translates to:
  /// **'Good morning!'**
  String get page_home_greeting_morning_title;

  /// No description provided for @page_home_greeting_morning_content.
  ///
  /// In en, this message translates to:
  /// **'Did you have your breakfast? Have a nice day!'**
  String get page_home_greeting_morning_content;

  /// No description provided for @page_home_greeting_morning_class_title.
  ///
  /// In en, this message translates to:
  /// **'A brand new day!'**
  String get page_home_greeting_morning_class_title;

  /// No description provided for @page_home_greeting_morning_class_content.
  ///
  /// In en, this message translates to:
  /// **'Working? Studying? Or just playing? Hope everything is fine!'**
  String get page_home_greeting_morning_class_content;

  /// No description provided for @page_home_greeting_lunch_title.
  ///
  /// In en, this message translates to:
  /// **'Feel hungry?'**
  String get page_home_greeting_lunch_title;

  /// No description provided for @page_home_greeting_lunch_content.
  ///
  /// In en, this message translates to:
  /// **'Yes, nothing is more important than having a lunch now!'**
  String get page_home_greeting_lunch_content;

  /// No description provided for @page_home_greeting_after_lunch_title.
  ///
  /// In en, this message translates to:
  /// **'Golden leisure time!'**
  String get page_home_greeting_after_lunch_title;

  /// No description provided for @page_home_greeting_after_lunch_content.
  ///
  /// In en, this message translates to:
  /// **'Time after lunch, the best time to have a rest!'**
  String get page_home_greeting_after_lunch_content;

  /// No description provided for @page_home_greeting_afternoon_title.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon!'**
  String get page_home_greeting_afternoon_title;

  /// No description provided for @page_home_greeting_afternoon_content.
  ///
  /// In en, this message translates to:
  /// **'Keep your determination!'**
  String get page_home_greeting_afternoon_content;

  /// No description provided for @page_home_greeting_evening_title.
  ///
  /// In en, this message translates to:
  /// **'Did you noticed...'**
  String get page_home_greeting_evening_title;

  /// No description provided for @page_home_greeting_evening_content.
  ///
  /// In en, this message translates to:
  /// **'Twilight is the most romantic time, nofyso said...'**
  String get page_home_greeting_evening_content;

  /// No description provided for @page_home_greeting_night_title.
  ///
  /// In en, this message translates to:
  /// **'Free time!'**
  String get page_home_greeting_night_title;

  /// No description provided for @page_home_greeting_night_content.
  ///
  /// In en, this message translates to:
  /// **'Maybe you have some other activities?'**
  String get page_home_greeting_night_content;

  /// No description provided for @page_home_greeting_sleeping_title.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to...'**
  String get page_home_greeting_sleeping_title;

  /// No description provided for @page_home_greeting_sleeping_content.
  ///
  /// In en, this message translates to:
  /// **'go to the bed, exactly!'**
  String get page_home_greeting_sleeping_content;

  /// No description provided for @page_home_greeting_guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get page_home_greeting_guest;

  /// No description provided for @page_home_class_title.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get page_home_class_title;

  /// No description provided for @page_home_class_current_class.
  ///
  /// In en, this message translates to:
  /// **'Current class: {clazz}'**
  String page_home_class_current_class(Object clazz);

  /// No description provided for @page_home_class_next_class.
  ///
  /// In en, this message translates to:
  /// **'Next class: {clazz}'**
  String page_home_class_next_class(Object clazz);

  /// No description provided for @page_home_class_times_coming.
  ///
  /// In en, this message translates to:
  /// **'Start after: {time}'**
  String page_home_class_times_coming(Object time);

  /// No description provided for @page_home_class_times_left.
  ///
  /// In en, this message translates to:
  /// **'End after: {time}'**
  String page_home_class_times_left(Object time);

  /// No description provided for @page_home_class_all_finished.
  ///
  /// In en, this message translates to:
  /// **'All classes are finished today!'**
  String get page_home_class_all_finished;

  /// No description provided for @page_home_class_empty.
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get page_home_class_empty;

  /// No description provided for @page_home_class_error_wrong_data_title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong...?'**
  String get page_home_class_error_wrong_data_title;

  /// No description provided for @page_home_class_error_wrong_data_content_term.
  ///
  /// In en, this message translates to:
  /// **'Contact to nofyso then let it add term data'**
  String get page_home_class_error_wrong_data_content_term;

  /// No description provided for @page_home_exams_title.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get page_home_exams_title;

  /// No description provided for @page_home_exams_empty.
  ///
  /// In en, this message translates to:
  /// **'No exams upcoming'**
  String get page_home_exams_empty;

  /// No description provided for @page_home_exams_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get page_home_exams_upcoming;

  /// No description provided for @page_home_error_no_content_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void'**
  String get page_home_error_no_content_title;

  /// No description provided for @page_home_error_no_content_not_logged.
  ///
  /// In en, this message translates to:
  /// **'You\'re not logged in'**
  String get page_home_error_no_content_not_logged;

  /// No description provided for @page_home_error_no_content_empty.
  ///
  /// In en, this message translates to:
  /// **'Try refresh?'**
  String get page_home_error_no_content_empty;

  /// No description provided for @page_home_req_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get page_home_req_title;

  /// No description provided for @page_home_req_content.
  ///
  /// In en, this message translates to:
  /// **'Login to get access to more information~'**
  String get page_home_req_content;

  /// No description provided for @page_home_req_button.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get page_home_req_button;

  /// No description provided for @page_home_functions_title.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get page_home_functions_title;

  /// No description provided for @page_home_functions_classes.
  ///
  /// In en, this message translates to:
  /// **'Raw classes'**
  String get page_home_functions_classes;

  /// No description provided for @page_home_functions_exams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get page_home_functions_exams;

  /// No description provided for @page_home_functions_scores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get page_home_functions_scores;

  /// No description provided for @page_home_functions_fafu_lib.
  ///
  /// In en, this message translates to:
  /// **'Fafu Lib'**
  String get page_home_functions_fafu_lib;

  /// No description provided for @page_home_update_title.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get page_home_update_title;

  /// No description provided for @page_home_update_content.
  ///
  /// In en, this message translates to:
  /// **'A new update available'**
  String get page_home_update_content;

  /// No description provided for @page_home_update_os_android.
  ///
  /// In en, this message translates to:
  /// **'An Android phone? Great! Here\'s our brand new build for you.'**
  String get page_home_update_os_android;

  /// No description provided for @page_home_update_os_ios.
  ///
  /// In en, this message translates to:
  /// **'You maybe know I have no money to pay 99\$ per year... So could you please download it and sign it again?'**
  String get page_home_update_os_ios;

  /// No description provided for @page_home_update_os_fuchsia.
  ///
  /// In en, this message translates to:
  /// **'A brand new mobile phone, right? Btw, I\'m wondering how you got this build...?'**
  String get page_home_update_os_fuchsia;

  /// No description provided for @page_home_update_os_linux.
  ///
  /// In en, this message translates to:
  /// **'You built this application by yourself? Awesome, but the bad news is that you have to build it yourself again...'**
  String get page_home_update_os_linux;

  /// No description provided for @page_home_update_os_macos.
  ///
  /// In en, this message translates to:
  /// **'You built this application by yourself? Awesome, but the bad news is that you have to build it yourself again...'**
  String get page_home_update_os_macos;

  /// No description provided for @page_home_update_os_windows.
  ///
  /// In en, this message translates to:
  /// **'Guess what, automatically update is not supported on Windows platform, but upgrading is simple...'**
  String get page_home_update_os_windows;

  /// No description provided for @page_home_update_link_jump.
  ///
  /// In en, this message translates to:
  /// **'Go to GitHub repository'**
  String get page_home_update_link_jump;

  /// No description provided for @page_home_update_link.
  ///
  /// In en, this message translates to:
  /// **'https://github.com/nofyso/corrupt'**
  String get page_home_update_link;

  /// No description provided for @page_home_update_release_empty.
  ///
  /// In en, this message translates to:
  /// **'No release assets... What?'**
  String get page_home_update_release_empty;

  /// No description provided for @page_home_update_jump.
  ///
  /// In en, this message translates to:
  /// **'Open link...'**
  String get page_home_update_jump;

  /// No description provided for @page_home_update_best_match.
  ///
  /// In en, this message translates to:
  /// **'Recommend for your current platform!'**
  String get page_home_update_best_match;

  /// No description provided for @page_home_update_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get page_home_update_download;

  /// No description provided for @page_home_update_download_expand.
  ///
  /// In en, this message translates to:
  /// **'Show other builds (not compatible)'**
  String get page_home_update_download_expand;

  /// No description provided for @page_home_update_download_expand_warning.
  ///
  /// In en, this message translates to:
  /// **'These builds may not compatible with your current environment'**
  String get page_home_update_download_expand_warning;

  /// No description provided for @page_home_update_complete.
  ///
  /// In en, this message translates to:
  /// **'Package downloaded'**
  String get page_home_update_complete;

  /// No description provided for @page_home_update_install.
  ///
  /// In en, this message translates to:
  /// **'Install now'**
  String get page_home_update_install;

  /// No description provided for @page_home_update_platform_not_match_title.
  ///
  /// In en, this message translates to:
  /// **'Wait a moment...!'**
  String get page_home_update_platform_not_match_title;

  /// No description provided for @page_home_update_platform_not_match_content.
  ///
  /// In en, this message translates to:
  /// **'This package may not be compatible with current environment! We strongly recommend downloading the package that matches your current platform (usually the first one). Would you still want to download it??'**
  String get page_home_update_platform_not_match_content;

  /// No description provided for @page_classes_error_not_logged_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void'**
  String get page_classes_error_not_logged_title;

  /// No description provided for @page_classes_error_not_logged_content.
  ///
  /// In en, this message translates to:
  /// **'You\'re not logged'**
  String get page_classes_error_not_logged_content;

  /// No description provided for @page_classes_error_wrong_data_title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong...?'**
  String get page_classes_error_wrong_data_title;

  /// No description provided for @page_classes_error_wrong_data_content_term.
  ///
  /// In en, this message translates to:
  /// **'Sorry, corrupt couldn\'t fetch the term date data, please contact to the nofyso'**
  String get page_classes_error_wrong_data_content_term;

  /// No description provided for @page_classes_error_main_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void? Maybe not'**
  String get page_classes_error_main_empty_title;

  /// No description provided for @page_classes_error_main_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Changing data source may help...?'**
  String get page_classes_error_main_empty_subtitle;

  /// No description provided for @page_classes_error_main_empty_button.
  ///
  /// In en, this message translates to:
  /// **'Fix and refresh'**
  String get page_classes_error_main_empty_button;

  /// No description provided for @page_classes_error_main_empty_button_hint.
  ///
  /// In en, this message translates to:
  /// **'By clicking this button, corrupt will change the data source to \'current date\', then trigger refresh'**
  String get page_classes_error_main_empty_button_hint;

  /// No description provided for @page_classes_error_main_empty_with_pref_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void, oh no...'**
  String get page_classes_error_main_empty_with_pref_title;

  /// No description provided for @page_classes_error_main_empty_with_pref_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Maybe classes are not arranged yet, or there\'re some bug with corrupt, try refresh anyway?'**
  String get page_classes_error_main_empty_with_pref_subtitle;

  /// No description provided for @page_classes_error_main_empty_with_pref_button.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get page_classes_error_main_empty_with_pref_button;

  /// No description provided for @page_classes_error_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void'**
  String get page_classes_error_empty_title;

  /// No description provided for @page_classes_error_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chose a wrong date, or just not arranged yet?'**
  String get page_classes_error_empty_subtitle;

  /// No description provided for @page_classes_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get page_classes_week;

  /// No description provided for @page_exams_undeclared.
  ///
  /// In en, this message translates to:
  /// **'Undeclared'**
  String get page_exams_undeclared;

  /// No description provided for @page_exams_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Here\'s nothing but the void'**
  String get page_exams_empty_title;

  /// No description provided for @page_exams_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Work hard anyway, please'**
  String get page_exams_empty_subtitle;

  /// No description provided for @page_scores_card_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get page_scores_card_time;

  /// No description provided for @page_scores_card_place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get page_scores_card_place;

  /// No description provided for @page_scores_card_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get page_scores_card_category;

  /// No description provided for @page_scores_card_credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get page_scores_card_credit;

  /// No description provided for @page_scores_card_gp.
  ///
  /// In en, this message translates to:
  /// **'Grade point'**
  String get page_scores_card_gp;

  /// No description provided for @page_scores_card_note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get page_scores_card_note;

  /// No description provided for @page_scores_card_code.
  ///
  /// In en, this message translates to:
  /// **'Class code'**
  String get page_scores_card_code;

  /// No description provided for @page_scores_card_score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get page_scores_card_score;

  /// No description provided for @page_scores_card_elective.
  ///
  /// In en, this message translates to:
  /// **'[Elective]'**
  String get page_scores_card_elective;

  /// No description provided for @widget_load_not_fully_loaded.
  ///
  /// In en, this message translates to:
  /// **'Some of data have not loaded yet, try to refresh'**
  String get widget_load_not_fully_loaded;

  /// No description provided for @widget_load_waiting_entry.
  ///
  /// In en, this message translates to:
  /// **'Waiting for data ({left} left)'**
  String widget_load_waiting_entry(Object left);

  /// No description provided for @widget_error_network_title.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get widget_error_network_title;

  /// No description provided for @widget_error_network_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Considering change your network environment?'**
  String get widget_error_network_subtitle;

  /// No description provided for @widget_error_network_bad_response_title.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get widget_error_network_bad_response_title;

  /// No description provided for @widget_error_network_bad_response_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The server returned a bad response...\nLogs may help'**
  String get widget_error_network_bad_response_subtitle;

  /// No description provided for @widget_error_login_title.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get widget_error_login_title;

  /// No description provided for @widget_error_login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Were you changed your password? Re-login if necessary, please'**
  String get widget_error_login_subtitle;

  /// No description provided for @widget_error_loopback_title.
  ///
  /// In en, this message translates to:
  /// **'Login looped back'**
  String get widget_error_loopback_title;

  /// No description provided for @widget_error_loopback_subtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'ve tried many times for you... but you can also try it again?'**
  String get widget_error_loopback_subtitle;

  /// No description provided for @widget_error_captcha_title.
  ///
  /// In en, this message translates to:
  /// **'Captcha error'**
  String get widget_error_captcha_title;

  /// No description provided for @widget_error_captcha_subtitle.
  ///
  /// In en, this message translates to:
  /// **'What a bad tensor... try again?'**
  String get widget_error_captcha_subtitle;

  /// No description provided for @widget_error_unimplemented_title.
  ///
  /// In en, this message translates to:
  /// **'The feature is not implemented'**
  String get widget_error_unimplemented_title;

  /// No description provided for @widget_error_unimplemented_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Well, you just rua nofyso, then you\'ll get the implementation'**
  String get widget_error_unimplemented_subtitle;

  /// No description provided for @widget_error_other_title.
  ///
  /// In en, this message translates to:
  /// **'Other error'**
  String get widget_error_other_title;

  /// No description provided for @widget_error_other_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Oh no... An unarchived failure...\nFor more information, view logs'**
  String get widget_error_other_subtitle;

  /// No description provided for @widget_error_other_fafu_teaching_title.
  ///
  /// In en, this message translates to:
  /// **'Teaching evaluation is not completed'**
  String get widget_error_other_fafu_teaching_title;

  /// No description provided for @widget_error_other_fafu_teaching_subtitle.
  ///
  /// In en, this message translates to:
  /// **'I knew it makes no sense to block students from accessing anything before they complete that...'**
  String get widget_error_other_fafu_teaching_subtitle;

  /// No description provided for @widget_error_other_fafu_analyzing_title.
  ///
  /// In en, this message translates to:
  /// **'Analyzing failed'**
  String get widget_error_other_fafu_analyzing_title;

  /// No description provided for @widget_error_other_fafu_analyzing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s a bad software... Please, I need your logs...'**
  String get widget_error_other_fafu_analyzing_subtitle;

  /// No description provided for @widget_error_multi_title.
  ///
  /// In en, this message translates to:
  /// **'Sounds bad...'**
  String get widget_error_multi_title;

  /// No description provided for @widget_error_multi_subtitle.
  ///
  /// In en, this message translates to:
  /// **'More than one failures in processing...\nFor more information, view logs'**
  String get widget_error_multi_subtitle;

  /// No description provided for @widget_error_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy detail to clipboard'**
  String get widget_error_copy;

  /// No description provided for @widget_error_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get widget_error_retry;

  /// No description provided for @settings_group_customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get settings_group_customize;

  /// No description provided for @settings_customize_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme override'**
  String get settings_customize_theme;

  /// No description provided for @settings_customize_theme_1.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settings_customize_theme_1;

  /// No description provided for @settings_customize_theme_2.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_customize_theme_2;

  /// No description provided for @settings_customize_theme_3.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_customize_theme_3;

  /// No description provided for @settings_customize_color.
  ///
  /// In en, this message translates to:
  /// **'Color theme'**
  String get settings_customize_color;

  /// No description provided for @settings_customize_color_1.
  ///
  /// In en, this message translates to:
  /// **'Corrupt default'**
  String get settings_customize_color_1;

  /// No description provided for @settings_customize_color_2.
  ///
  /// In en, this message translates to:
  /// **'Dynamic theme (Android 12+)'**
  String get settings_customize_color_2;

  /// No description provided for @settings_customize_color_3.
  ///
  /// In en, this message translates to:
  /// **'Extract from background (Experimental)'**
  String get settings_customize_color_3;

  /// No description provided for @settings_customize_color_4.
  ///
  /// In en, this message translates to:
  /// **'Iota (Builtin)'**
  String get settings_customize_color_4;

  /// No description provided for @settings_customize_color_5.
  ///
  /// In en, this message translates to:
  /// **'Miku (Builtin)'**
  String get settings_customize_color_5;

  /// No description provided for @settings_customize_background_switch.
  ///
  /// In en, this message translates to:
  /// **'Enable background'**
  String get settings_customize_background_switch;

  /// No description provided for @settings_customize_background_select.
  ///
  /// In en, this message translates to:
  /// **'Select background image'**
  String get settings_customize_background_select;

  /// No description provided for @settings_customize_background_alpha.
  ///
  /// In en, this message translates to:
  /// **'Background alpha'**
  String get settings_customize_background_alpha;

  /// No description provided for @settings_customize_appbar_alpha.
  ///
  /// In en, this message translates to:
  /// **'Appbar alpha'**
  String get settings_customize_appbar_alpha;

  /// No description provided for @settings_customize_navigation_bar_alpha.
  ///
  /// In en, this message translates to:
  /// **'Navigation bar alpha'**
  String get settings_customize_navigation_bar_alpha;

  /// No description provided for @settings_customize_legacy_color_switch.
  ///
  /// In en, this message translates to:
  /// **'Enable legacy color'**
  String get settings_customize_legacy_color_switch;

  /// No description provided for @settings_customize_legacy_color_switch_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Use legacy color scheme'**
  String get settings_customize_legacy_color_switch_subtitle;

  /// No description provided for @settings_group_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get settings_group_home;

  /// No description provided for @settings_home_classes_card_style.
  ///
  /// In en, this message translates to:
  /// **'Classes card style'**
  String get settings_home_classes_card_style;

  /// No description provided for @settings_home_classes_card_style_1.
  ///
  /// In en, this message translates to:
  /// **'Linear indicator below the text'**
  String get settings_home_classes_card_style_1;

  /// No description provided for @settings_home_classes_card_style_2.
  ///
  /// In en, this message translates to:
  /// **'Linear indicator above the text'**
  String get settings_home_classes_card_style_2;

  /// No description provided for @settings_home_classes_card_style_3.
  ///
  /// In en, this message translates to:
  /// **'Circular indicator to the right of the text'**
  String get settings_home_classes_card_style_3;

  /// No description provided for @settings_group_classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get settings_group_classes;

  /// No description provided for @settings_classes_time_inspector_switch.
  ///
  /// In en, this message translates to:
  /// **'Enable time inspector'**
  String get settings_classes_time_inspector_switch;

  /// No description provided for @settings_classes_time_inspector_switch_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlight the current time on Classes page'**
  String get settings_classes_time_inspector_switch_subtitle;

  /// No description provided for @settings_classes_time_inspector_alpha.
  ///
  /// In en, this message translates to:
  /// **'Time inspector alpha'**
  String get settings_classes_time_inspector_alpha;

  /// No description provided for @settings_classes_date_inspector_switch.
  ///
  /// In en, this message translates to:
  /// **'Enable date inspector'**
  String get settings_classes_date_inspector_switch;

  /// No description provided for @settings_classes_date_inspector_switch_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlight the current day on Classes page'**
  String get settings_classes_date_inspector_switch_subtitle;

  /// No description provided for @settings_classes_date_inspector_alpha.
  ///
  /// In en, this message translates to:
  /// **'Day inspector alpha'**
  String get settings_classes_date_inspector_alpha;

  /// No description provided for @settings_classes_data_source.
  ///
  /// In en, this message translates to:
  /// **'Class data source'**
  String get settings_classes_data_source;

  /// No description provided for @settings_classes_data_source_1.
  ///
  /// In en, this message translates to:
  /// **'Default page'**
  String get settings_classes_data_source_1;

  /// No description provided for @settings_classes_data_source_2.
  ///
  /// In en, this message translates to:
  /// **'Current date (Experimental)'**
  String get settings_classes_data_source_2;

  /// No description provided for @settings_group_software.
  ///
  /// In en, this message translates to:
  /// **'Software'**
  String get settings_group_software;

  /// No description provided for @settings_software_refresh_frequency.
  ///
  /// In en, this message translates to:
  /// **'Refresh frequency'**
  String get settings_software_refresh_frequency;

  /// No description provided for @settings_software_refresh_frequency_1.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get settings_software_refresh_frequency_1;

  /// No description provided for @settings_software_refresh_frequency_2.
  ///
  /// In en, this message translates to:
  /// **'Every 5 minutes'**
  String get settings_software_refresh_frequency_2;

  /// No description provided for @settings_software_refresh_frequency_3.
  ///
  /// In en, this message translates to:
  /// **'Every 10 minutes'**
  String get settings_software_refresh_frequency_3;

  /// No description provided for @settings_software_refresh_frequency_4.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get settings_software_refresh_frequency_4;

  /// No description provided for @settings_software_refresh_frequency_5.
  ///
  /// In en, this message translates to:
  /// **'Never (manual only)'**
  String get settings_software_refresh_frequency_5;

  /// No description provided for @settings_software_update_checking_switch.
  ///
  /// In en, this message translates to:
  /// **'Enable update checking'**
  String get settings_software_update_checking_switch;

  /// No description provided for @settings_software_update_checking_switch_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Check update on refreshing'**
  String get settings_software_update_checking_switch_subtitle;

  /// No description provided for @settings_software_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_software_language;

  /// No description provided for @settings_software_language_1.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settings_software_language_1;

  /// No description provided for @settings_software_language_2.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_software_language_2;

  /// No description provided for @error_network_normal.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your network connection'**
  String get error_network_normal;

  /// No description provided for @error_network_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Oops, the legacy server we connect to is acting up again, or your network is interfering. Try to toggle your network and retry? ({code}: {message})'**
  String error_network_bad_request(Object code, Object message);

  /// No description provided for @error_data_incorrect_id.
  ///
  /// In en, this message translates to:
  /// **'Incorrect user name'**
  String get error_data_incorrect_id;

  /// No description provided for @error_data_empty_id.
  ///
  /// In en, this message translates to:
  /// **'Empty user name'**
  String get error_data_empty_id;

  /// No description provided for @error_data_incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get error_data_incorrect_password;

  /// No description provided for @error_data_incorrect_password_with_time.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password, {times} trial(s) left'**
  String error_data_incorrect_password_with_time(Object times);

  /// No description provided for @error_data_empty_password.
  ///
  /// In en, this message translates to:
  /// **'Empty password'**
  String get error_data_empty_password;

  /// No description provided for @error_data_incorrect_id_or_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get error_data_incorrect_id_or_password;

  /// No description provided for @error_data_empty_id_or_password.
  ///
  /// In en, this message translates to:
  /// **'Empty username or password'**
  String get error_data_empty_id_or_password;

  /// No description provided for @error_data_bad_data.
  ///
  /// In en, this message translates to:
  /// **'Server: {response}'**
  String error_data_bad_data(Object response);

  /// No description provided for @error_captcha.
  ///
  /// In en, this message translates to:
  /// **'Too many failure of captcha detection'**
  String get error_captcha;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown exception: {detail}'**
  String error_unknown(Object detail);

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get common_mon;

  /// No description provided for @common_tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get common_tue;

  /// No description provided for @common_wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get common_wed;

  /// No description provided for @common_thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get common_thu;

  /// No description provided for @common_fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get common_fri;

  /// No description provided for @common_sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get common_sat;

  /// No description provided for @common_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get common_sun;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
