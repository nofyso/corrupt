import 'package:cirno_pref_key/cirno_pref.dart';
import 'package:corrupt/features/pref/domain/entity/provider_bridge.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:event_bus/event_bus.dart';

class PrefReadUseCase {
  Future<ET> read<OT, ET>(CirnoPrefKey<OT, ET> key) async => key.read(null);

  Future<OT> readRaw<OT, ET>(CirnoPrefKey<OT, ET> key) async => key.readRaw(null);
}

class PrefWriteUseCase {
  final _eventBus = getIt<EventBus>();

  Future<void> write<OT, ET>(CirnoPrefKey<OT, ET> key, ET newValue) async {
    await key.write(null, newValue);
    _eventBus.fire(PrefsProviderEvent(PrefsProviderType.prefs));
  }

  Future<void> writeRaw<OT, ET>(CirnoPrefKey<OT, ET> key, OT newValue) async {
    await key.writeRaw(null, newValue);
    _eventBus.fire(PrefsProviderEvent(PrefsProviderType.prefs));
  }
}
