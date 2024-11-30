import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/local_notificatioin_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static String fcmApi =
      'https://fcm.googleapis.com/v1/projects/taxi-finder-93d36/messages:send';
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static initializeNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}',
        name: "initializeFirebaseMessaging");
    setupListner();
    await LocalNotificationService().init();
  }

  static setupListner() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      log('id ${message.messageId}');
      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('on open notification from background ');
    });
  }

  static sendNotification(
      {required String fcmToken,
      required String driverName,
      required String requestId}) async {
    try {
      final response = await http.post(
        Uri.parse(fcmApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer cd4be432378cc3498727c8c669445f7e0af4e995',
        },
        body: jsonEncode({
          "message": {
            "topic": "news",
            "notification": {
              "title": "Breaking News",
              "body": "New news story available."
            },
            "data": {"story_id": "story_12345"}
          }
        }),
      );
      log('response notification ${response.body} === status code ${response.statusCode}');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
