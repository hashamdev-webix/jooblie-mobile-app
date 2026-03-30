import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  ForgotPasswordViewModel({required this.authViewModel});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email = '';
  bool _isLoading = false;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get successMessage => _successMessage;
  String get email => _email;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<String?> sendResetLink() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      _isLoading = true;
      _successMessage = null;
      notifyListeners();

      final result = await authViewModel.resetPassword(_email);

      _isLoading = false;
      if (result == null) {
        _successMessage = 'Password reset link has been sent to your email! ✅';
      }
      notifyListeners();
      return result; // null means success, otherwise error message
    }
    return 'Please fix the errors in the form.';
  }
}
