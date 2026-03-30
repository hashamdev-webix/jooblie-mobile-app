import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../viewmodels/job_seeker_jobs_viewmodel.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  bool _hasError = false;

  List<String> _suggestedSearches = [];
  static const String _historyKey = 'job_search_history';

  @override
  void initState() {
    super.initState();
    final vm = context.read<JobSeekerJobsViewModel>();
    _searchController = TextEditingController(text: vm.filters.search ?? '');
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    if (mounted) {
      setState(() {
        _suggestedSearches = history;
      });
    }
  }

  Future<void> _saveSearchToHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];

    // Remove if exists to jump it to the top
    history.removeWhere((s) => s.toLowerCase() == query.toLowerCase());
    history.insert(0, query.trim());

    // Keep only last 10 searches
    if (history.length > 10) history.removeLast();

    await prefs.setStringList(_historyKey, history);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSelected(String query) async {
    final vm = context.read<JobSeekerJobsViewModel>();
    await _saveSearchToHistory(query);
    if (mounted) {
      vm.setSearch(query.isEmpty ? null : query);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Job title, keywords, or company',
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
                  color: (isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary),
                  width: 2.0,
                ),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  hintText: 'Job title, keywords, or company',
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (val) => _onSearchSelected(val),
              ),
            ),
            if (_hasError) ...[
              8.h,
              Row(
                children: [
                  Icon(
                    Icons.error_rounded,
                    color: AppColors.lightError,
                    size: 20,
                  ),
                  8.w,
                  Text(
                    'Add a valid search term.',
                    style: TextStyle(color: AppColors.lightError, fontSize: 13),
                  ),
                ],
              ),
            ],

            25.h,

            // Suggested Searches
            ..._suggestedSearches
                .where(
                  (s) => s.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .map(
                  (suggestion) => FadeInUp(
                    duration: const Duration(milliseconds: 300),
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                      title: Text(
                        suggestion,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _onSearchSelected(suggestion),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
