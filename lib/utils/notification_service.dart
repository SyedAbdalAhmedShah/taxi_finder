import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/utils/local_notificatioin_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static String fcmApi = 'https://fcm.googleapis.com/fcm/send';
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
          'Authorization': 'key=YOUR_SERVER_KEY',
        },
        body: jsonEncode({
          to: fcmToken,
          notification: {
            title: "Driver Arrived",
            body: "Your driver $driverName has been arrived on your location ",
          },
          data: {"requestId": requestId},
        }),
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
