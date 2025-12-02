import 'dart:io';

abstract class PlatformUtils {
  static bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
