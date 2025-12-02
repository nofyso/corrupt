import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:flutter/material.dart';

class ExpandMoreColumn extends StatefulWidget {
  final int initialShowAmount;
  final int moreDelta;
  final String showMoreText;
  final List<Widget> children;

  const ExpandMoreColumn({
    super.key,
    this.initialShowAmount = 1,
    this.moreDelta = 16,
    required this.showMoreText,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() => _ExpandMoreColumnState();
}

class _ExpandMoreColumnState extends State<ExpandMoreColumn> {
  late int showAmount;
  late final int moreDelta;
  late final String showMoreText;

  @override
  void initState() {
    super.initState();
    showAmount = widget.initialShowAmount;
    moreDelta = widget.moreDelta;
    showMoreText = widget.showMoreText;
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.children;
    final showedChildren = children.sublist(0, showAmount);
    return Column(
      spacing: 4,
      children: [
        ...showedChildren,
        if (showAmount < children.length)
          textIconButton(
            onPressed: () {
              setState(() {
                showAmount += moreDelta;
                showAmount = showAmount.clamp(1, children.length);
              });
            },
            icon: Icons.expand_more,
            text: showMoreText,
          ),
      ],
    );
  }
}
