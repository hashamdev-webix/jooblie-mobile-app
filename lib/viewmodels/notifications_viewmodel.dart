import 'package:flutter/material.dart';
import 'package:jooblie_app/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsViewModel extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String? error;

  NotificationsViewModel() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await Supabase.instance.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      notifications = data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      error = 'Failed to load notifications.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
          
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final old = notifications[index];
        notifications[index] = NotificationModel(
          id: old.id,
          userId: old.userId,
          title: old.title,
          body: old.body,
          type: old.type,
          referenceId: old.referenceId,
          isRead: true,
          createdAt: old.createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
          
      notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;
      
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
          
      for (int i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          notifications[i] = NotificationModel(
            id: notifications[i].id,
            userId: notifications[i].userId,
            title: notifications[i].title,
            body: notifications[i].body,
            type: notifications[i].type,
            referenceId: notifications[i].referenceId,
            isRead: true,
            createdAt: notifications[i].createdAt,
          );
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }
}
