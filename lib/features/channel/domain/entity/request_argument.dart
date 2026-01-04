import 'package:corrupt/features/pref/domain/entity/settings_key.dart';

class TermBasedFetchArgument {
  final String academicYear;
  final String semester;

  TermBasedFetchArgument(this.academicYear, this.semester);
}

class ClassesFetchArgument {
  final TermBasedFetchArgument? termArg;
  final ClassesDataSource dataSource;

  ClassesFetchArgument(this.termArg, this.dataSource);
}

enum ClassesDataSource {
  default_,
  currentDate;

  static ClassesDataSource fromRawValue(String settingValue) =>
      switch (settingValue) {
        SettingKeysGen.classDataSourceValue1 => currentDate,
        _ => default_,
      };
}
