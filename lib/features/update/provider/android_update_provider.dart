import 'package:corrupt/features/update/domain/entity/update_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateStateProvider = StateProvider(
  (_) => AndroidUpdateState(false, false, 0, 0),
);

final updateAvailabilityProvider = StateProvider(
  (_) => UpdateInfo(false, null),
);
