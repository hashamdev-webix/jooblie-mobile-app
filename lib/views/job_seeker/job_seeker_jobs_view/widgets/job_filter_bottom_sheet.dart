import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';
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
  bool _isCustomSalary = false;

  @override
  void initState() {
    super.initState();
    _localFilters = context.read<JobSeekerJobsViewModel>().filters;
    
    final min = _localFilters.minSalary;
    final max = _localFilters.maxSalary;
    final isMinPreset = min == null || min == 30000 || min == 60000 || min == 100000;
    final isMaxPreset = max == null || max == 80000 || max == 150000 || max == 250000;
    
    if (!isMinPreset || !isMaxPreset) {
      _isCustomSalary = true;
    }
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
                    _isCustomSalary = false;
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
          const Text(
            'Experience Level',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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

          // Salary Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Salary Range',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isCustomSalary = !_isCustomSalary;
                  });
                },
                child: Text(
                  _isCustomSalary ? 'Use Presets' : 'Custom',
                  style: TextStyle(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          16.h,
          if (_isCustomSalary) ...[
            32.h,
            SfRangeSliderTheme(
              data: SfRangeSliderThemeData(
                activeTrackColor: AppColors.lightPrimary,
                inactiveTrackColor: AppColors.lightPrimary.withValues(alpha: 0.2),
                thumbColor: AppColors.lightPrimary,
                activeLabelStyle: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
                inactiveLabelStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 12,
                ),
                tooltipBackgroundColor: AppColors.lightPrimary,
                tooltipTextStyle: const TextStyle(color: Colors.white),
              ),
              child: SfRangeSlider(
                min: 0.0,
                max: 300000.0,
                stepSize: 5000,
                values: SfRangeValues(
                  (_localFilters.minSalary ?? 0).toDouble(),
                  (_localFilters.maxSalary ?? 300000).toDouble(),
                ),
                interval: 100000.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                numberFormat: NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0),
                onChanged: (SfRangeValues newValues) {
                  setState(() {
                    _localFilters = _localFilters.copyWith(
                      minSalary: newValues.start.toInt(),
                      maxSalary: newValues.end.toInt(),
                    );
                  });
                },
              ),
            ),
            16.h,
          ] else ...[
            const Text(
              'Min Salary',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            8.h,
            Wrap(
              spacing: 8,
              children: [
                _buildSalaryChip('All', null),
                _buildSalaryChip('30k+', 30000),
                _buildSalaryChip('60k+', 60000),
                _buildSalaryChip('100k+', 100000),
              ],
            ),
            16.h,
            const Text(
              'Max Salary',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            8.h,
            Wrap(
              spacing: 8,
              children: [
                _buildMaxSalaryChip('All', null),
                _buildMaxSalaryChip('Up to 80k', 80000),
                _buildMaxSalaryChip('Up to 150k', 150000),
                _buildMaxSalaryChip('Up to 250k', 250000),
              ],
            ),
          ],
          24.h,

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                context.read<JobSeekerJobsViewModel>().applyFilters(
                  _localFilters,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
          _localFilters = _localFilters.copyWith(
            jobType: selected ? value : null,
          );
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.lightPrimary : null),
    );
  }

  Widget _buildExpChip(String label, String value) {
    final isSelected = _localFilters.experience == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(
            experience: selected ? value : null,
          );
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.lightPrimary : null),
    );
  }

  Widget _buildSalaryChip(String label, int? value) {
    final isSelected = _localFilters.minSalary == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(
            minSalary: selected ? value : null,
          );
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.lightPrimary : null),
    );
  }

  Widget _buildMaxSalaryChip(String label, int? value) {
    final isSelected = _localFilters.maxSalary == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _localFilters = _localFilters.copyWith(
            maxSalary: selected ? value : null,
          );
        });
      },
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.lightPrimary : null),
    );
  }
}