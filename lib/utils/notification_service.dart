import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:taxi_finder/utils/local_notificatioin_service.dart';

class NotificationService {
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
}