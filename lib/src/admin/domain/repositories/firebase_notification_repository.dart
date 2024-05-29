import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:trackmyclients_app/src/admin/presentation/views/chat/chat_screen.dart';

const channel = AndroidNotificationChannel(
    'high_importance_channel', 'Hign Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

class NotificationsService {
  static const key =
      'AAAAsfbE86Y:APA91bEUV5GG-gIOv22cMdetxOcxJph7rD5QWJCyFbHRvsgJbCPl684fohdd0bdOEkz4ep6_bErmJPHAfGl0TWhmjdtfemg-2HWKnsooX66dD2TSIhEcSt2wdX-MqEI9X7lUVVrH22JB';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    requestPermission();
    const androidSettings =
        AndroidInitializationSettings('trackmyclients');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
        'com.ghoutani.trackmyclients_app', 'mychannelid',
        importance: Importance.max,
        styleInformation: styleInformation,
        priority: Priority.high,
        ticker: 'ticker');
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['body']);
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for local notif');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken({String aui = ''}) async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!, aui: aui);
  }

  Future<void> _saveToken(String token, {required String aui}) async {
    try {
      if (aui.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(aui)
            .collection('clients')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({'token': token}, SetOptions(merge: true));
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  String? receiverToken = '';

  Future<void> getReceiverToken(String? receiverId,
      {bool isClientSide = false}) async {
    final getToken;
    if (isClientSide) {
      getToken = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('clients')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      getToken = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('clients')
          .doc(receiverId)
          .get();
    }
    
    receiverToken = await getToken.data()!['token'];
  }

  void firebaseNotification(context) {
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(id: message.data['senderId']),
        ),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
  }

  Future<void> sendNotification({required String body}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': 'New Message !',
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': FirebaseAuth.instance.currentUser!.uid,
          }
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
