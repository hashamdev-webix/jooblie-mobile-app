import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/core/utils/responsive.dart';
import 'package:jooblie_app/viewmodels/reset_password_viewmodel.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/custom_text_field.dart';
import 'package:jooblie_app/widgets/primary_button.dart';
import 'package:jooblie_app/widgets/fade_slide_up.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/core/utils/custom_flushbar.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
          title: 'Update Password',
          backGroundColor: isDark ? AppColors.darkBackground : Colors.white,
          showLeadingIcon: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RoutesName.login);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
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
                        create: (ctx) => ResetPasswordViewModel(),
                        child: Consumer<ResetPasswordViewModel>(
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
                                      Icons.security_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  24.h,
                                  Text(
                                    'Create New Password',
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  8.h,
                                  Text(
                                    'Enter your new secure password below.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  32.h,
                                  CustomTextField(
                                    label: 'New Password',
                                    hintText: '••••••••',
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.next,
                                    validator: viewModel.validatePassword,
                                    onChanged: (value) =>
                                        viewModel.setPassword(value),
                                  ),
                                  20.h,
                                  CustomTextField(
                                    label: 'Confirm Password',
                                    hintText: '••••••••',
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    validator:
                                        viewModel.validateConfirmPassword,
                                    onChanged: (value) =>
                                        viewModel.setConfirmPassword(value),
                                  ),
                                  32.h,
                                  PrimaryButton(
                                    text: 'Update Password',
                                    isLoading: viewModel.isLoading,
                                      onPressed: () async {
                                        final result = await viewModel.updatePassword();

                                        if (result == null && context.mounted) {

                                          // ✅ STEP 1: Force logout (VERY IMPORTANT)
                                          await Supabase.instance.client.auth.signOut();

                                          // ✅ STEP 2: Success message
                                          CustomFlushbar.showSuccess(
                                            context: context,
                                            message: 'Password updated successfully! ✅',
                                          );

                                          // ✅ STEP 3: Navigate to login (clean stack)
                                          Future.delayed(const Duration(seconds: 2), () {
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RoutesName.login,
                                                    (route) => false,
                                              );
                                            }
                                          });

                                        } else if (context.mounted) {
                                          CustomFlushbar.showError(
                                            context: context,
                                            message: result ?? 'Something went wrong',
                                          );
                                        }
                                      }
                                    // onPressed: () async {
                                    //   final result = await viewModel
                                    //       .updatePassword();
                                    //   if (result == null && context.mounted) {
                                    //     CustomFlushbar.showSuccess(
                                    //       context: context,
                                    //       message:
                                    //           'Password updated successfully! ✅',
                                    //     );
                                    //     Future.delayed(
                                    //       const Duration(seconds: 2),
                                    //       () {
                                    //         if (context.mounted) {
                                    //           Navigator.pushNamedAndRemoveUntil(
                                    //             context,
                                    //             RoutesName.login,
                                    //             (route) => false,
                                    //           );
                                    //         }
                                    //       },
                                    //     );
                                    //   } else if (context.mounted) {
                                    //     CustomFlushbar.showError(
                                    //       context: context,
                                    //       message:
                                    //           result ?? 'Something went wrong',
                                    //     );
                                    //   }
                                    // },
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
