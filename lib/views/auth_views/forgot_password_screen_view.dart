import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/core/utils/responsive.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:jooblie_app/viewmodels/forgot_password_viewmodel.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/custom_text_field.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:jooblie_app/widgets/fade_slide_up.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/core/utils/custom_flushbar.dart';

class ForgotPasswordScreenView extends StatelessWidget {
  const ForgotPasswordScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = Responsive.isTablet || Responsive.isDesktop
        ? Responsive.w(50)
        : Responsive.w(90);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBarWidget(
          title: 'Forgot Password',
          backGroundColor: isDark ? AppColors.darkBackground : Colors.white,
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
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeSlideUp(
                    duration: const Duration(milliseconds: 800),
                    yOffset: 30.0,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        border: Border.all(
                          color: isDark ? Colors.black12 : Colors.grey.shade100,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          isDark
                              ? AppColors.shadowCardDark
                              : AppColors.shadowCardLight,
                        ],
                      ),
                      child: ChangeNotifierProvider(
                        create: (ctx) => ForgotPasswordViewModel(
                          authViewModel: Provider.of<AuthViewModel>(
                            ctx,
                            listen: false,
                          ),
                        ),
                        child: Consumer<ForgotPasswordViewModel>(
                          builder: (context, viewModel, child) {
                            return Form(
                              key: viewModel.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.gradientPrimary,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.lock_reset_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  24.h,
                                  Text(
                                    'Reset Password',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  8.h,
                                  Text(
                                    'Enter your email to receive a password reset link',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  32.h,
                                  CustomTextField(
                                    label: 'Email',
                                    hintText: 'you@example.com',
                                    prefixIcon: Icons.mail_outline,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    validator: viewModel.validateEmail,
                                    onSaved: (value) =>
                                        viewModel.setEmail(value ?? ''),
                                  ),
                                  32.h,
                                  PrimaryButton(
                                    text: 'Send Reset Link',
                                    isLoading: viewModel.isLoading,
                                    onPressed: () async {
                                      final result = await viewModel
                                          .sendResetLink();
                                      if (result == null && context.mounted) {
                                        CustomFlushbar.showSuccess(
                                          context: context,
                                          message:
                                              'Reset link sent! Check your email.',
                                        );
                                        // Navigate to Verify Email screen
                                        Future.delayed(
                                          const Duration(seconds: 1),
                                          () {
                                            if (context.mounted) {
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.verifyEmail,
                                                arguments: {
                                                  'email': viewModel.email,
                                                  'isFromForgotPassword': true,
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } else if (context.mounted) {
                                        CustomFlushbar.showError(
                                          context: context,
                                          message:
                                              result ?? 'Something went wrong',
                                        );
                                      }
                                    },
                                  ),
                                  16.h,
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Back to Login',
                                      style: TextStyle(
                                        color: AppColors.lightPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
