import 'package:corrupt/features/pref/infrastructure.dart';
import 'package:corrupt/features/refresh/infrastructure.dart';

interface class EventRegister {
  void eventRegister() {}
}

void setupEventListener() {
  final eventRegisters = <EventRegister>[InfraPrefs(), InfraRefresh()];

  for (final it in eventRegisters) {
    it.eventRegister();
  }
}
