import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/sized.dart';
import '../../viewmodels/recruiter_dashboard_viewmodel.dart';

class RecruiterCompanyView extends StatelessWidget {
  const RecruiterCompanyView({super.key});

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint,
    IconData? icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      fillColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
      filled: true,
      hintStyle: TextStyle(
        color: isDark
            ? AppColors.darkMutedForeground
            : AppColors.lightMutedForeground,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecruiterCompanyViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: vm.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 120),
            children: [
              // Company Header with animation
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    ZoomIn(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientPrimary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.business_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    20.w,
                    Text(
                      vm.companyName.isEmpty ? 'Company Name' : vm.companyName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              32.h,

              // Form Card
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    boxShadow: [
                      isDark
                          ? AppColors.shadowCardDark
                          : AppColors.shadowCardLight,
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Company Name'),
                      8.h,
                      TextFormField(
                        initialValue: vm.companyName,
                        decoration: _inputDecoration(
                          context,
                          'Your Company',
                          Icons.business_outlined,
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (v) => vm.companyName = v ?? '',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      24.h,

                      _FieldLabel('Website'),
                      8.h,
                      TextFormField(
                        decoration: _inputDecoration(
                          context,
                          'https://yourcompany.com',
                          Icons.language_outlined,
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        onSaved: (v) => vm.website = v ?? '',
                      ),
                      24.h,

                      _FieldLabel('Company Size'),
                      8.h,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: vm.companySize,
                            isExpanded: true,
                            dropdownColor: isDark
                                ? AppColors.darkCard
                                : AppColors.lightCard,
                            style: theme.textTheme.bodyMedium,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.lightMutedForeground,
                            ),
                            items: vm.companySizes
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) vm.setCompanySize(v);
                            },
                          ),
                        ),
                      ),
                      24.h,

                      _FieldLabel('Location'),
                      8.h,
                      TextFormField(
                        decoration: _inputDecoration(
                          context,
                          'City, Country',
                          null,
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (v) => vm.location = v ?? '',
                      ),
                      24.h,

                      _FieldLabel('Industry'),
                      8.h,
                      TextFormField(
                        decoration: _inputDecoration(
                          context,
                          'e.g. Technology, Finance',
                          null,
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (v) => vm.industry = v ?? '',
                      ),
                      24.h,

                      _FieldLabel('About'),
                      8.h,
                      TextFormField(
                        decoration: _inputDecoration(
                          context,
                          'Tell candidates about your company...',
                          null,
                        ),
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        onSaved: (v) => vm.about = v ?? '',
                      ),
                    ],
                  ),
                ),
              ),

              28.h,

              // Save Changes button
              FadeInUp(
                delay: const Duration(milliseconds: 350),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: vm.isLoading
                        ? null
                        : () async {
                            final success = await vm.saveChanges();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Company info saved!'),
                                ),
                              );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (vm.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else ...[
                            const Icon(
                              Icons.save_alt_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            8.w,
                            const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
