import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/repositories/recruiter_repository.dart';
import 'package:jooblie_app/widgets/app_bar_widget.dart';
import 'package:intl/intl.dart';

class JobViewInsightsView extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobViewInsightsView({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobViewInsightsView> createState() => _JobViewInsightsViewState();
}

class _JobViewInsightsViewState extends State<JobViewInsightsView> {
  final RecruiterRepository _repository = RecruiterRepository();
  bool _isLoading = true;
  Map<String, dynamic> _insights = {};

  @override
  void initState() {
    super.initState();
    _fetchInsights();
  }

  Future<void> _fetchInsights() async {
    final insights = await _repository.getJobViewInsights(widget.jobId);
    if (mounted) {
      setState(() {
        _insights = insights;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(
        title: "Job Insights",
        showAppLogo: false,
      ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.jobTitle,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryCard(theme, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          "Recent Viewers",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final views = _insights['recent_views'] as List<dynamic>;
                            return _buildViewerTile(views[index], theme, isDark);
                          },
                          childCount: (_insights['recent_views'] as List<dynamic>).length,
                        ),
                      ),
                    ),
                    if ((_insights['recent_views'] as List<dynamic>).isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: Text("No views recorded yet."),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
            "${_insights['total_views']}",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text("Total Interest"),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Industries", (_insights['industries'] as Map).length, theme),
              _buildStatItem("Roles", (_insights['roles'] as Map).length, theme),
              _buildStatItem("Locations", (_insights['locations'] as Map).length, theme),
            ],
          ),
        ],
      ),
    );
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
    final profile = view['profiles'] as Map<String, dynamic>? ?? {};
    
    final String name = isAnonymous ? "Anonymous Professional" : (view['viewer_name'] ?? profile['full_name'] ?? "Someone");
    final String? role = view['viewer_role'] ?? profile['role'] ?? profile['job_title'];
    final String? location = view['viewer_location'] ?? profile['location'];
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
                if (role != null)
                  Text(
                    role,
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
