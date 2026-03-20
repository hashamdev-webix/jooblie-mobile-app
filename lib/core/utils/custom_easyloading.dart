import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../app_colors.dart';

class CustomEasyLoading {
  static void config(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = theme.cardColor
      ..indicatorColor = AppColors.primaryColor
      ..textColor = isDark ? Colors.white : AppColors.lightForeground
      ..maskColor = Colors.black.withValues(alpha: 0.5)
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorSize = 45.0
      ..radius = 12.0
      ..boxShadow = <BoxShadow>[]
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  static void show(BuildContext context, {String message = 'Loading...'}) {
    config(context);
    EasyLoading.show(status: message);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
