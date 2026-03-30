import 'package:flutter/material.dart';

import '../../../../core/sized.dart';

class RecruiterPostJobFormField extends StatelessWidget {
  final String label;
  final Widget child;

  const RecruiterPostJobFormField({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        8.h,
        child,
      ],
    );
  }
}
