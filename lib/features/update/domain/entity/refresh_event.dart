import 'package:corrupt/features/update/domain/entity/update_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class RefreshEvent {}

class RefreshDataInvalidateEvent extends RefreshEvent {
  AsyncNotifierProvider<dynamic, dynamic> provider;

  RefreshDataInvalidateEvent(this.provider);
}

class RefreshPrefInvalidateEvent extends RefreshEvent {}

class RefreshUpdateStateEvent extends RefreshEvent {
  final UpdateInfo updateInfo;

  RefreshUpdateStateEvent(this.updateInfo);
}
