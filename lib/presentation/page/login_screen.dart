import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:corrupt/features/channel/domain/use_case/school_login_usecase.dart';
import 'package:corrupt/features/pref/domain/abstract_repository/abstract_raw_local_data.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/features/refresh/provider/refresh_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/util/duration_consts.dart';
import 'package:corrupt/presentation/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

enum _TextControllerId {
  name,
  password;
}

final _textControllers = Provider.family<TextEditingController, _TextControllerId>((ref, field) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});
final _selectedSchool = StateProvider.autoDispose((_) => School.fafu);
final _pageIndex = StateProvider.autoDispose<int>((_) => 0);
final _isLogging = StateProvider.autoDispose((_) => false);
final _loggingErrorStatus = StateProvider.autoDispose((_) => null as String?);

class LoginController {
  final _schoolDataRepository = getIt<LocalRawDataRepository>();

  Future<Option<String>> login(WidgetRef ref, AppLocalizations i18n) async {
    ref.read(_isLogging.notifier).state = true;
    final loginUseCase = getIt<SchoolLoginUseCase>();
    final implType = ref.read(_selectedSchool);
    final studentId = ref.read(_textControllers(_TextControllerId.name)).text;
    final password = ref.read(_textControllers(_TextControllerId.password)).text;
    var credits = 5;
    while (credits >= 0) {
      final loginResult = await loginUseCase.firstLogin(implType, (studentId, password));
      switch (loginResult) {
        case Right<login_failure.SchoolLoginFailure, dynamic>():
          await _schoolDataRepository.setData(LocalDataKey.logged, true);
          return Option.none();
        case Left<login_failure.SchoolLoginFailure, dynamic>(value: final error):
          switch (error) {
            case login_failure.NetworkFailure(badResponse: final badResponse):
              if (badResponse == null) {
                return Option.of(i18n.error_network_normal);
              }
              return Option.of(
                i18n.error_network_bad_request(
                  "${badResponse.statusCode ?? "unknown"}",
                  badResponse.statusMessage ?? "unknown",
                ),
              );
            case login_failure.BadDataFailure(
              dataType: final dataType,
              isEmpty: final isEmpty,
              extra: final extra,
            ):
              switch (dataType) {
                case login_failure.BadDataType.username:
                  return Option.of(
                    isEmpty ? i18n.error_data_empty_id : i18n.error_data_incorrect_id,
                  );
                case login_failure.BadDataType.password:
                  return Option.of(
                    isEmpty
                        ? i18n.error_data_empty_password
                        : (extra != null
                              ? i18n.error_data_incorrect_password_with_time(extra)
                              : i18n.error_data_incorrect_password),
                  );
                case login_failure.BadDataType.other:
                  return Option.of(i18n.error_data_bad_data(extra ?? "[empty]"));
                case login_failure.BadDataType.both:
                  return Option.of(
                    isEmpty
                        ? i18n.error_data_empty_id_or_password
                        : i18n.error_data_incorrect_id_or_password,
                  );
              }
            case login_failure.CaptchaFailure():
              {}
            case login_failure.OtherFailure(exception: final exception):
              return Option.of(i18n.error_unknown(exception.toString()));
          }
      }
      credits--;
    }
    return Option.of(i18n.error_captcha);
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _loginController = getIt.get<LoginController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(_pageIndex);
    final isLogging = ref.watch(_isLogging);
    if (_tabController.index != currentTab) {
      _tabController.animateTo(currentTab);
    }
    return PopScope(
      canPop: !isLogging,
      child: Scaffold(
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [_schoolSelectPage(context, ref), _schoolLoginPage(context, ref)],
            ),
            if (PlatformUtils.isDesktop)
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                padding: EdgeInsetsGeometry.all(16.0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _schoolSelectPage(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final i18n = AppLocalizations.of(context)!;
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            key: ValueKey(0),
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n.screen_login_page1_title, style: textTheme.titleLarge),
              Text(i18n.screen_login_page1_subtitle),
              SizedBox(height: 8.0),
              RadioGroup<School>(
                groupValue: ref.watch(_selectedSchool),
                onChanged: (final school) {
                  ref.read(_selectedSchool.notifier).state = school ?? School.fafu;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _schoolSelectItem(i18n.school_fafu, School.fafu, ref),
                    _schoolSelectItem(i18n.school_mju, School.mju, ref),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  ref.read(_pageIndex.notifier).state = 1;
                },
                child: Text(i18n.common_next),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _schoolLoginPage(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final i18n = AppLocalizations.of(context)!;
    final isLogging = ref.watch(_isLogging);
    final loginError = ref.watch(_loggingErrorStatus);
    return Center(
      child: Padding(
        padding: EdgeInsetsGeometry.all(32.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AnimatedSize(
                duration: MaterialDurations.short,
                curve: Curves.easeInOutQuad,
                child: isLogging ? LinearProgressIndicator() : SizedBox.shrink(),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: isLogging
                          ? null
                          : () {
                              ref.read(_pageIndex.notifier).state = 0;
                            },
                      child: AnimatedSize(
                        duration: MaterialDurations.short,
                        curve: Curves.easeInOutQuad,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isLogging) Icon(Icons.arrow_back),
                            if (!isLogging)
                              Text(
                                i18n.screen_login_page2_back,
                                style: textTheme.labelLarge?.copyWith(
                                  color: isLogging
                                      ? colorScheme.primaryFixedDim
                                      : colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      key: ValueKey(1),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 8.0),
                        Text(i18n.screen_login_page2_title, style: textTheme.titleLarge),
                        Text(i18n.screen_login_page2_subtitle_fafu),
                        Padding(
                          padding: EdgeInsetsGeometry.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                enabled: !isLogging,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  label: Text(i18n.screen_login_page2_studentId),
                                ),
                                controller: ref.read(_textControllers(_TextControllerId.name)),
                              ),
                              TextField(
                                enabled: !isLogging,
                                enableSuggestions: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  label: Text(i18n.screen_login_page2_password),
                                ),
                                controller: ref.read(_textControllers(_TextControllerId.password)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.all(8.0),
                          child: AnimatedSize(
                            duration: MaterialDurations.short,
                            curve: Curves.easeInOutQuad,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isLogging)
                                  FilledButton(
                                    onPressed: () async {
                                      ref.read(_loggingErrorStatus.notifier).state = null;
                                      final result = await _loginController.login(ref, i18n);
                                      result.match(() {}, (some) {
                                        ref.read(_loggingErrorStatus.notifier).state = some;
                                      });
                                      ref.read(_isLogging.notifier).state = false;
                                      if (result.isNone() && context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      ref.invalidate(refreshNotifierProvider);
                                      ref.invalidate(prefProvider);
                                      //FIXME automatically invalidate
                                    },
                                    child: Text(i18n.screen_login_page2_login),
                                  ),
                                if (isLogging) Text(i18n.screen_login_page2_hint),
                                if (loginError != null) Text(loginError),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _schoolSelectItem(String text, School school, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(_selectedSchool.notifier).state = school;
      },
      child: Padding(
        padding: EdgeInsetsGeometry.directional(end: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<School>(value: school),
            Text(text),
          ],
        ),
      ),
    );
  }
}
