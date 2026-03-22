import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_recommendation_model.dart';
import '../models/job_filters_model.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class JobSeekerJobsViewModel extends ChangeNotifier {
  List<JobRecommendationModel> _jobs = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMore = true;
  String? error;

  JobFilters _filters = const JobFilters();
  int _page = 0;
  static const int _limit = 20;

  // Search/Location Hints/Values
  String searchHint = 'Search';
  String locationHint = 'City, state, zip co...';

  JobSeekerJobsViewModel() {
    fetchJobs(refresh: true);
  }

  List<JobRecommendationModel> get jobs => _jobs;
  JobFilters get filters => _filters;

  /// Apply new filters and reload
  void applyFilters(JobFilters newFilters) {
    _filters = newFilters.copyWith(page: 1);
    fetchJobs(refresh: true);
  }

  /// Reset all filters and reload
  void resetFilters() {
    _filters = const JobFilters();
    searchHint = 'Search';
    locationHint = 'City, state, zip co...';
    fetchJobs(refresh: true);
  }

  /// Update search query and reload
  void setSearch(String? query) {
    _filters = _filters.copyWith(search: query, page: 1);
    searchHint = query ?? 'Search';
    fetchJobs(refresh: true);
  }

  /// Update location filter and reload
  void setLocation(String? location) {
    _filters = _filters.copyWith(location: location, page: 1);
    locationHint = location ?? 'City, state, zip co...';
    fetchJobs(refresh: true);
  }

  /// Fetch current location using geolocator
  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    isLoading = true;
    notifyListeners();

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        error = 'Location services are disabled.';
        isLoading = false;
        notifyListeners();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          error = 'Location permissions are denied';
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        error = 'Location permissions are permanently denied.';
        isLoading = false;
        notifyListeners();
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? 'My Location';
        setLocation(city);
      } else {
        setLocation('My Location');
      }
    } catch (e) {
      error = 'Failed to get location: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _jobs = [];
      hasMore = true;
      isLoading = true;
      error = null;
      notifyListeners();
    } else {
      if (!hasMore || isFetchingMore) return;
      isFetchingMore = true;
      notifyListeners();
    }

    try {
      // Start building the query
      var filterQuery = Supabase.instance.client
          .from('jobs')
          .select()
          .eq('status', 'active'); // only show active jobs to seekers

      // Search — ilike across title, description, and company_name
      if (_filters.search != null && _filters.search!.isNotEmpty) {
        filterQuery = filterQuery.or(
          'title.ilike.%${_filters.search}%,description.ilike.%${_filters.search}%,company_name.ilike.%${_filters.search}%',
        );
      }

      // Location filter (if not "My Location" placeholder)
      if (_filters.location != null && _filters.location != 'My Location' && _filters.location!.isNotEmpty) {
        filterQuery = filterQuery.ilike('location', '%${_filters.location}%');
      }

      // Job type filter
      if (_filters.jobType != null && _filters.jobType!.isNotEmpty) {
        // Map UI labels to DB values if needed
        filterQuery = filterQuery.eq('job_type', _filters.jobType!);
      }

      // Experience filter
      if (_filters.experience != null && _filters.experience!.isNotEmpty) {
        filterQuery = filterQuery.eq('experience', _filters.experience!);
      }

      // Salary filters (stored as text in DB — compare numerically if possible)
      if (_filters.minSalary != null) {
        filterQuery = filterQuery.gte('salary_min', _filters.minSalary.toString());
      }
      if (_filters.maxSalary != null) {
        filterQuery = filterQuery.lte('salary_max', _filters.maxSalary.toString());
      }

      // Apply Transforms (Order and Range) last as they change type to PostgrestTransformBuilder
      final sortColumn = _filters.sortBy ?? 'created_at';
      final ascending = (_filters.order ?? 'desc') == 'asc';

      final response = await filterQuery
          .order(sortColumn, ascending: ascending)
          .range(_page * _limit, (_page + 1) * _limit - 1);
      final List<dynamic> data = response as List<dynamic>;

      // Skills filter — done client-side since Supabase array contains all
      List<JobRecommendationModel> newJobs = data
          .map((json) => JobRecommendationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (_filters.skills != null && _filters.skills!.isNotEmpty) {
        newJobs = newJobs.where((job) {
          return _filters.skills!.any(
            (skill) => job.tags.any(
              (tag) => tag.toLowerCase().contains(skill.toLowerCase()),
            ),
          );
        }).toList();
      }

      if (data.length < _limit) hasMore = false;

      _jobs.addAll(newJobs);
      _page++;
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
      error = 'Failed to load jobs.';
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }
}
