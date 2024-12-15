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
        final title = message.notification?.title ?? "";
        final body = message.notification?.body ?? "";
        LocalNotificationService()
            .showNotification(id: 10, title: title, body: body);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('on open notification from background ');
    });
  }

  static sendNotification(
      {required String fcmToken,
      required String driverName,
      required String accessToken,
      required String requestId}) async {
    try {
      var notificationData = {
        message: {
          token: fcmToken,
          notification: {
            title: "Driver Arrived ",
            body: "Your driver $driverName is arrived on your location"
          },
          data: <String, String>{requestid: requestId},
        }
      };
      final response = await http.post(
        Uri.parse(fcmApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(notificationData),
      );
      log('response notification ${response.body} === status code ${response.statusCode}');
    } catch (e) {
      log('Error sending notification: $e');
    }
  }
}
