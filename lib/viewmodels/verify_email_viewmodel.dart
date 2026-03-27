import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  StreamSubscription<AuthState>? _authStateSubscription;

  void listenAuthentication(BuildContext context) {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
          final session = data.session;
          if (session != null) {
            final user = session.user;
            if (user.emailConfirmedAt != null) {
              // If confirmed, route them through the splash logic which reads local prefs correctly
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
    String email,
  ) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
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
