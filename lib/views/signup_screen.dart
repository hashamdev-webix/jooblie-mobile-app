import 'package:flutter/material.dart';
import 'package:jooblie_app/views/main_dashboard_screen.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/gradient_style_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/core/utils/custom_flushbar.dart';
import '../core/app_colors.dart';
import '../core/sized.dart';
import '../core/utils/responsive.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/segmented_control.dart';
import '../widgets/fade_slide_up.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
        appBar: AppBarWidget(title: "", showAppLogo: false),
        // appBar: const AppBarWidget(title: "Jooblie", showLeadingIcon: false),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.darkGradientBackground
                    : AppColors.lightGradientBackground,
              ),
            ),
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkGradientBackground
                      : AppColors.lightGradientBackground,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: Responsive.w(4),
                      ),

                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              FadeSlideUp(
                                duration: const Duration(milliseconds: 800),
                                yOffset: 30.0,
                                child: Container(
                                  width: cardWidth,
                                  padding: const EdgeInsets.all(25.0),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    border: Border.all(
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.black12
                                          : Colors.grey.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      isDark
                                          ? AppColors.shadowCardDark
                                          : AppColors.shadowCardLight,
                                    ],
                                  ),
                                  child: ChangeNotifierProvider(
                                    create: (ctx) => SignupViewModel(
                                      authViewModel: Provider.of<AuthViewModel>(
                                        ctx,
                                        listen: false,
                                      ),
                                    ),
                                    child: Consumer<SignupViewModel>(
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
                                                  gradient:
                                                      AppColors.gradientPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.work_outline,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              ),
                                              24.h,
                                              Text(
                                                'Create Account',
                                                style: theme
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                              8.h,
                                              Text(
                                                'Join Jooblie and start your journey',
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                              24.h,
                                              SegmentedControl(
                                                isJobSeeker:
                                                    viewModel.isJobSeeker,
                                                onChanged: viewModel.setRole,
                                              ),
                                              24.h,
                                              CustomTextField(
                                                label: 'Full Name',
                                                hintText: 'John Doe',
                                                prefixIcon:
                                                    Icons.person_outline,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator:
                                                    viewModel.validateName,
                                                onSaved: (value) => viewModel
                                                    .setFullName(value ?? ''),
                                              ),
                                              20.h,
                                              AnimatedSize(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                                child: !viewModel.isJobSeeker
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 20.0,
                                                            ),
                                                        child: CustomTextField(
                                                          label: 'Company Name',
                                                          hintText:
                                                              'Your Company',
                                                          prefixIcon: Icons
                                                              .business_outlined,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator: viewModel
                                                              .validateCompanyName,
                                                          onSaved: (value) =>
                                                              viewModel
                                                                  .setCompanyName(
                                                                    value ?? '',
                                                                  ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ),
                                              CustomTextField(
                                                label: 'Email',
                                                hintText: 'you@example.com',
                                                prefixIcon: Icons.mail_outline,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator:
                                                    viewModel.validateEmail,
                                                onSaved: (value) => viewModel
                                                    .setEmail(value ?? ''),
                                              ),
                                              20.h,
                                              CustomTextField(
                                                label: 'Password',
                                                hintText: '••••••••',
                                                prefixIcon: Icons.lock_outline,
                                                isPassword: true,
                                                textInputAction:
                                                    TextInputAction.done,
                                                validator:
                                                    viewModel.validatePassword,
                                                onSaved: (value) => viewModel
                                                    .setPassword(value ?? ''),
                                              ),
                                              32.h,
                                              PrimaryButton(
                                                text: 'Create Account',
                                                isLoading: viewModel.isLoading,
                                                onPressed: () async {
                                                  final result = await viewModel
                                                      .register();
                                                  if (result == null &&
                                                      context.mounted) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Account created successfully!",
                                                    );
                                                    final prefs =
                                                        await SharedPreferences.getInstance();
                                                    final isJobSeeker =
                                                        prefs.getBool(
                                                          'is_job_seeker',
                                                        ) ??
                                                        true;

                                                    if (context.mounted) {
                                                      Navigator.of(
                                                        context,
                                                      ).pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              MainDashboardScreen(
                                                                isJobSeeker:
                                                                    isJobSeeker,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  } else if (result ==
                                                          'verify_email' &&
                                                      context.mounted) {
                                                    CustomFlushbar.showSuccess(
                                                      context: context,
                                                      message:
                                                          "Verification email sent! Please check your inbox 📩",
                                                    );
                                                    Navigator.pushNamedAndRemoveUntil(
                                                      context,
                                                      RoutesName.login,
                                                      (route) => false,
                                                    );
                                                  } else if (context.mounted) {
                                                    CustomFlushbar.showError(
                                                      context: context,
                                                      message:
                                                          result ??
                                                          'Signup failed',
                                                    );
                                                  }
                                                },
                                              ),
                                              24.h,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Already have an account? ",
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        GradientStyleTextWidget(
                                                          title: "Sign in",
                                                          fontSize: 13,
                                                        ),
                                                    // child: Text(
                                                    //   'Sign in',
                                                    //   style: TextStyle(
                                                    //     color: AppColors
                                                    //         .lightPrimary,
                                                    //     fontWeight:
                                                    //         FontWeight.w600,
                                                    //     fontSize: theme
                                                    //         .textTheme
                                                    //         .bodyMedium
                                                    //         ?.fontSize,
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
