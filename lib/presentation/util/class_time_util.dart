import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:dartlin/collections.dart';
import 'package:fpdart/fpdart.dart';

class ClassTimeUtil {
  static int getCurrentWeek(DateTime time, TermData currentTerm) {
    final difference = currentTerm.theFirstDay.difference(time);
    return (-difference.inDays / 7.0).floor().clamp(0, 19);
  }

  static TermData? selectCurrentTermData(DateTime time, List<TermData> termDataList) {
    final year = time.year;
    final month = time.month;
    final semester = DateTime.march.to(DateTime.september).contains(month) ? "2" : "1";
    final academicYear = semester == "1" ? "$year-${year + 1}" : "${year - 1}-$year";
    return termDataList
        .filter((it) => it.semester == semester && it.academicYear == academicYear)
        .firstOrNull();
  }
}
