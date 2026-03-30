import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/company_model.dart';

class CompaniesViewModel extends ChangeNotifier {
  List<CompanyModel> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CompaniesViewModel() {
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Fetch recruiters from profiles table as the source of truth for companies
      final profilesResponse = await Supabase.instance.client
          .from('profiles')
          .select(
            'company_name, location, about, website, industry, company_size',
          )
          .eq('role', 'recruiter')
          .not('company_name', 'is', null);

      final List<dynamic> profilesData = profilesResponse as List<dynamic>;

      // 2. Fetch active jobs to calculate open job counts per company
      final jobsResponse = await Supabase.instance.client
          .from('jobs')
          .select('company_name')
          .eq('status', 'active');

      final List<dynamic> jobsData = jobsResponse as List<dynamic>;

      // Count active jobs per company name (case-insensitive keys)
      final Map<String, int> jobCounts = {};
      for (var job in jobsData) {
        final cName =
            job['company_name']?.toString()?.trim()?.toLowerCase() ?? '';
        if (cName.isNotEmpty) {
          jobCounts[cName] = (jobCounts[cName] ?? 0) + 1;
        }
      }

      // Map recruiter profiles to CompanyModel, ensuring uniqueness by company_name
      final Map<String, CompanyModel> uniqueCompanies = {};

      for (var profile in profilesData) {
        final name =
            profile['company_name']?.toString()?.trim() ?? 'Unknown Company';
        final lookupName = name.toLowerCase();
        final location =
            profile['location']?.toString()?.trim() ?? 'Not specified';

        if (name.isNotEmpty && !uniqueCompanies.containsKey(lookupName)) {
          uniqueCompanies[lookupName] = CompanyModel(
            name: name,
            location: location,
            openJobsCount: jobCounts[lookupName] ?? 0,
            about: profile['about']?.toString(),
            website: profile['website']?.toString(),
            industry: profile['industry']?.toString(),
            companySize: profile['company_size']?.toString(),
          );
        }
      }

      _companies = uniqueCompanies.values.toList();

      // Sort: Companies with active jobs first, then by name
      _companies.sort((a, b) {
        if (b.openJobsCount != a.openJobsCount) {
          return b.openJobsCount.compareTo(a.openJobsCount);
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } catch (e) {
      debugPrint('Error fetching companies from profiles: $e');
      _error = 'Failed to load companies.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches all active jobs for a specific company name (case-insensitive)
  Future<List<Map<String, dynamic>>> fetchCompanyJobs(
    String companyName,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('jobs')
          .select('*')
          .ilike('company_name', companyName)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error fetching jobs for company $companyName: $e');
      return [];
    }
  }
}
