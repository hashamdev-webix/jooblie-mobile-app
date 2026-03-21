import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/core/utils/responsive.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/fade_slide_up.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:jooblie_app/viewmodels/verify_email_viewmodel.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    // Delay slightly to ensure provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VerifyEmailViewModel>(context, listen: false)
          .listenAuthentication(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardWidth = Responsive.isTablet || Responsive.isDesktop
        ? Responsive.w(50)
        : Responsive.w(90);

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Verify Email',
        backGroundColor: Color(0xffFFFFFF),
        showLeadingIcon: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkGradientBackground
                  : AppColors.lightGradientBackground,
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FadeSlideUp(
                    duration: const Duration(milliseconds: 800),
                    yOffset: 30.0,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(32.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        border: Border.all(
                          color: isDark ? Colors.black12 : Colors.grey.shade100,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          isDark
                              ? AppColors.shadowCardDark
                              : AppColors.shadowCardLight,
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppColors.gradientPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightPrimary,
                                  blurRadius: 10,
                                  spreadRadius: -2,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.mark_email_unread_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          32.h,
                          Text(
                            'Check Your Email',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          16.h,
                          Text(
                            'We\'ve sent a verification link to:\n${widget.email}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark ? Colors.white70 : AppColors.lightMutedForeground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          32.h,
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade900 : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.grey.shade800 : Colors.blue.shade100,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                                ),
                                16.w,
                                Expanded(
                                  child: Text(
                                    'Please click the link in the email to automatically log in. Don\'t close this screen.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          32.h,
                          Consumer<VerifyEmailViewModel>(
                            builder: (context, viewModel, child) {
                              return PrimaryButton(
                                text: 'Resend Verification Email',
                                onPressed: () {
                                  viewModel.resendVerificationEmail(context, widget.email);
                                },
                              );
                            },
                          ),
                          16.h,
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesName.login,
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Back to Log In',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : AppColors.lightMutedForeground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
