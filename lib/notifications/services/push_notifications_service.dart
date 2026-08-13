import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 🔴 طلب الصلاحيات المباشرة
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    log('User notification status: ${settings.authorizationStatus}');

    // 🔴 تمكين الخيارات لظهور الإشعار أثناء فتح التطبيق (Foreground)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await messaging.getToken().then((value) {
      log('🔑 FCM Token: $value');
      if (value != null) {
        sendTokenToServer(value);
      }
    });

    messaging.onTokenRefresh.listen((value) {
      log('🔄 FCM Token Refreshed: $value');
      sendTokenToServer(value);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();

    // الاشتراك بالقناة العامة
    messaging.subscribeToTopic('all').then((val) {
      log('Subscribed to "all" topic');
    });
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Background Notification Received: ${message.notification?.title}');
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        log('Foreground Notification Received: ${message.notification?.title}');
        LocalNotificationService.showBasicNotification(message);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification clicked from background: ${message.notification?.title}');
    });
  }

  static void sendTokenToServer(String token) {
    log('📤 Sending token to server: $token');
  }
}