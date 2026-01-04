import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart'
    as data_fetch_failure;
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:corrupt/util/regex_helper.dart';
import 'package:dartlin/dartlin.dart';
import 'package:fpdart/fpdart.dart';

class FafuAnalyzer {
  static Either<
    data_fetch_failure.SchoolDataFetchFailure,
    (AvailableTermTime, ClassTable)
  >
  analyzeClassTable(String htmlString) => Either.Do(($) {
    final document = BeautifulSoup(htmlString.replaceAll("&nbsp;", ""));
    final (year, semester) = $(
      _getSelectedTime(document).toEither(
        () => data_fetch_failure.OtherFailure.fromPresets(
          data_fetch_failure.Preset.fafuAnalyzing,
          "error in analyzing class table (year or semester not found)",
        ),
      ),
    );
    final table = $(
      Option.fromNullable(document.find("*", id: "Table1")).toEither(
        () => data_fetch_failure.OtherFailure.fromPresets(
          data_fetch_failure.Preset.fafuAnalyzing,
          "error in analyzing class table (table element not found)",
        ),
      ),
    );
    final headRegex = "(?<=<td.*>)[\\S\\s\\r\\n]*?(?=</td>)".asRegExp;
    final rootNode = $(
      Option.fromNullable(table.children.getOrNull(0)).toEither(
        () => data_fetch_failure.OtherFailure.fromPresets(
          data_fetch_failure.Preset.fafuAnalyzing,
          "error in analyzing class table (root node not found",
        ),
      ),
    );
    final result = <ClassEntity>[];
    final tableInTimes = rootNode.children.drop(2).toList();
    var rowSpans = [0, 0, 0, 0, 0, 0, 0];
    for (int rowI = 0; rowI < tableInTimes.length; rowI++) {
      final row = tableInTimes[rowI].children;
      final time = rowI;
      var oldRowSpans = rowSpans.toList();
      for (int colI = 0, fakeDow = -1; colI < row.length; colI++, fakeDow++) {
        final entry = row[colI];
        if (colI == 0) {
          if (entry.attributes["rowspan"] != null) colI++;
          continue;
        }
        if (entry.text.isEmpty) continue;
        final rowSpan = entry.attributes["rowspan"].let(
          (it) =>
              it == null ? 1 : it.toIntOption.match(() => 1, (some) => some),
        );
        final trueDow = rowSpans
            .mapIndexed((i, it) => (i, it))
            .filter((it) => it.$2 <= 0)
            .toList()[fakeDow]
            .$1;
        final classBlockBody = $(
          entry
              .prettify()
              .replaceAll("\t", "")
              .replaceAll("\n", "")
              .matchFirst(headRegex)
              .toEither(
                () => data_fetch_failure.OtherFailure.fromPresets(
                  data_fetch_failure.Preset.fafuAnalyzing,
                  "error in analyzing class table (class block resolve failed)",
                ),
              ),
        );
        final classes = classBlockBody
            .split("(<br><br>)(?!(<br>))".asRegExp)
            .filter((it) => !it.startsWith("<font"));
        result.addAll(
          classes.map(
            (it) => $(
              _generateClassEntity((time, rowSpan, trueDow, it.split("<br>"))),
            ),
          ),
        );
        oldRowSpans[trueDow] = rowSpan;
      }
      rowSpans = oldRowSpans.map((it) => it <= 0 ? it : it - 1).toList();
    }
    return (
      $(
        _getAvailableTime(document).toEither(
          () => data_fetch_failure.OtherFailure.fromPresets(
            data_fetch_failure.Preset.fafuAnalyzing,
            "error in analyzing class table (available time not found)",
          ),
        ),
      ),
      ClassTable(year, semester, result),
    );
  });

  static Option<(String, String)> getSelectedTime(
    String htmlString, {
    String academicYearId = "xnd",
    String semesterId = "xqd",
  }) {
    final document = BeautifulSoup(htmlString.replaceAll("&nbsp;", ""));
    return _getSelectedTime(
      document,
      academicYearId: academicYearId,
      semesterId: semesterId,
    );
  }

  static Option<(String, String)> _getSelectedTime(
    BeautifulSoup document, {
    String academicYearId = "xnd",
    String semesterId = "xqd",
  }) {
    final year = document
        .find("*", id: academicYearId)
        ?.children
        .filter((it) => it.attributes["selected"] == "selected")
        .firstOrNull()
        ?.text;
    final semester = document
        .find("*", id: semesterId)
        ?.children
        .filter((it) => it.attributes["selected"] == "selected")
        .firstOrNull()
        ?.text;
    return year == null || semester == null
        ? Option.none()
        : Option.of((year, semester));
  }

