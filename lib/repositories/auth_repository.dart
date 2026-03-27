import 'package:flutter/material.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/services/supabase_service.dart';
import 'package:jooblie_app/services/notifications_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jooblie_app/main.dart';

class AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepository(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  Future<AuthResponse> signUp(
    String email,
    String password,
    Map<String, dynamic> data,
  ) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      try {
        String? deviceToken;
        try {
          NotificationsService notificationService = NotificationsService();
          deviceToken = await notificationService.getDeviceToken();
        } catch (e) {
          print("Error getting device token: $e");
        }

        final existingProfile = await _client
            .from('profiles')
            .select('*')
            .eq('id', user.id)
            .maybeSingle();

        if (existingProfile == null) {
          final metadata = user.userMetadata ?? {};
          final userRole = metadata['role'] ?? 'job_seeker';

          await _client.from('profiles').insert({
            'id': user.id,
            'role': userRole,
            'full_name': metadata['full_name'] ?? 'User',
            'company_name': userRole == 'recruiter'
                ? metadata['company_name']
                : null,
            'userDeviceToken': deviceToken,
          });
        } else {
          // Sync token even for existing users during sign in
          await NotificationsService().syncTokenToSupabase();
        }
      } catch (e) {
        throw Exception('Error checking/creating/updating profile: $e');
      }
    }

    return response;
  }

  Future<void> signOut(BuildContext context) async {
    await _client.auth.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route)=>false);
      AppRestartWrapper.restartApp(context);
    }
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'myapp://reset-password',
    );
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
