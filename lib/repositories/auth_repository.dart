import 'package:jooblie_app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepository(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  Future<AuthResponse> signUp(String email, String password, Map<String, dynamic> data) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );



  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
