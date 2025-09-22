import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).appBarTheme.titleTextStyle;
    return Text(
      text,
      style: base?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: color ?? Colors.black,
      ),
    );
  }
}
