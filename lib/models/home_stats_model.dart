class HomeStatModel {
  final String label;
  final int count;
  final String badge;
  final String iconAsset; // semantic name used to pick icon in view

  const HomeStatModel({
    required this.label,
    required this.count,
    required this.badge,
    required this.iconAsset,
  });
}

class RecentApplicationModel {
  final String title;
  final String company;
  final String status; // 'Interview', 'Under Review', 'Applied'
  final String date;

  const RecentApplicationModel({
    required this.title,
    required this.company,
    required this.status,
    required this.date,
  });
}
