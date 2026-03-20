import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  LoginViewModel({required this.authViewModel});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  bool isJobSeeker = true;

  bool get isLoading => _isLoading;
  String get email => _email;
  String get password => _password;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<String?> login() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      
      _isLoading = true;
      notifyListeners();

      final result = await authViewModel.signIn(_email, _password);
      
      if (result == null && authViewModel.currentUser != null) {
         final userData = authViewModel.currentUser!.userMetadata;
         final user = authViewModel.currentUser;
         
         debugPrint('--- User Login Data ---');
         debugPrint('Email: ${user?.email}');
         debugPrint('UID: ${user?.id}');
         debugPrint('Metadata: $userData');
         debugPrint('-----------------------');

         final userType = userData?['role'] ?? 'job_seeker';
         isJobSeeker = (userType == 'job_seeker');
         
         // Save role to SharedPreferences as backup
         final prefs = await SharedPreferences.getInstance();
         await prefs.setBool('is_job_seeker', isJobSeeker);
      }

      _isLoading = false;
      notifyListeners();
      return result; // null means success, otherwise error message
    }
    return 'Please fix the errors in the form.';
  }
}