  static Option<(DateTime, DateTime)> convertDateTime(String dateString) {
    return Option.Do(($) {
      final fromTimeRegex = "(?<=\\().*?(?=-)".asRegExp;
      final toTimeRegex = "(?<=-).*?(?=\\))".asRegExp;
      final yearRegex = "....(?=年)".asRegExp;
      final monthRegex = "..(?=月)".asRegExp;
      final dayRegex = "..(?=日)".asRegExp;
      Option<(int, int)> timeResolver(String timeString) {
        final hourAndMin = timeString.split(":");
        if (hourAndMin.length != 2) return Option.none();
        final hour = $(hourAndMin[0].toIntOption);
        final min = $(hourAndMin[1].toIntOption);
        return Option.of((hour, min));
      }

      final (fromHour, fromMin) = $(
        dateString.matchFirst(fromTimeRegex).flatMap(timeResolver),
      );
      final (toHour, toMin) = $(
        dateString.matchFirst(toTimeRegex).flatMap(timeResolver),
      );
      final year = $(
        dateString.matchFirst(yearRegex).flatMap((it) => it.toIntOption),
      );
      final month = $(
        dateString.matchFirst(monthRegex).flatMap((it) => it.toIntOption),
      );
      final day = $(
        dateString.matchFirst(dayRegex).flatMap((it) => it.toIntOption),
      );
      return (
        DateTime(year, month, day, fromHour, fromMin),
        DateTime(year, month, day, toHour, toMin),
      );
    });
  }

  static Either<
    data_fetch_failure.OtherFailure,
    (AvailableTermTime, ExamsEntity)
  >
  analyzeExams(String htmlString) {
    return Either.Do(($) {
      final document = BeautifulSoup(htmlString.replaceAll("&nbsp;", ""));
      final table = $(
        Option.fromNullable(document.find("*", id: "DataGrid1")).toEither(
          () => data_fetch_failure.OtherFailure.fromPresets(
            data_fetch_failure.Preset.fafuAnalyzing,
            "error in analyzing exams (table element not found)",
          ),
        ),
      );
      final (academicYear, semester) = $(
        _getSelectedTime(document).toEither(
          () => data_fetch_failure.OtherFailure.fromPresets(
            data_fetch_failure.Preset.fafuAnalyzing,
            "error in analyzing exams (year or semester not found)",
          ),
        ),
      );
      final rootNode = $(
        Option.fromNullable(table.children.getOrNull(0)).toEither(
          () => data_fetch_failure.OtherFailure.fromPresets(
            data_fetch_failure.Preset.fafuAnalyzing,
            "error in analyzing exams (root node not found",
          ),
        ),
      );
      return (
        $(
          _getAvailableTime(document).toEither(
            () => data_fetch_failure.OtherFailure.fromPresets(
              data_fetch_failure.Preset.fafuAnalyzing,
              "error in analyzing exams (available time not found)",
            ),
          ),
        ),
        ExamsEntity(
          academicYear: academicYear,
          semester: semester,
          entities: rootNode.children
              .drop(1)
              .mapNotNull(
                (it) => it.children.let((i) {
                  final (fromTime, toTime) = convertDateTime(
                    i[3].string,
                  ).match(() => (null, null), (it) => it);
                  return i.length < 8
                      ? null
                      : ExamEntity(
                          classId: i[0].string,
                          name: i[1].string,
                          studentName: i[2].string,
                          fromTime: fromTime,
                          toTime: toTime,
                          place: i[4].string,
                          form: i[5].string,
                          seat: i[6].string,
                          campus: i[7].string,
                        );
                }),
              )
              .toList(),
        ),
      );
    });
  }

  static Either<
    data_fetch_failure.SchoolDataFetchFailure,
    (AvailableTermTime, ScoresEntity)
  >
  analyzeScores(String htmlString) =>
      Either<
        data_fetch_failure.SchoolDataFetchFailure,
        (AvailableTermTime, ScoresEntity)
      >.Do(($) {
        final document = BeautifulSoup(htmlString);
        final table = $(
          Option.fromNullable(document.find("table", id: "DataGrid1")).toEither(
            () => data_fetch_failure.OtherFailure.fromPresets(
              data_fetch_failure.Preset.fafuAnalyzing,
              "error in analyzing scores (table element not found)",
            ),
          ),
        );
        final (academicYear, semester) = $(
          _getSelectedTime(
            document,
            academicYearId: "ddlxn",
            semesterId: "ddlxq",
          ).toEither(
            () => data_fetch_failure.OtherFailure.fromPresets(
              data_fetch_failure.Preset.fafuAnalyzing,
              "error in analyzing scores (year or semester not found)",
            ),
          ),
        );
        final rootNode = $(
          Option.fromNullable(table.children.getOrNull(0)).toEither(
            () => data_fetch_failure.OtherFailure.fromPresets(
              data_fetch_failure.Preset.fafuAnalyzing,
              "error in analyzing scores (root node not found",
            ),
          ),
        );
        return (
          $(
            _getAvailableTime(
              document,
              academicYearId: "ddlxn",
              semesterId: "ddlxq",
            ).toEither(
              () => data_fetch_failure.OtherFailure.fromPresets(
                data_fetch_failure.Preset.fafuAnalyzing,
                "error in analyzing scores (available time not found)",
              ),
            ),
          ),
          ScoresEntity(
            academicYear: academicYear,
            semester: semester,
            entities: rootNode.children
                .drop(1)
                .mapNotNull(
                  (it) => it.children.let((i) {
                    return ScoreEntity(
                      year: i[0].string,
                      term: i[1].string,
                      classId: i[2].string,
                      name: i[3].string,
                      type: i[4].string,
                      belong: i[5].string,
                      score: i[7].string,
                      credit: i[6].string,
                      gp: i[11].string,
                      place: i[10].string,
                      note: "${i[12].string}:${i[13].string}",
                      elective: i[4].string.contains("选修"),
                    );
                  }),
                )
                .toList(growable: false),
          ),
        );
      });

