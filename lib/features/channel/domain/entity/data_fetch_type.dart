import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/exam_entity.dart';
import 'package:corrupt/features/channel/domain/entity/request_argument.dart';
import 'package:corrupt/features/channel/domain/entity/score_entity.dart';
import 'package:fpdart/fpdart.dart';

enum DataFetchType<P, V> {
  classes<TermBasedFetchArgument?, (AvailableTermTime, ClassTable)>(),
  termData<Unit, List<TermData>>(),
  classTime<Unit, ClassTime>(),
  exam<TermBasedFetchArgument?, (AvailableTermTime, ExamsEntity)>(),
  score<TermBasedFetchArgument?, (AvailableTermTime, ScoresEntity)>();

  P castP(dynamic any) => any as P;
}
