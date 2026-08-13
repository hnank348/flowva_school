import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
  StreamController<NotificationResponse>();

  static final Dio _dio = Dio();

  static void onTap(NotificationResponse notificationResponse) {
    log('Notification Clicked: ${notificationResponse.id}');
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // 🔴 إنشاء قناة إشعارات جديدة بـ high_importance_channel لكسر كاش القناة القديمة بـ Importance.max
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for high priority notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    try {
      final String title = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';
      final String body  = message.notification?.body ?? message.data['body'] ?? '';

      final String? imageUrl = message.notification?.android?.imageUrl;

      Uint8List? imageBytes;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final Response<List<int>> response = await _dio.get<List<int>>(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        imageBytes = Uint8List.fromList(response.data ?? []);
      }

      StyleInformation? styleInformation;
      if (imageBytes != null) {
        final String base64Image = base64Encode(imageBytes);
        styleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Image),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Image),
        );
      }

      final AndroidNotificationDetails android = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Channel for high priority notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: styleInformation,
        playSound: true,
        enableVibration: true,
      );

      final NotificationDetails details = NotificationDetails(android: android);

      // ID فريد لكل إشعار لتجنب الاستبدال
      final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await flutterLocalNotificationsPlugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }
}