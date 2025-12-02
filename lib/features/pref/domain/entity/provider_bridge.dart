class PrefsProviderEvent {
  final PrefsProviderType provider;

  PrefsProviderEvent(this.provider);
}

enum PrefsProviderType { prefs }
