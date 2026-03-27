import 'package:flutter/material.dart';

class SubTitleWidget extends StatelessWidget {
  final ThemeData theme;
  final String subTitle;
  const SubTitleWidget({
    super.key,
    required this.theme,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(subTitle, style: theme.textTheme.bodyMedium);
  }
}
