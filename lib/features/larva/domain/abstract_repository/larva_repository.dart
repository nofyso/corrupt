import 'dart:typed_data';

import 'package:corrupt/features/larva/domain/entity/larva_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class LarvaRepository {
  Future<Either<LarvaFailure, String>> predict({
    required Uint8List imageData,
    required String modelPath,
  });
}