  static Option<AvailableTermTime> _getAvailableTime(
    BeautifulSoup document, {
    String academicYearId = "xnd",
    String semesterId = "xqd",
  }) {
    return Option.Do(($) {
      return AvailableTermTime(
        $(Option.fromNullable(document.find("*", id: academicYearId))).children
            .map(
              (it) => (it.text, $(Option.fromNullable(it.attributes["value"]))),
            )
            .toList(),
        $(Option.fromNullable(document.find("*", id: semesterId))).children
            .map(
              (it) => (it.text, $(Option.fromNullable(it.attributes["value"]))),
            )
            .toList(),
      );
    });
  }

  static Either<data_fetch_failure.SchoolDataFetchFailure, ClassEntity>
  _generateClassEntity(
    (int optionTime, int optionDuration, int optionDow, List<String> data)
    dataGroup,
  ) {
    return Either<data_fetch_failure.SchoolDataFetchFailure, ClassEntity>.Do((
      $,
    ) {
      final normalTimeMatcher = "(周).(第)(.+,*)(节)".asRegExp;
      final normalWeekMatcher = "(?<=\\{).*(?=\\})".asRegExp;
      final dowMatcher = "(?<=周).(?=第)".asRegExp;
      final timeMatcher = "(?<=第)(.+,*)(?=节)".asRegExp;
      final (optionTime, optionDuration, optionDow, data) = dataGroup;
      if (data.length < 4) {
        $(
          Either.left(
            data_fetch_failure.OtherFailure.fromPresets(
              data_fetch_failure.Preset.fafuAnalyzing,
              "error in analyzing class table (bad data length)",
            ),
          ),
        );
      }
      final name = data[0];
      final timeRaw = data[1];
      final teacher = data[2];
      final place = data[3];
      final primaryTimeMatch = timeRaw.matchFirst(normalTimeMatcher);
      final (time, duration, dow) = $<(int, int, DayOfWeek)>(
        primaryTimeMatch.match(
          () {
            final dow = DayOfWeek.valueOf((optionDow + 1) % 7);
            if (dow == null) {
              return Either.left(
                data_fetch_failure.OtherFailure.fromPresets(
                  data_fetch_failure.Preset.fafuAnalyzing,
                  "error in analyzing class table (pathway 1: dow not found)",
                ),
              );
            }
            return Either.right((optionTime, optionDuration, dow));
          },
          (some) {
            final (time, duration) =
                some
                    .matchFirst(timeMatcher)
                    .map((x) => x.split(","))
                    .map(
                      (it) => (
                        it
                            .getOrNull(0)
                            ?.toIntOption
                            .match(() => null, (x) => x - 1),
                        it.length,
                      ),
                    )
                    .toNullable() ??
                (null, null);
            final dow = some
                .matchFirst(dowMatcher)
                .map(DayOfWeek.chineseValueOf)
                .toNullable();
            if (time == null || duration == null || dow == null) {
              return Either.left(
                data_fetch_failure.OtherFailure.fromPresets(
                  data_fetch_failure.Preset.fafuAnalyzing,
                  "error in analyzing class table (pathway 2: time, duration or dow not found)",
                ),
              );
            }
            return Either.right((time, duration, dow));
          },
        ),
      );
      final primaryWeekMatch = $(
        timeRaw
            .matchFirst(normalWeekMatcher)
            .toEither(
              () => data_fetch_failure.OtherFailure.fromPresets(
                data_fetch_failure.Preset.fafuAnalyzing,
                "error in analyzing class table (week was not matched)",
              ),
            ),
      );
      final weeksRaw = primaryWeekMatch.split("|");
      final singleWeek = weeksRaw.contains("单周");
      final doubleWeek = weeksRaw.contains("双周");
      final weeksRangeRaw = weeksRaw[0]
          .let((it) => it.substring(1, it.length - 1))
          .split("-");
      final weeks =
          range(
                weeksRangeRaw[0].toIntOption.getOrElse(
                  () => throw Exception(
                    "error in analyzing class table (week[0] absent)",
                  ),
                ),
                to: weeksRangeRaw[1].toIntOption.getOrElse(
                  () => throw Exception(
                    "error in analyzing class table (week[1] absent)",
                  ),
                ),
              )
              .filter(
                (it) =>
                    !(singleWeek && it % 2 == 0) &&
                    !(doubleWeek && it % 2 != 0),
              )
              .map((it) => it - 1)
              .toList();
      return ClassEntity(
        name,
        teacher,
        dow,
        time,
        duration,
        weeks.map((it) => dow == DayOfWeek.sun ? it + 1 : it).toList(),
        place,
        false,
      );
    });
  }
}
