import 'dart:convert';
import 'dart:typed_data';

import 'package:dartlin/collections.dart';
import 'package:dartlin/control_flow.dart';

class MjuEncryptUtil {
  static String encrypt(String modulusHex, String exponentHex, String password) {
    final data = utf8.encode(password.split("").reversed.join());
    final modulus = BigInt.parse("00$modulusHex", radix: 16);
    final exponent = BigInt.parse(exponentHex, radix: 16);
    final chunkSize = _getChunkSize(modulusHex);
    final paddedData = _paddingData(data, chunkSize);
    final stringBuilder = StringBuffer();
    for (final ind in 0.to(paddedData.length - 1, step: chunkSize)) {
      final blockHex = _toHex(paddedData.sublist(ind, ind + chunkSize));
      final crypt = BigInt.parse(blockHex, radix: 16).modPow(exponent, modulus);
      stringBuilder.write(crypt.toRadixString(16).let((it) => it.length % 2 == 1 ? "0$it" : it));
    }
    return stringBuilder.toString();
  }

  static String _toHex(Uint8List data) => data
      .map(
        (it) => it.toRadixString(16).let((a) {
          assert(a.length == 1 || a.length == 2);
          return a.length == 1 ? "0$a" : a;
        }),
      )
      .toList()
      .reversed
      .join();

  static Uint8List _paddingData(Uint8List data, int chunkSize) {
    final newData = Uint8List((data.length / chunkSize.toDouble()).ceil() * chunkSize);
    newData.fillRange(0, newData.length, 0);
    newData.setAll(0, data);
    return newData;
  }

  static int _getChunkSize(String modulusHex) {
    final o = (modulusHex.length / 4.0).ceil();
    return (o - 1) * 2;
  }
}
