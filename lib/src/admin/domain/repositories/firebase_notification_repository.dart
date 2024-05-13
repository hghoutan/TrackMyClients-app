import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
    );
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true);
    // Initialize native android notification
    const AndroidInitializationSettings _initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings _initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings _initializationSettings =
        InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
    );
    tz.initializeTimeZones();
  }

  Future<void> showNotificationAndroid(String title, String value) async {
    const AndroidNotificationDetails _androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'Channel Name',
            channelDescription: 'Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails _notificationDetails =
        NotificationDetails(android: _androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      1, // notification id
      title,
      value,
      _notificationDetails,
      payload: 'Not present',
    );
  }

  Future<void> showNotificationIos(String title, String value) async {
    const DarwinNotificationDetails _iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound:
          'ound.caf', // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 1, // The application's icon badge number
      attachments: [], // (only from iOS 10 onwards)
      subtitle:
          'Secondary description', // Secondary description  (only from iOS 10 onwards)
      threadIdentifier: 'thread_id', // (only from iOS 10 onwards)
    );

    const NotificationDetails _platformChannelSpecifics =
        NotificationDetails(iOS: _iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      1, // notification id
      title,
      value,
      _platformChannelSpecifics,
      payload: 'Not present',
    );
  }

  Future<void> showTimedNotification() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // notification id
      "Title",
      "Description",
      tz.TZDateTime.now(tz.local).add(const Duration(days: 3)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
