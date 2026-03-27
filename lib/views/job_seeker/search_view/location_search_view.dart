import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/job_seeker_jobs_viewmodel.dart';

class LocationSearchView extends StatefulWidget {
  const LocationSearchView({super.key});

  @override
  State<LocationSearchView> createState() => _LocationSearchViewState();
}

class _LocationSearchViewState extends State<LocationSearchView> {
  late TextEditingController _locationController;
  bool _hasError = false;

  final List<String> _popularCities = [
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Karachi',
    'Faisalabad',
    'Khushab',
  ];

  @override
  void initState() {
    super.initState();
    final vm = context.read<JobSeekerJobsViewModel>();
    _locationController = TextEditingController(text: vm.filters.location ?? '');
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _onLocationSelected(String location) {
    final vm = context.read<JobSeekerJobsViewModel>();
    vm.setLocation(location.isEmpty ? null : location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vm = context.watch<JobSeekerJobsViewModel>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'City, state, zip code, or remote',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.h,
            // Search Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasError ? AppColors.lightError : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _locationController,
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on, size: 24, color: isDark ? Colors.white70 : Colors.black87),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  hintText: 'Search city or state',
                ),
                onSubmitted: (val) => _onLocationSelected(val),
              ),
            ),
            if (_hasError) ...[
              8.h,
              Row(
                children: [
                  Icon(Icons.error_rounded, color: AppColors.lightError, size: 20),
                  8.w,
                  Text(
                    'Add a valid city and state.',
                    style: TextStyle(color: AppColors.lightError, fontSize: 13),
                  ),
                ],
              ),
            ],

            25.h,

            // Current Location Row
            InkWell(
              onTap: () async {
                await vm.fetchCurrentLocation();
                if (vm.error != null && vm.error!.isNotEmpty && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(vm.error!),
                      backgroundColor: AppColors.lightError,
                    ),
                  );
                } else if (vm.filters.location != null && context.mounted) {
                   Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.my_location_rounded, color: AppColors.lightPrimary, size: 24),
                    16.w,
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            15.h,

            // Popular Cities
            ..._popularCities.map((city) => FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: ListTile(
                leading: Icon(Icons.location_on_outlined, color: isDark ? Colors.white54 : Colors.black45),
                title: Text(
                  city,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => _onLocationSelected(city),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
