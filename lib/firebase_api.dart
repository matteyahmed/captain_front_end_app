import 'package:flutter/material.dart';

import 'package:captain_app_2/api/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroudMessage(RemoteMessage message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // print("Push Notification Title: ${message.notification?.title}");
  // print("Push Notification Body: ${message.notification?.body}");
  // print("Push Notification data: ${message.data}");

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      // android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      android: AndroidInitializationSettings('mipmap/ic_launcher_foreground'),
    ),
  );
  final notificationTitle = message.notification?.title;
  final notificationBody = message.notification?.body;

  // Schedule a local notification
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    notificationTitle ?? '',
    notificationBody ?? '',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id', // Replace with your channel ID
        'Default Channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher_foreground',
        autoCancel: false,
         // Set the background color here
      ),
      iOS: DarwinNotificationDetails()
    ),
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // final ApiService _apiService = ApiService();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await _firebaseMessaging.requestPermission();

    // final FCMToken = await _firebaseMessaging.getToken();
    // print('Token: $FCMToken');

    // await _apiService.sendFCMtoken(FCMToken);

    FirebaseMessaging.onBackgroundMessage(handleBackgroudMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message in foreground: ${message.notification!.body}');
      handleForegroundMessage(message);
      // Handle the message here, e.g., show a notification
      // You can use flutter_local_notifications or another package to display notifications
    });
  }

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    // Display a notification using flutter_local_notifications
    final AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
            'your_channel_id', // Replace with your channel ID
            'Default Channel',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher_foreground',
            autoCancel: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error displaying notification: ${e}');
    }
  }
}
