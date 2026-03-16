import 'package:flutter/material.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBarWidget(title: "Joobli",
      showLeadingIcon: false,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Responsive.h(15)),
                FadeSlideUp(
                  duration: const Duration(milliseconds: 800),
                  yOffset: 30.0,
                  child: Container(
                    width: cardWidth,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(32.0),
            
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(
                        color:theme.brightness == Brightness.dark ? Colors.black12: Colors.grey.shade100,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
            
            
                        isDark ? AppColors.shadowCardDark : AppColors.shadowCardLight,
            
            
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: ChangeNotifierProvider(
                        create: (_) => SignupViewModel(),
                        child: Consumer<SignupViewModel>(
                          builder: (context, viewModel, child) {
                            return Form(
                              key: viewModel.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Logo
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.gradientPrimary,
                                      borderRadius: BorderRadius.circular(16),
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
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  8.h,
                                  Text(
                                    'Join Jooblie and start your journey',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  24.h,
                                  SegmentedControl(
                                    isJobSeeker: viewModel.isJobSeeker,
                                    onChanged: viewModel.setRole,
                                  ),
                                  24.h,
                                  CustomTextField(
                                    label: 'Full Name',
                                    hintText: 'John Doe',
                                    prefixIcon: Icons.person_outline,
                                    validator: viewModel.validateName,
                                    onSaved: (value) =>
                                        viewModel.setFullName(value ?? ''),
                                  ),
                                  20.h,
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: !viewModel.isJobSeeker
                                        ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20.0,
                                      ),
                                      child: CustomTextField(
                                        label: 'Company Name',
                                        hintText: 'Your Company',
                                        prefixIcon: Icons.business_outlined,
                                        validator:
                                        viewModel.validateCompanyName,
                                        onSaved: (value) => viewModel
                                            .setCompanyName(value ?? ''),
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                  ),
                                  CustomTextField(
                                    label: 'Email',
                                    hintText: 'you@example.com',
                                    prefixIcon: Icons.mail_outline,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: viewModel.validateEmail,
                                    onSaved: (value) =>
                                        viewModel.setEmail(value ?? ''),
                                  ),
                                  20.h,
                                  CustomTextField(
                                    label: 'Password',
                                    hintText: '••••••••',
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
                                    validator: viewModel.validatePassword,
                                    onSaved: (value) =>
                                        viewModel.setPassword(value ?? ''),
                                  ),
                                  32.h,
                                  PrimaryButton(
                                    text: 'Create Account',
                                    isLoading: viewModel.isLoading,
                                    onPressed: () async {
                                      final success = await viewModel.register();
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Account Created!'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  24.h,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account? ",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Sign in',
                                          style: TextStyle(
                                            color: AppColors.lightPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize,
                                          ),
                                        ),
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
                ),
                SizedBox(height: Responsive.h(20)),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
