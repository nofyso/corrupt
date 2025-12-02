import 'dart:typed_data';

import 'package:corrupt/features/larva/domain/entity/larva_config.dart';
import 'package:corrupt/features/larva/domain/entity/larva_failure.dart';
import 'package:dartlin/dartlin.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart' as img;

class LarvaImage {
  List<List<int>> image;

  LarvaImage._of({required this.image});

  LarvaImage twoValuation(num greyThreshold) => _newCache((_, _, p) {
    if (_getGreyValue(p._toRgbElement()) >= greyThreshold) {
      return 0xFFFFFF;
    } else {
      return 0x000000;
    }
  })._ofImage();

  LarvaImage subImage(int x, int y, int w, int h) =>
      LarvaImage._newEmpty(w, h)._forEach((i, j, _) => image[i + x][j + y])._ofImage();

  LarvaImage convolution(List<List<num>> conv) {
    final cache = _newCache((_, _, p) => p);
    final convSize = conv.length;
    final halfConvSize = (convSize / 2).toInt();
    int getWithEdge(int i, int j) {
      final ni = i.clamp(0, cache.length - 1);
      final subList = cache[ni];
      final nj = j.clamp(0, subList.length - 1);
      return subList[nj];
    }

    for (final i in range(-halfConvSize, to: cache.length - halfConvSize - 1)) {
      for (final j in range(
        -halfConvSize,
        to: cache[i.clamp(0, cache.length - 1)].length - halfConvSize - 1,
      )) {
        var nr = 0.0, ng = 0.0, nb = 0.0;
        for (final (ci, cl) in conv.indexed) {
          for (final (cj, cp) in cl.indexed) {
            final edge = getWithEdge(i + ci, j + cj);
            final (r, g, b) = edge._toRgbElement();
            nr += (r * cp);
            ng += (g * cp);
            nb += (b * cp);
          }
        }
        cache[i + halfConvSize][j + halfConvSize] = (nr.toInt(), ng.toInt(), nb.toInt())._toRgb();
      }
    }
    return cache._ofImage();
  }

  LarvaImage reverseColor() => _newCache((_, _, p) {
    final (r, g, b) = p._toRgbElement();
    final (nr, ng, nb) = (255 - r, 255 - g, 255 - b);
    return (nr, ng, nb)._toRgb();
  })._ofImage();

  List<List<int>> _newCache(int Function(int, int, int) fun) => (List.generate(
    image.length,
    (i) => List.generate(image[i].length, (j) => image[i][j]),
  ))._forEach(fun);

  double _getGreyValue((int, int, int) rgbArray) =>
      (rgbArray.$1 * 0.299 + rgbArray.$2 * 0.587 + rgbArray.$3 * 0.114);

  List<LarvaImage> batchProcess(LarvaConfig config) {
    var image = LarvaImage._of(image: this.image);
    for (final operation in config.operations) {
      switch (operation.type) {
        case "clip":
          operation as ClipOperation;
          image = image.subImage(operation.x, operation.y, operation.width, operation.height);
        case "convolution":
          operation as ConvolutionOperation;
          image = image.convolution(operation.kernel);
        case "two_valuation":
          operation as TwoValuationOperation;
          image = image.twoValuation(operation.threshold);
        case "reverse":
          operation as ReverseOperation;
          image = image.reverseColor();
      }
    }
    return config.clips
        .map((it) => image.subImage(it[0], it[1], it[2], it[3]))
        .toList(growable: true);
  }

  List<double> asVector() {
    List<double> list = List.empty(growable: true);
    for (int i = 0; i < image.length; i++) {
      for (int j = 0; j < image[i].length; j++) {
        list.add(_getGreyValue(image[i][j]._toRgbElement()) / 255.0);
      }
    }
    // for (int i = 0; i < image[0].length; i++) {
    //   for (int j = 0; j < image.length; j++) {
    //     list.add(_getGreyValue(image[j][i]._toRgbElement()) / 255.0);
    //   }
    // }
    return list;
  }

  static Future<Either<LarvaFailure, LarvaImage>> fromBytes(Uint8List data) async {
    final image = img.decodeImage(data);
    if (image == null) return Either.left(FileFailure());
    List<List<int>> imagePixels = List.generate(
      image.width,
      (x) => List.generate(image.height, (y) => image.getPixel(x, y)._toRgb()),
    );
    return Either.right(LarvaImage._of(image: imagePixels));
  }

  static List<List<int>> _newEmpty(int w, int h) =>
      List.generate(w, (x) => List.generate(h, (y) => 0));
}

extension on List<List<int>> {
  List<List<int>> _forEach(int Function(int, int, int) fun) {
    for (final (i, l) in indexed) {
      for (final (j, p) in l.indexed) {
        l[j] = fun(i, j, p);
      }
    }
    return this;
  }

  LarvaImage _ofImage() => LarvaImage._of(image: this);
}

extension on img.Pixel {
  int _toRgb() => (r.toInt(), g.toInt(), b.toInt())._toRgb();
}

extension on (int, int, int) {
  int _toRgb() =>
      (((this.$1.toInt() & 0xff) << 16) |
      ((this.$2.toInt() & 0xff) << 8) |
      (this.$3.toInt() & 0xff));
}

extension on int {
  (int, int, int) _toRgbElement() =>
      ((this & 0x00ff0000) >> 16, (this & 0x0000ff00) >> 8, (this & 0x000000ff));
}
