import 'package:flutter/material.dart';

enum TextType { h1, h2, h3, h4, body, small, link }

class ThemedText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? lightColor;
  final Color? darkColor;
  final TextStyle? style;

  const ThemedText(
    this.text, {
    super.key,
    this.type = TextType.body,
    this.lightColor,
    this.darkColor,
    this.style,
  });

  TextStyle _styleForType(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    switch (type) {
      case TextType.h1:
        return theme.displayLarge!;
      case TextType.h2:
        return theme.displayMedium!;
      case TextType.h3:
        return theme.displaySmall!;
      case TextType.h4:
        return theme.headlineMedium!;
      case TextType.small:
        return theme.bodySmall!;
      case TextType.link:
        return theme.bodyMedium!.copyWith(
          decoration: TextDecoration.underline,
        );
      case TextType.body:
        return theme.bodyMedium!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isDark
        ? darkColor ?? Theme.of(context).colorScheme.onSurface
        : lightColor ?? Theme.of(context).colorScheme.onSurface;

    return Text(
      text,
      style: _styleForType(context).copyWith(color: color).merge(style),
    );
  }
}
