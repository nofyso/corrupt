import 'dart:convert';
import 'dart:typed_data';

import 'package:corrupt/features/larva/data/preprocess.dart';
import 'package:corrupt/features/larva/domain/abstract_repository/larva_repository.dart';
import 'package:corrupt/features/larva/domain/entity/larva_config.dart';
import 'package:corrupt/features/larva/domain/entity/larva_failure.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LarvaImpl extends LarvaRepository {
  @override
  Future<Either<LarvaFailure, String>> predict({
    required Uint8List imageData,
    required String modelPath,
  }) async {
    final decoded = jsonDecode(
      await rootBundle.loadString("$modelPath.larva.json"),
    );
    final config = LarvaConfig.fromJson(decoded);
    final imageResult = await LarvaImage.fromBytes(imageData);
    if (imageResult.isLeft()) {
      return Either.left(imageResult.getLeft().toNullable()!);
    }
    final rawImage = imageResult.getRight().toNullable()!;
    final processedImages = rawImage.batchProcess(config);
    var outString = "";
    final interpreter = await Interpreter.fromAsset("$modelPath.larva.tflite");
    for (final image in processedImages) {
      final rawVector = image.asVector();
      var inputShape = interpreter.getInputTensor(0).shape;
      var outputShape = interpreter.getOutputTensor(0).shape;
      final input = Float32List.fromList(rawVector).reshape(inputShape);
      final output = Float32List(config.values.length).reshape(outputShape);
      interpreter.run(input, output);
      output as List<List<dynamic>>;
      final max = output[0].map((it) => it as double).toList()._findMax();
      final (maxValue, maxIndex) = max;
      final key = config.values.find((_, it) => (it as num) == maxIndex);
      if (key == null) {
        return Either.left(TensorFailure());
      }
      outString += key.$1;
    }
    return Either.right(outString);
  }
}

extension<K, V> on Map<K, V> {
  (K, V)? find(bool Function(K, V) test) {
    for (final e in entries) {
      if (test(e.key, e.value)) return (e.key, e.value);
    }
    return null;
  }
}

extension on List<double> {
  (double, int) _findMax() {
    int maxIndex = -1;
    double maxValue = -double.maxFinite;
    for (final (i, d) in indexed) {
      if (d > maxValue) {
        maxValue = d;
        maxIndex = i;
      }
    }
    return (maxValue, maxIndex);
  }
}
