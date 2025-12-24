import 'package:corrupt/presentation/util/duration_consts.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';

Widget simpleAnimatedSize({
  required bool show,
  Curve curve = Curves.easeOutQuart,
  Duration duration = MaterialDurations.medium,
  required Widget child,
}) => AnimatedSize(
  duration: duration,
  curve: curve,
  child: show.let((it) => it ? child : SizedBox.shrink(child: child)),
);

Widget simpleAnimatedOpacity({
  required bool show,
  Curve curve = Curves.easeOutQuart,
  Duration duration = MaterialDurations.medium,
  required Widget child,
}) => AnimatedOpacity(
  opacity: show ? 1 : 0,
  duration: duration,
  curve: curve,
  child: child.let((it) => show ? it : SizedBox.shrink(child: it)),
);

Widget textIconButton({
  required void Function() onPressed,
  required IconData icon,
  required String text,
}) => TextButton(
  onPressed: onPressed,
  child: textIconWidget(icon: icon, text: text),
);

Widget textIconWidget({required IconData icon, required String text}) => Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(width: 24, height: 24, child: Icon(icon, size: 24)),
    SizedBox(width: 8),
    Text(text),
  ],
);

Widget iconTitleAndSubtitle({
  required BuildContext context,
  required IconData icon,
  required String title,
  String? subtitle,
}) {
  final textTheme = Theme.of(context).textTheme;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 32),
      Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
      if (subtitle != null) Text(subtitle, textAlign: TextAlign.center),
    ],
  );
}
