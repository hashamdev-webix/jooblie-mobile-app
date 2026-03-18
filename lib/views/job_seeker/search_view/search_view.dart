import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasError = false;

  final List<String> _recentSearches = [
    'Flutter developer',
    'Flutter developer',
    'dubizzle labs',
  ];

  final List<String> _suggestedSearches = [
    'part time',
    'hiring immediately',
    'full time',
  ];

  void _onSearch() {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _hasError = false;
      });
      // Handle actual search logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 24, color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onSubmitted: (_) => _onSearch(),
              ),
            ),
            if (_hasError) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                   Icon(Icons.error_rounded, color: AppColors.lightError, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add a valid search term.',
                    style: TextStyle(color: AppColors.lightError, fontSize: 13),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Recent Searches Section
            ..._recentSearches.map((search) => _SearchHistoryItem(
              title: search,
              location: 'Lahore', // Placeholder
              isDark: isDark,
              onDelete: () {
                setState(() {
                  _recentSearches.remove(search);
                });
              },
            )),

            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'More recent searches',
                  style: TextStyle(
                    color: Color(0xff00509A), // Indeed blue
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Suggested Searches
            ..._suggestedSearches.map((suggestion) => ListTile(
              leading: const Icon(Icons.search),
              title: Text(suggestion),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _searchController.text = suggestion;
                _onSearch();
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _SearchHistoryItem extends StatelessWidget {
  final String title;
  final String location;
  final bool isDark;
  final VoidCallback onDelete;

  const _SearchHistoryItem({
    required this.title,
    required this.location,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '0 new in $location',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.black45),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
