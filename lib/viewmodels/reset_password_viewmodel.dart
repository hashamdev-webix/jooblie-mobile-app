import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<String?> updatePassword() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: _password),
        );
        // Destroy the recovery session so they are forced to log in manually
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_logged_in_manually', false);
        await Supabase.instance.client.auth.signOut();
        _isLoading = false;
        notifyListeners();
        return null; // Success
      } on AuthException catch (e) {
        _errorMessage = e.message;
        _isLoading = false;
        notifyListeners();
        return e.message;
      } catch (e) {
        _errorMessage = e.toString();
        _isLoading = false;
        notifyListeners();
        return e.toString();
      }
    }
    return 'Please fix the errors in the form.';
  }
}
