import 'package:corrupt/features/channel/domain/use_case/fetch_school_data_online_usecase.dart';
import 'package:corrupt/features/channel/domain/use_case/school_impl_select_usecase.dart';
import 'package:corrupt/features/channel/domain/use_case/school_login_usecase.dart';
import 'package:corrupt/features/subchannels/fafu/infrastructure.dart';
import 'package:corrupt/features/subchannels/fjut/infrastructure.dart';
import 'package:corrupt/features/subchannels/mju/infrastructure.dart';
import 'package:corrupt/infrastructure/di.dart';

class InfraChannel implements DIRegister {
  final _registers = <DIRegister>[InfraFafu(), InfraMju(), InfraFjut()];

  @override
  void diRegister() {
    for (final it in _registers) {
      it.diRegister();
    }
    getIt.registerFactory<FetchSchoolDataOnlineUseCase>(
      () => FetchSchoolDataOnlineUseCase(getIt(), getIt()),
    );
    getIt.registerFactory<SchoolImplSelectUseCase>(
      () => SchoolImplSelectUseCase(getIt(), getIt()),
    );
    getIt.registerFactory<SchoolLoginUseCase>(
      () => SchoolLoginUseCase(getIt()),
    );
  }
}
