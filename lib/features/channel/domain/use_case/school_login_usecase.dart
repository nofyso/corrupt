import 'package:corrupt/features/channel/domain/abstract_repository/abstract_school.dart';
import 'package:corrupt/features/channel/domain/entity/failure/school_login_failure.dart'
    as login_failure;
import 'package:corrupt/features/channel/domain/entity/school_enum.dart';
import 'package:corrupt/features/channel/domain/use_case/school_impl_select_usecase.dart';
import 'package:corrupt/features/subchannels/fafu/domain/entity/fafu_request_parameters.dart';
import 'package:corrupt/features/subchannels/mju/domain/entity/mju_request_parameter.dart';
import 'package:fpdart/fpdart.dart';

class SchoolLoginUseCase {
  final SchoolImplSelectUseCase _implSelect;

  SchoolLoginUseCase(this._implSelect);

  Future<Either<login_failure.SchoolLoginFailure, dynamic>> firstLogin(
    School? implType,
    (String studentId, String password)? dataPair,
  ) async {
    switch (await _implSelect.select(implType)) {
      case Some<(School, AbstractSchoolRepository<dynamic, dynamic>)>(
        value: final school,
      ):
        final (type, impl) = school;
        switch (type) {
          case School.fafu:
            return await impl.login(
              dataPair != null
                  ? FafuLoginParameter(dataPair.$1, dataPair.$2)
                  : null,
            );
          case School.mju:
            return await impl.login(
              dataPair != null
                  ? MjuLoginParameter(dataPair.$1, dataPair.$2)
                  : null,
            );
          case School.fjut:
            // TODO: Handle this case.
            throw UnimplementedError();
          case School.none:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case None():
        return Either.left(login_failure.OtherFailure("Not logged"));
    }
  }
}
