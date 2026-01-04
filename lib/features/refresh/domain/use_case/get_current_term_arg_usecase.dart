import 'package:corrupt/features/channel/domain/abstract_repository/abstract_school.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_data_fetch_failure.dart';
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:corrupt/features/channel/domain/use_case/school_impl_select_usecase.dart';
import 'package:corrupt/util/class_time_util.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentTermArgUseCase {
  final SchoolImplSelectUseCase _implSelectUseCase;

  GetCurrentTermArgUseCase(this._implSelectUseCase);

  Future<Option<TermData>> getCurrentTermData() async {
    final schoolOption = await _implSelectUseCase.select();
    switch (schoolOption) {
      case Some<(School, AbstractSchoolRepository<dynamic, dynamic>)>(
        value: final school,
      ):
        final (_, impl) = school;
        final termDataListResult = await impl.fetchData(
          DataFetchType.termData,
          null,
        );
        switch (termDataListResult) {
          case Right<SchoolDataFetchFailure, List<TermData>>(
            value: final termDataList,
          ):
            return _selectCurrentTerm(termDataList);
          case Left<SchoolDataFetchFailure, List<TermData>>():
            return Option.none();
        }
      case None():
        return Option.none();
    }
  }

  //Experimental
  Option<TermData> _selectCurrentTerm(List<TermData> termDataList) {
    final time = DateTime.timestamp().toLocal();
    return ClassTimeUtil.selectCurrentTermData(time, termDataList);
  }
}
