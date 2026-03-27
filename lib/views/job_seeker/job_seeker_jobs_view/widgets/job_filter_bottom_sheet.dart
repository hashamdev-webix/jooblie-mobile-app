import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../models/job_filters_model.dart';
import '../../../../viewmodels/job_seeker_jobs_viewmodel.dart';
import '../../../../core/sized.dart';

class JobFilterBottomSheet extends StatefulWidget {
  const JobFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const JobFilterBottomSheet(),
    );
  }

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  late JobFilters _localFilters;

  @override
  void initState() {
    super.initState();
    _localFilters = context.read<JobSeekerJobsViewModel>().filters;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _localFilters = const JobFilters();
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          24.h,

          // Job Type
          const Text('Job Type', style: TextStyle(fontWeight: FontWeight.bold)),
          12.h,
          Wrap(
            spacing: 8,
            children: [
              _buildChip('Full-time', 'Full-time'),
              _buildChip('Part-time', 'Part-time'),
              _buildChip('Contract', 'Contract'),
              _buildChip('Remote', 'Remote'),
            ],
          ),
          24.h,

          // Experience
          const Text('Experience Level', style: TextStyle(fontWeight: FontWeight.bold)),
          12.h,
          Wrap(
            spacing: 8,
            children: [
              _buildExpChip('Entry', 'Junior'),
              _buildExpChip('Intermediate', 'Mid-level'),
              _buildExpChip('Senior', 'Senior'),
            ],
          ),
          24.h,

          // Salary Range (Quick selection chips or slider)
          const Text('Min Salary', style: TextStyle(fontWeight: FontWeight.bold)),
          12.h,
          Wrap(
            spacing: 8,
            children: [
              _buildSalaryChip('All', null),
              _buildSalaryChip("${'30k+'}", 30000),
              _buildSalaryChip('${'60k+'}', 60000),
              _buildSalaryChip('${'100k+'}', 100000),
            ],
          ),
          24.h,

          const Text('Max Salary', style: TextStyle(fontWeight: FontWeight.bold)),
          12.h,
          Wrap(
            spacing: 8,
            children: [
              _buildMaxSalaryChip('All', null),
              _buildMaxSalaryChip('Up to ${'80k'}', 80000),
              _buildMaxSalaryChip('Up to ${'150k'}', 150000),
              _buildMaxSalaryChip('Up to ${'250k'}', 250000),
            ],
          ),
          32.h,

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                context.read<JobSeekerJobsViewModel>().applyFilters(_localFilters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _localFilters.jobType == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(jobType: selected ? value : null);
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.lightPrimary : null,
      ),
    );
  }

  Widget _buildExpChip(String label, String value) {
    final isSelected = _localFilters.experience == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(experience: selected ? value : null);
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.lightPrimary : null,
      ),
    );
  }

  Widget _buildSalaryChip(String label, int? value) {
    final isSelected = _localFilters.minSalary == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(minSalary: selected ? value : null);
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.lightPrimary : null,
      ),
    );
  }

  Widget _buildMaxSalaryChip(String label, int? value) {
    final isSelected = _localFilters.maxSalary == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(maxSalary: selected ? value : null);
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.lightPrimary : null,
      ),
    );
  }
}
