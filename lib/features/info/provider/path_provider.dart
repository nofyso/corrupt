import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';

final applicationSupportPathProvider = FutureProvider(
  (_) async => Option.of(await getApplicationSupportDirectory()),
);
