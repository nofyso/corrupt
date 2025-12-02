import 'package:fpdart/fpdart.dart';

extension RegexHelper on String {
  Option<String> matchFirst(RegExp reg) => Option.fromNullable(reg.firstMatch(this)?.group(0));
}
