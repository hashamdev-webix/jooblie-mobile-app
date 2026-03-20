import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  SignupViewModel({required this.authViewModel});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isJobSeeker = true; // true = Job Seeker, false = Recruiter
  String _fullName = '';
  String _companyName = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  bool get isJobSeeker => _isJobSeeker;
  bool get isLoading => _isLoading;
  String get fullName => _fullName;
  String get companyName => _companyName;
  String get email => _email;
  String get password => _password;

  void setRole(bool isJobSeekerRole) {
    _isJobSeeker = isJobSeekerRole;
    notifyListeners();
  }

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateCompanyName(String? value) {
    if (!_isJobSeeker) {
      if (value == null || value.isEmpty) {
        return 'Please enter your company name';
      }
    }
    return null;
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
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<String?> register() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> data = {
        'full_name': _fullName,
        'role': _isJobSeeker ? 'job_seeker' : 'recruiter',
      };
      if (!_isJobSeeker) {
        data['company_name'] = _companyName;
      }

      final result = await authViewModel.signUp(_email, _password, data);

      if (result == null || result == 'verify_email') {
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_job_seeker', _isJobSeeker);
      }

      _isLoading = false;
      notifyListeners();
      return result; // returning the message/flag
    }
    return 'Please fix the errors in the form.';
  }
}
