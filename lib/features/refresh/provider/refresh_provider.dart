import 'package:corrupt/features/refresh/domain/use_case/refresh_usecase.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshNotifierProvider = StreamProvider(
  (_) => getIt<RefreshUseCase>().refresh(),
);
