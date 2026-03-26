import 'dart:io';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';
import 'package:jooblie_app/main.dart'; // To access navigatorKey
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();


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
    
    // Sync to Supabase if user is logged in
    await syncTokenToSupabase();
    
    return token ?? "";
  }

  /// --- Sync Token to Supabase --- ///
  Future<void> syncTokenToSupabase() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      String? token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await Supabase.instance.client
            .from('profiles')
            .update({'userDeviceToken': token})
            .eq('id', user.id);
        if (kDebugMode) {
          print("✅ FCM Token Synced to Supabase for user ${user.id}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error syncing FCM token: $e");
      }
    }
  }


  /// --- firebase init  & local notifications init --- ///
  
  void firebaseInit(){
    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print("🔄 FCM Token Refreshed: $newToken");
      }
      syncTokenToSupabase();
    });

    // Initial sync
    syncTokenToSupabase();
    
    // Initialize Local Notifications ONCE here
    var androidInitSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );

    _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSetting, 
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            handleMessageFromPayload(data);
          } catch(e) {
            print("Error parsing local notification payload: $e");
          }
        }
      }
    );

    // Listen to foreground FCM messages
    FirebaseMessaging.onMessage.listen((message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;

      if(kDebugMode){
        print("FCM Foreground Message Data Payload: ${message.data}");
        print("notification title: ${notification?.title}");
        print("notification body: ${notification?.body}");
      }
      
      // Check if notification is meant for the currently logged-in user
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      final targetUserId = message.data['targetUserId'];
      
      if (targetUserId != null && currentUserId != null && targetUserId.toString() != currentUserId.toString()) {
        if(kDebugMode){
          print("Notification is for user $targetUserId, but current user is $currentUserId. Ignoring.");
        }
        return;
      }

      // ios
      if(Platform.isIOS){
        iosForegroundMessage();
      }
      // android
      if(Platform.isAndroid){
        showNotifications(message);
      }
    });
  }


/// ---  Background and terminated state --- ///


  Future<void> setupInteractMessage() async{

    // background state

    FirebaseMessaging.onMessageOpenedApp.listen(
            (message){
handleMessage(message);
    }
    );


    // terminated state

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message != null && message.data.isNotEmpty){
        handleMessage(message);
      }
    });

  }


  /// --- handle Message --- ///

  Future<void> handleMessage(RemoteMessage message)async{
    // Tap handler for background/terminated notifications
    if (kDebugMode){
      print("Tapped Notification with FCM Data: ${message.data}");
      print("Notification type: ${message.data['type']}");
      print("Notification applicationId: ${message.data['applicationId']}");
      print("Notification targetUserId: ${message.data['targetUserId']}");
    }
    _routeBasedOnData(message.data);
  }

  void handleMessageFromPayload(Map<String, dynamic> data) {
    // Tap handler for local (foreground) notifications
    if (kDebugMode){
      print("Tapped Notification with Local Payload Data: $data");
      print("Notification type: ${data['type']}");
      print("Notification applicationId: ${data['applicationId']}");
    }
    _routeBasedOnData(data);
  }

  void _routeBasedOnData(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final applicationId = data['applicationId']?.toString();

    if (kDebugMode) {
      print("[NotificationsService] Routing => type: $type | applicationId: $applicationId");
    }

    if (type == 'new_application' && applicationId != null && applicationId.isNotEmpty) {
      // Recruiter receives this — go directly to Applicant Detail
      print("[NotificationsService] Routing recruiter to ApplicantDetail: $applicationId");
      navigatorKey.currentState?.pushNamed(
        RoutesName.applicantDetail,
        arguments: applicationId,
      );
    } else if (type == 'status_update') {
      // Job Seeker receives this — go to Applications tab
      print("[NotificationsService] Routing job seeker to Applications Tab (Index 3)");
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RoutesName.dashboard,
        (route) => false,
        arguments: {'isJobSeeker': true, 'initialIndex': 3},
      );
    } else {
      print("[NotificationsService] Unknown type: $type — No navigation performed.");
    }
  }


  /// --- function to show notifications --- ///


  Future<void> showNotifications(RemoteMessage message)async{

    //chanel setting
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification?.android?.channelId ?? 'high_importance_channel_id',
      'High Importance Notifications',
      importance: Importance.max,
      showBadge: true,
      playSound: true

    );

    // android settings
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      channelDescription: "High priority channel for application updates"
    );

    // ios settings

    DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    //merge settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails
    );

    //show notification
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
        id: 0,
        title: message.notification?.title.toString() ?? 'Notification',
        body: message.notification?.body.toString() ?? '',
        notificationDetails: notificationDetails,
        payload: jsonEncode(message.data), // Encode data to be passed to onDidReceiveNotificationResponse
      );
    });



  }






/// --- Ios Message --- ///

Future iosForegroundMessage()async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true
    );
}

}
