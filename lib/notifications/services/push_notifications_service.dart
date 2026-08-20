import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';
import 'local_notification_service.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final Set<String> _handledMessageIds = <String>{};

  static bool _isDuplicate(RemoteMessage message) {
    final id = message.messageId;
    if (id == null) return false;
    if (_handledMessageIds.contains(id)) return true;
    _handledMessageIds.add(id);
    if (_handledMessageIds.length > 50) {
      _handledMessageIds.remove(_handledMessageIds.first);
    }
    return false;
  }

  static Future<void> init() async {
    try {
      final NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      log('User notification status: ${settings.authorizationStatus}');

      // 🟢 تفعيل ظهور التنبيهات في واجهة النظام
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      try {
        final token = await messaging.getToken();
        if (token != null) {
          log('🔑 FCM Token: $token');
          await sendTokenToServer(token);
        }
      } catch (e) {
        log('⚠️ Failed to get FCM Token: $e');
      }

      messaging.onTokenRefresh.listen((value) {
        log('🔄 FCM Token Refreshed');
        sendTokenToServer(value);
      });

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      handleForegroundMessage();

      try {
        await messaging.subscribeToTopic('all');
        log('Subscribed to "all" topic');
      } catch (e) {
        log('⚠️ Failed to subscribe to topic "all": $e');
      }
    } catch (e) {
      log('⚠️ PushNotificationsService initialization error: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Background Notification Received: ${message.notification?.title}');
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_isDuplicate(message)) {
        log('⏭️ Duplicate message ignored: ${message.messageId}');
        return;
      }
      log('Foreground Notification Received: ${message.notification?.title}');
      LocalNotificationService.showBasicNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification clicked: ${message.notification?.title}');
    });
  }

  static Future<void> sendTokenToServer(String token) async {
    try {
      final apiService = ApiService();
      final response = await apiService.post(
        '${ConstantApi.baseApi}/users/fcm-token',
        data: {'fcm_token': token},
        tr: (key) => key,
      );
      log('✅ FCM Token synced: ${response.statusCode}');
    } catch (_) {
      log('⚠️ Could not sync FCM Token (user might not be logged in yet)');
    }
  }
}