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
    log(notificationResponse.id?.toString() ?? 'no id');
    log(notificationResponse.payload?.toString() ?? 'no payload');
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
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    try {
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
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: styleInformation,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound(
          'long_notification_sound',
        ),
      );

      final NotificationDetails details =
      NotificationDetails(android: android);

      await flutterLocalNotificationsPlugin.show(
        id: 0,
        title: message.notification?.title,
        body: message.notification?.body,
        notificationDetails: details,
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }
}