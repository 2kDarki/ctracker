import 'package:flutter/material.dart';

class ThemedView extends StatelessWidget {
  final Widget child;
  final Color? lightColor;
  final Color? darkColor;
  final EdgeInsetsGeometry? padding;

  const ThemedView({
    super.key,
    required this.child,
    this.lightColor,
    this.darkColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? darkColor ?? Theme.of(context).colorScheme.surface
        : lightColor ?? Theme.of(context).colorScheme.surface;

    return Container(
      color: background,
      padding: padding,
      child: child,
    );
  }
}
