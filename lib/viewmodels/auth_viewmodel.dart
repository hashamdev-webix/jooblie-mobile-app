import 'package:flutter/material.dart';
import 'package:jooblie_app/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authRepository.currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authRepository.signIn(email, password);
      _setLoading(false);
      // Extra safety check although Supabase usually throws if email is unconfirmed and confirmation is required
      if (response.user != null && response.user!.emailConfirmedAt == null) {
        return 'Please verify your email first ❌';
      }
      return null;
    } on AuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return e.message;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return e.toString();
    }
  }

  Future<String?> signUp(String email, String password, Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authRepository.signUp(email, password, data);
      _setLoading(false);
      
      // Supabase email enumeration protection returns a user with empty identities if the email is already in use
      if (response.user != null && response.user!.identities != null && response.user!.identities!.isEmpty) {
        final msg = 'An account with this email already exists.';
        _setError(msg);
        return msg;
      }

      if (response.user != null && response.session == null) {
        return 'verify_email';
      }
      return null;
    } on AuthException catch (e) {
      String msg = e.message;
      if (msg.toLowerCase().contains('rate limit')) {
        msg = 'Too many signup attempts. Please wait a few minutes.';
      } else if (msg.toLowerCase().contains('already')) {
        msg = 'An account with this email already exists.';
      }
      _setError(msg);
      _setLoading(false);
      return msg;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut(BuildContext context) async {
    _setLoading(true);
    try {
      await _authRepository.signOut(context);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<String?> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authRepository.resetPassword(email);
      _setLoading(false);
      return null;
    } on AuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return e.message;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return e.toString();
    }
  }
}
