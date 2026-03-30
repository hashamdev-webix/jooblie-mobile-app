import 'package:flutter/material.dart';

class HeadingTextWidget extends StatelessWidget {
  final ThemeData theme;
  final String title;
  const HeadingTextWidget({
    super.key,
    required this.theme,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
