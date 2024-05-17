import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trackmyclients_app/src/utils/functions/message_tools.dart';
import 'package:trackmyclients_app/src/utils/services/google_service.dart';

import '../../admin/data/helpers/local_database_helper.dart';
import '../../admin/data/models/scheduled_message.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> onSelectNotification(String? payload) async {
  if (payload != null) {
    final email = ScheduledEmail.fromMap(jsonDecode(payload));
    await sendScheduledEmail(email);
  }
}

Future<void> scheduleEmail(ScheduledEmail email) async {
  final scheduledNotificationDateTime = tz.TZDateTime.from(email.scheduledTime, tz.Location('UTC+1', [tz.minTime], [0], [tz.TimeZone(1, isDst: false, abbreviation: 'UTC+1')]));
  final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'email_channel',
      'Email Channel',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    email.id,
    'Scheduled Email',
    'You have a scheduled email to send.',
    scheduledNotificationDateTime,
    notificationDetails,
    payload: jsonEncode(email.toMap()), 
    uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime,
    
  );
}

Future<void> sendScheduledEmail(ScheduledEmail email) async {
  await sendMail(
    senderName: email.senderName,
    recieverName: email.receiverName,
    receiverEmail: email.receiverEmail,
    senderEmail: email.senderEmail,
    message: email.message,
  );
  final dbHelper = DatabaseHelper();
  await dbHelper.markEmailAsSent(email.id);
}
