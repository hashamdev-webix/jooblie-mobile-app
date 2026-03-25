import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/app_colors.dart';
import '../../../core/sized.dart';
import '../../../viewmodels/companies_viewmodel.dart';
import '../../../widgets/header_appbar_widget.dart';
import '../../../core/utils/my_slide_animation.dart';
import '../../../models/company_model.dart';
import '../../../widgets/custom_shimmer_widget.dart';

class CompaniesView extends StatelessWidget {
  const CompaniesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkGradientBackground
                : AppColors.lightGradientBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAppBarWidget(
                  theme: theme, isDark: isDark, blackTitle: 'Job', blueTitle: 'lie'),
              Expanded(
                child: Consumer<CompaniesViewModel>(
                  builder: (context, vm, child) {
                    if (vm.isLoading) {
                      return _buildShimmerLoading(isDark);
                    }
                    if (vm.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                            16.h,
                            Text(vm.error!, style: theme.textTheme.bodyLarge),
                            16.h,
                            ElevatedButton(
                              onPressed: vm.fetchCompanies,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (vm.companies.isEmpty) {
                      return RefreshIndicator(
                         onRefresh: vm.fetchCompanies,
                        child: ListView(
                          children:[
                             SizedBox(
                               height: MediaQuery.of(context).size.height * 0.6,
                               child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.business_center_outlined, size: 64, color: isDark ? AppColors.darkMuted : Colors.grey[400]),
                                    16.h,
                                    Text('No companies hiring right now.', 
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: isDark ? AppColors.darkMutedForeground : Colors.grey[600],
                                      )
                                    ),
                                  ],
                                ),
                            ),
                             ),
                          ]
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: vm.fetchCompanies,
                      color: AppColors.lightPrimary,
                      child: ListView(
                        padding: AppPadding.dashBoardPadding,
                        children: [
                          FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Top '),
                                      TextSpan(
                                        text: 'Companies',
                                        style: TextStyle(
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: [Colors.blue, Colors.cyan],
                                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                        ),
                                      ),
                                      const TextSpan(text: ' Hiring'),
                                    ],
                                  ),
                                ),
                                12.h,
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Explore leading companies and discover amazing career opportunities.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? AppColors.darkMutedForeground : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          32.h,
                          ...vm.companies.asMap().entries.map((entry) {
                            final index = entry.key;
                            final company = entry.value;
                            return MySlideTransition(
                              delay: index * 100,
                              child: CompanyCard(company: company),
                            );
                          }),
                          100.h, // Bottom padding for tabs
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    return ListView(
      padding: AppPadding.dashBoardPadding,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomShimmerWidget.rectangular(
                height: 32,
                width: 250,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              12.h,
              CustomShimmerWidget.rectangular(
                height: 16,
                width: 280,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
        32.h,
        ...List.generate(5, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomShimmerWidget.rectangular(
            height: 180,
            isDark: isDark,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        )),
      ],
    );
  }
}

class CompanyCard extends StatelessWidget {
  final CompanyModel company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          if (!isDark) AppColors.shadowCardLight,
          if (isDark) AppColors.shadowCardDark,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.business_rounded, color: Colors.blue, size: 30),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${company.openJobsCount} open job${company.openJobsCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          20.h,
          Text(
            company.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          6.h,
          Text(
            'Hiring now on Jooblie.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkMutedForeground : Colors.grey[600],
            ),
          ),
          20.h,
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          16.h,
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.blue[400]),
              6.w,
              Expanded(
                child: Text(
                  company.location,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              12.w,
              Icon(Icons.groups_outlined, size: 16, color: Colors.blue[400]),
              6.w,
              Text(
                'Active Hiring',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
