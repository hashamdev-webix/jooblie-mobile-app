import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

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
    return token!;
  }


  /// --- init local notification --- ///


void initLocalNotification(BuildContext context, RemoteMessage message) async{
    
    var androidInitSetting = AndroidInitializationSettings("@mipmap/ic_launcher");

    var iosInitSetting = DarwinInitializationSettings();

    var initializationSetting= InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );


    await _flutterLocalNotificationsPlugin.initialize(settings: initializationSetting, onDidReceiveNotificationResponse:(payload){
      handleMessage(context, message);
      
    });






    

}



/// --- firebase init --- ///

  /// jab app running main ho gi to ya method run ho ga

void firebaseInit(BuildContext context){

    FirebaseMessaging.onMessage.listen((message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification=message.notification!.android;

      if(kDebugMode){
        print("notification title: ${notification!.title}");
        print("notification title: ${notification.body}");

      }
      // ios
      if(Platform.isIOS){
        iosForegroundMessage();

      }
      // android
      if(Platform.isAndroid){
        initLocalNotification(context, message);
        // handleMessage(context, message);
        showNotifications(message);
      }

    }
    );


}


/// ---  Background and terminated state --- ///


  Future<void> setupInteractMessage(BuildContext context) async{

    // background state

    FirebaseMessaging.onMessageOpenedApp.listen(
            (message){
handleMessage(context, message);
    }
    );


    // terminated state

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message != null && message.data.isNotEmpty){
        handleMessage(context, message);
      }
    });

  }


  /// --- handle Message --- ///

  Future<void> handleMessage(BuildContext context,RemoteMessage message)async{
    Navigator.pushNamed(context, RoutesName.recruiterPostJob);
  }


  /// --- function to show notifications --- ///


  Future<void> showNotifications(RemoteMessage message)async{

    //chanel setting
    AndroidNotificationChannel channel = AndroidNotificationChannel(message.notification!.android!.channelId.toString(),

        message.notification!.android!.channelId!.toString(),
      importance: Importance.high,
      showBadge: true,
      playSound: true

    );

    // android settings
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),

        channel.name.toString(),
importance:Importance.high,
priority: Priority.high,
playSound: true,
sound: channel.sound,
channelDescription: "Channel Description"
    // channelDescription: channel.description.toString()
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
    title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        notificationDetails: notificationDetails,
        payload: "my_data"


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
