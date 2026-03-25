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
      final response = await Supabase.instance.client
          .from('jobs')
          .select('company_name, location, status')
          .eq('status', 'active');

      final List<dynamic> data = response as List<dynamic>;
      
      final Map<String, CompanyModel> grouped = {};

      for (var item in data) {
        final name = (item['company_name'] as String?)?.trim() ?? 'Unknown Company';
        final location = (item['location'] as String?)?.trim() ?? 'Not specified';

        if (grouped.containsKey(name)) {
          final existing = grouped[name]!;
          grouped[name] = CompanyModel(
            name: name,
            location: (existing.location == 'Not specified' && location != 'Not specified') ? location : existing.location,
            openJobsCount: existing.openJobsCount + 1,
          );
        } else {
          grouped[name] = CompanyModel(
            name: name,
            location: location,
            openJobsCount: 1,
          );
        }
      }

      _companies = grouped.values.toList();
      _companies.sort((a, b) => b.openJobsCount.compareTo(a.openJobsCount));

    } catch (e) {
      debugPrint('Error fetching companies: $e');
      _error = 'Failed to load companies.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
