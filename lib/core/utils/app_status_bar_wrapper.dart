import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppStatusBarWrapper extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const AppStatusBarWrapper({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: child,
    );
  }
}