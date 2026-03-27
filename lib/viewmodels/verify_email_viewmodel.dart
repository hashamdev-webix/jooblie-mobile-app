import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  StreamSubscription<AuthState>? _authStateSubscription;

  void listenAuthentication(BuildContext context, {bool isFromForgotPassword = false}) {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
          final session = data.session;
          final event = data.event;
          
          if (session != null) {
            final user = session.user;
            
            // For signup, we redirect to splash once signed in (email confirmed)
            // For forgot password, we don't redirect here; main.dart handles the passwordRecovery event
            if (!isFromForgotPassword && 
                event == AuthChangeEvent.signedIn && 
                user.emailConfirmedAt != null) {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.splash,
                  (route) => false,
                );
              }
            }
          }
        });
  }

  Future<void> resendVerificationEmail(
    BuildContext context,
    String email, {
    bool isFromForgotPassword = false,
  }) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: isFromForgotPassword ? OtpType.recovery : OtpType.signup,
        email: email,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email resent successfully!'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to resend email: $e')));
      }
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
