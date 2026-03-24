class DashboardStats {
  final int totalApplications;
  final int activeApplications;
  final int interviewsScheduled;
  final int offersReceived;
  final int profileViews;
  final List<ApplicationStatusCount> applicationsByStatus;
  final List<RecentActivity> recentActivities;

  DashboardStats({
    required this.totalApplications,
    required this.activeApplications,
    required this.interviewsScheduled,
    required this.offersReceived,
    required this.profileViews,
    required this.applicationsByStatus,
    required this.recentActivities,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalApplications: json['totalApplications'] ?? 0,
      activeApplications: json['activeApplications'] ?? 0,
      interviewsScheduled: json['interviewsScheduled'] ?? 0,
      offersReceived: json['offersReceived'] ?? json['oqersReceived'] ?? 0,
      profileViews: json['profileViews'] ?? 0,
      applicationsByStatus: (json['applicationsByStatus'] as List?)
              ?.map((e) => ApplicationStatusCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentActivities: (json['recentActivities'] as List?)
              ?.map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalApplications': totalApplications,
      'activeApplications': activeApplications,
      'interviewsScheduled': interviewsScheduled,
      'offersReceived': offersReceived,
      'profileViews': profileViews,
      'applicationsByStatus': applicationsByStatus.map((e) => e.toJson()).toList(),
      'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
    };
  }
}

class ApplicationStatusCount {
  final String status;
  final int count;

  ApplicationStatusCount({
    required this.status,
    required this.count,
  });

  factory ApplicationStatusCount.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusCount(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
    };
  }
}

class RecentActivity {
  final String type; // 'application', 'profile_view', 'interview'
  final String description;
  final DateTime timestamp;

  RecentActivity({
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
