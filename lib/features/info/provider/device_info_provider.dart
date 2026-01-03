import 'dart:io';

import 'package:corrupt/infrastructure/di.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final androidInfoProvider = FutureProvider(
  (_) async => Option.fromNullable(
    Platform.isAndroid ? await getIt<DeviceInfoPlugin>().androidInfo : null,
  ),
);
