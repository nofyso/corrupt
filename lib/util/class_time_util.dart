import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:fpdart/fpdart.dart';

class ClassTimeUtil {
  static int getCurrentWeek(DateTime time, TermData currentTerm) {
    final difference = currentTerm.theFirstDay.difference(time);
    return (-difference.inDays / 7.0).floor().clamp(0, 19);
  }

  static Option<TermData> selectCurrentTermData(
    DateTime time,
    List<TermData> termDataList,
  ) {
    final year = time.year;
    final month = time.month;
    final (semester, academicYear) = switch (month) {
      final x when DateTime.january <= x && x < DateTime.march => (
        "1",
        "${year - 1}-$year",
      ),
      final x when DateTime.march <= x && x < DateTime.september => (
        "2",
        "${year - 1}-$year",
      ),
      final x when DateTime.september <= x && x <= DateTime.december => (
        "1",
        "$year-${year + 1}",
      ),
      _ => throw AssertionError(""),
    };
    return termDataList
        .filter(
          (it) => it.semester == semester && it.academicYear == academicYear,
        )
        .firstOption;
  }
}
