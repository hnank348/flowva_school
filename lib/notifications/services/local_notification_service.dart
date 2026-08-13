import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static const String channelId = 'flowva_heads_up_v6';
  static const String channelName = 'Flowva Priority Notifications';
  static const String channelDescription =
      'Channel for immediate floating banner notifications';

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>.broadcast();

  @pragma('vm:entry-point')
  static void onTap(NotificationResponse notificationResponse) {
    log('Notification Clicked: ${notificationResponse.id}');
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImpl =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await androidImpl?.createNotificationChannel(channel);
    await androidImpl?.createNotificationChannel(channel);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    try {
      final String title =
          message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';
      final String body =
          message.notification?.body ?? message.data['body'] ?? '';

      final int uniqueNotificationId =
          DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;

      final AndroidNotificationDetails android = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,

        onlyAlertOnce: false,
        groupKey: null,
        setAsGroupSummary: false,
        tag: 'flowva_$uniqueNotificationId',
        ticker: title,
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher',
        autoCancel: true,
        when: DateTime.now().millisecondsSinceEpoch,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: title,
        ),
      );

      final NotificationDetails details = NotificationDetails(
        android: android,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        id: uniqueNotificationId,
        title: title,
        body: body,
        notificationDetails: details,
        payload: message.data['type']?.toString(),
      );

      log('📢 Floating Notification Displayed with ID: $uniqueNotificationId');
    } catch (e) {
      log('❌ Error showing local notification: $e');
    }
  }
}
