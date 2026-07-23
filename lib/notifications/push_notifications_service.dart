import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await messaging.requestPermission();

    await messaging.getToken().then((value) {
      log('🔑 FCM Token: $value');   // ✅ أضفنا هذا
      sendTokenToServer(value!);
    });

    messaging.onTokenRefresh.listen((value) {
      log('🔄 FCM Token Refreshed: $value');   // ✅ أضفنا هذا كمان
      sendTokenToServer(value);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();

    messaging.subscribeToTopic('all').then((val) {
      log('sub');
    });
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        LocalNotificationService.showBasicNotification(message);
      },
    );
  }

  static void sendTokenToServer(String token) {
    log('📤 Sending token to server: $token');   // ✅ اختياري للتتبع
    // option 1 => API
    // option 2 => Firebase
  }
}