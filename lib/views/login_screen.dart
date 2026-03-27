import 'package:flutter/material.dart';
import 'package:jooblie_app/viewmodels/auth_viewmodel.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:jooblie_app/widgets/gradient_style_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jooblie_app/core/utils/custom_flushbar.dart';
import '../core/app_colors.dart';
import '../core/sized.dart';
import '../core/utils/responsive.dart';
import '../viewmodels/login_viewmodel.dart';
import '../core/utils/routes_name.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/fade_slide_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
        appBar: const AppBarWidget(
          title: 'Jooblie',
          backGroundColor: Color(0xffFFFFFF),
          showLeadingIcon: false,
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
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  width: double.infinity,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppColors.darkGradientBackground
                        : AppColors.lightGradientBackground,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // AppLogo(),
                                FadeSlideUp(
                                  duration: const Duration(milliseconds: 800),
                                  yOffset: 30.0,
                                  child: Container(
                                    width: cardWidth,
                                    padding: const EdgeInsets.all(25.0),
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      border: Border.all(
                                        color:
                                            theme.brightness == Brightness.dark
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
                                      create: (ctx) => LoginViewModel(authViewModel: Provider.of<AuthViewModel>(ctx, listen: false)),
                                      child: Consumer<LoginViewModel>(
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
                                                    gradient: AppColors
                                                        .gradientPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.work_outline,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                ),
                                                24.h,
                                                Text(
                                                  'Welcome Back',
                                                  style: theme
                                                      .textTheme
                                                      .headlineMedium,
                                                ),
                                                8.h,
                                                Text(
                                                  'Sign in to your Jooblie account',
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                32.h,
                                                CustomTextField(
                                                  enabled: !viewModel.isLoading,
                                                  label: 'Email',
                                                  hintText: 'you@example.com',
                                                  prefixIcon:
                                                      Icons.mail_outline,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator:
                                                      viewModel.validateEmail,
                                                  onSaved: (value) => viewModel
                                                      .setEmail(value ?? ''),
                                                ),
                                                20.h,
                                                CustomTextField(
                                                  enabled: !viewModel.isLoading,
                                                  label: 'Password',
                                                  hintText: '••••••••',
                                                  prefixIcon:
                                                      Icons.lock_outline,
                                                  isPassword: true,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  validator: viewModel
                                                      .validatePassword,
                                                  onSaved: (value) => viewModel
                                                      .setPassword(value ?? ''),
                                                ),
                                                8.h,
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        RoutesName.forgotPassword,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(
                                                        color: AppColors.lightPrimary,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                24.h,
                                                PrimaryButton(
                                                  text: 'Sign In',
                                                  isLoading:
                                                      viewModel.isLoading,
                                                  onPressed: () async {
                                                    final result =
                                                        await viewModel.login();
                                                      if (result == null &&
                                                          context.mounted) {
                                                        Fluttertoast.showToast(msg: "Login successful!");
                                                        
                                                        if (context.mounted) {
                                                          Navigator.pushReplacementNamed(
                                                            context,
                                                            RoutesName.dashboard,
                                                            arguments: {
                                                              'isJobSeeker': viewModel.isJobSeeker,
                                                            },
                                                          );
                                                        }
                                                      } else if (context.mounted) {
                                                        CustomFlushbar.showError(
                                                          context: context, 
                                                          message: result ?? 'Login failed',
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
                                                      "Don't have an account? ",
                                                      style: theme
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          RoutesName.signup,
                                                        );
                                                      },
                                                      child:
                                                          GradientStyleTextWidget(
                                                            title: "Sign Up",
                                                            fontSize: 13,
                                                          ),
                                                      // child: Text(
                                                      //   'Sign up',
                                                      //   style: TextStyle(
                                                      //     color: AppColors.lightPrimary,
                                                      //     fontWeight: FontWeight.w600,
                                                      //     fontSize: theme
                                                      //         .textTheme.bodyMedium?.fontSize,
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
            ),
          ],
        ),
      ),
    );
  }
}
