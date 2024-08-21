import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This is a top-level function and can't not be inside of a class.
Future<void> handleOnBackgroungMessage(RemoteMessage message) async {
  debugPrint('''
title: ${message.notification?.title}
body:  ${message.notification?.body}
payload: ${message.data}
messageId: ${message.messageId}
  ''');
}

class FirebaseNotificationApi {
  // instanciating FirebaseMessaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // instanciating FlutterLocalNotificationsPlugin
  final _flutterLocalNotification = FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active

  Future initLocalNotification() async {
    const androidInitializationSettings =
        AndroidInitializationSettings("@drawable/firebase_messaging");
    const iosInitializationSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotification.initialize(initializationSettings);
    await _flutterLocalNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // for Foreground notification for Android
  final channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    description: 'This channel is for high important notifications',
    importance: Importance.high,
    playSound: true,
  );

  // Forground message settings for IOS

  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    final notifications = message.notification;
    final androidNotification = message.notification?.android;

    if (notifications != null && androidNotification != null) {
      _flutterLocalNotification.show(
        notifications.hashCode,
        notifications.title,
        notifications.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: "@drawable/firebase_messaging",
            color: const Color(0xFFFFC400),
            playSound: true,
          ),
        ),
      );
    }
  }

  //  initialize function to define all the required push notification functionalities
  Future<void> initNotifications() async {
    // Setting permission request
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    debugPrint(
        "user granted permission status: ${settings.authorizationStatus}");

    final fcmToken = await _firebaseMessaging.getToken();

    // In real application, you send this token to the backend
    log("phone token: $fcmToken");

    // For background and terminated notification
    FirebaseMessaging.onBackgroundMessage(handleOnBackgroungMessage);

    // Foreground
    foregroundMessage();
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Got a message while in foreground");
      debugPrint("Message Data: ${message.data}");

      if (message.notification != null) {
        log("Got a message with notification: ${message.notification}");
      }

      handleForegroundMessage(message);
    });


    initLocalNotification();
  }

 
}
