import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// --- For Notifications Request --- ///

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted Notifications permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional Notifications permissions');
    } else {
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('User declined Notifications permissions'),
        duration: Duration(seconds: 2),
      );

      Future.delayed(Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });

      // CustomFlushbar.showError(context: context, message: message)
    }
  }

  /// --- Get Device Token --- ///

  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await messaging.getToken();
    print("Notifications Device Token ==> $token");
    return token!;
  }
}
