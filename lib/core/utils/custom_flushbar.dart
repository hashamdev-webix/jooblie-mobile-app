import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      icon: const Icon(Icons.error_outline, size: 28.0, color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
