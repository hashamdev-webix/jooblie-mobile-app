import 'package:flutter/material.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/sized.dart';
import '../core/utils/responsive.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/fade_slide_up.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilize Responsive bounds
    final cardWidth = Responsive.isTablet || Responsive.isDesktop 
        ? Responsive.w(50) // 50% width on tablet/desktop
        : Responsive.w(90); // 90% width on mobile
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar:AppBarWidget(title: 'Jooblie',
      backGroundColor: Color(0xffFFFFFF),
        showLeadingIcon: false,




      ) ,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradientBackground : AppColors.lightGradientBackground,
        ),
        child: Center(
          child: SingleChildScrollView(
            // padding: EdgeInsets.all(Responsive.w(4)), // 4% screen width padding
            child: Column(
              children: [
                // SizedBox(height: Responsive.h(2)),

                FadeSlideUp(
                  duration: const Duration(milliseconds: 800),
                  yOffset: 30.0,
                  child: Container(
                    width: cardWidth,
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
                    child: ChangeNotifierProvider(
                    create: (_) => LoginViewModel(),
                    child: Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return Form(
                          key: viewModel.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo / Icon
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
                              24.h, // Utilizing Sized extensions

                              // Title & Subtitle
                              Text(
                                'Welcome Back',
                                style: theme.textTheme.headlineMedium,
                              ),
                              8.h,
                              Text(
                                'Sign in to your Jooblie account',
                                style: theme.textTheme.bodyMedium,
                              ),
                              32.h,

                              // Email Field
                              CustomTextField(
                                label: 'Email',
                                hintText: 'you@example.com',
                                prefixIcon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                validator: viewModel.validateEmail,
                                onSaved: (value) => viewModel.setEmail(value ?? ''),
                              ),
                              20.h,

                              // Password Field
                              CustomTextField(
                                label: 'Password',
                                hintText: '••••••••',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                validator: viewModel.validatePassword,
                                onSaved: (value) => viewModel.setPassword(value ?? ''),
                              ),
                              32.h,

                              // Login Button
                              PrimaryButton(
                                text: 'Sign In',
                                isLoading: viewModel.isLoading,
                                onPressed: () async {
                                  final success = await viewModel.login();
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Login Successful!')),
                                    );
                                  }
                                },
                              ),
                              24.h,

                              // Sign Up Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignupScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: AppColors.lightPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: theme.textTheme.bodyMedium?.fontSize,
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
              ],
            ),
        ),
        ),
      ),
    );
  }
}
