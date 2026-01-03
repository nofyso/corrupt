import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final prefProvider =
    FutureProviderFamily<Option<dynamic>, CirnoPrefKey<dynamic, dynamic>>(
      (_, key) async => Option.of(await key.read(null)),
    );
