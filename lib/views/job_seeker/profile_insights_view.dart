import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/repositories/jobseeker_repository.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ProfileInsightsView extends StatefulWidget {
  const ProfileInsightsView({super.key});

  @override
  State<ProfileInsightsView> createState() => _ProfileInsightsViewState();
}

class _ProfileInsightsViewState extends State<ProfileInsightsView> {
  final JobseekerRepository _repository = JobseekerRepository();
  bool _isLoading = true;
  List<Map<String, dynamic>> _views = [];

  @override
  void initState() {
    super.initState();
    _fetchInsights();
  }

  Future<void> _fetchInsights() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final views = await _repository.getDetailedProfileViews(user.id);
      if (mounted) {
        setState(() {
          _views = views;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(title: "Profile Insights", showAppLogo: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchInsights,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildSummaryCard(theme, isDark),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final view = _views[index];
                            return _buildViewerTile(view, theme, isDark);
                          },
                          childCount: _views.length,
                        ),
                      ),
                    ),
                    if (_views.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: Text("No views yet. Keep sharing your profile!"),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Text(
            "${_views.length}",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total Profile Views",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Companies", _countUnique('viewer_company'), theme),
              _buildStatItem("Roles", _countUnique('viewer_role'), theme),
              _buildStatItem("Cities", _countUnique('viewer_location'), theme),
            ],
          ),
        ],
      ),
    );
  }

  int _countUnique(String key) {
    return _views
        .map((v) => v[key])
        .where((val) => val != null && val.toString().isNotEmpty)
        .toSet()
        .length;
  }

  Widget _buildStatItem(String label, int value, ThemeData theme) {
    return Column(
      children: [
        Text(
          "$value",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildViewerTile(Map<String, dynamic> view, ThemeData theme, bool isDark) {
    final bool isAnonymous = view['viewer_is_anonymous'] ?? false;
    final String name = isAnonymous ? "Anonymous User" : (view['viewer_name'] ?? "Someone");
    final String? role = view['viewer_role'];
    final String? company = view['viewer_company'];
    final String? location = view['viewer_location'];
    final DateTime lastViewed = DateTime.parse(view['last_viewed_at']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            child: Icon(
              isAnonymous ? Icons.visibility_off_outlined : Icons.person_outline,
              color: theme.iconTheme.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: isAnonymous ? FontStyle.italic : null,
                  ),
                ),
                if (role != null || company != null)
                  Text(
                    "${role ?? ''}${role != null && company != null ? ' at ' : ''}${company ?? ''}",
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (location != null)
                  Text(
                    location,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatDate(lastViewed),
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return DateFormat('MMM d').format(date);
  }
}
