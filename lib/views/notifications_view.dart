import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/sized.dart';
import 'package:jooblie_app/viewmodels/notifications_viewmodel.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsViewModel>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsViewModel>().markAllAsRead();
            },
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(child: Text(vm.error!));
          }

          if (vm.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[400]),
                  16.h,
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchNotifications(),
            child: ListView.separated(
              itemCount: vm.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = vm.notifications[index];
                final isUnread = !notification.isRead;

                return InkWell(
                  onTap: () {
                    if (isUnread) {
                      vm.markAsRead(notification.id);
                    }
                  },
                  child: Container(
                    color: isUnread 
                        ? (isDark ? AppColors.lightPrimary.withOpacity(0.1) : Colors.blue.withOpacity(0.05)) 
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUnread 
                                ? AppColors.lightPrimary.withOpacity(0.1) 
                                : (isDark ? AppColors.darkMuted : Colors.grey[200]),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isUnread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                            color: isUnread ? AppColors.lightPrimary : Colors.grey,
                            size: 24,
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isUnread)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              4.h,
                              Text(
                                notification.body,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              8.h,
                              Text(
                                _timeAgo(notification.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 8) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
