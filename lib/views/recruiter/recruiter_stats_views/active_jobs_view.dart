// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/sized.dart';
// import '../../../viewmodels/recruiter_stats_detail_viewmodel.dart';
// import '../../../widgets/header_appbar_widget.dart';
// import '../../../widgets/heading_text_widget.dart';
// import '../../../widgets/subtitle_widget.dart';
// import '../recruiter_jobs_view/widgets/jobs_card_widget.dart';
// import '../recruiter_jobs_view/widgets/job_post_shimmer_card.dart';
// import 'package:animate_do/animate_do.dart';

// class ActiveJobsView extends StatefulWidget {
//   const ActiveJobsView({super.key});

//   @override
//   State<ActiveJobsView> createState() => _ActiveJobsViewState();
// }

// class _ActiveJobsViewState extends State<ActiveJobsView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RecruiterStatsDetailViewModel>().fetchActiveJobs();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<RecruiterStatsDetailViewModel>();
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Column(
//           children: [
//             HeaderAppBarWidget(
//               theme: theme,
//               isDark: isDark,
//               showSetting: false,
//               showProfileIcon: false,
//               showLeadingIcon: true,
//             ),
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: vm.fetchActiveJobs,
//                 color: AppColors.lightPrimary,
//                 child: ListView(
//                   padding: AppPadding.dashBoardPadding,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   children: [
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 500),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           HeadingTextWidget(theme: theme, title: 'Active Jobs'),
//                           4.h,
//                           SubTitleWidget(
//                             subTitle: 'All your currently active job posts.',
//                             theme: theme,
//                           ),
//                         ],
//                       ),
//                     ),
//                     24.h,
//                     if (vm.isLoadingJobs && vm.activeJobs.isEmpty)
//                       ...List.generate(
//                         3,
//                         (index) => const Padding(
//                           padding: EdgeInsets.only(bottom: 16),
//                           child: JobPostShimmerCard(),
//                         ),
//                       )
//                     else if (vm.activeJobs.isEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 40),
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.work_off_outlined,
//                                 size: 60,
//                                 color: isDark
//                                     ? AppColors.darkMutedForeground
//                                     : AppColors.lightMutedForeground,
//                               ),
//                               16.h,
//                               Text(
//                                 'No active jobs found.',
//                                 style: theme.textTheme.bodyLarge?.copyWith(
//                                   color: isDark
//                                       ? AppColors.darkMutedForeground
//                                       : AppColors.lightMutedForeground,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     else
//                       ...vm.activeJobs.asMap().entries.map((entry) {
//                         final idx = entry.key;
//                         final job = entry.value;
//                         return FadeInUp(
//                           delay: Duration(milliseconds: 150 + (idx % 5) * 120),
//                           duration: const Duration(milliseconds: 500),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: JobPostCard(
//                               job: job, 
//                                onDelete: () {  }, onEdit: () {  },
//                             ),
//                           ),
//                         );
//                       }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
