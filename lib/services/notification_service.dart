import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String serverKey =
      "AAAAakNMMi0:APA91bE8yO6dtV-b_M-vedbKR1w-gBHxsnok44rXAdxNugkvBumahH5fmrOHY2ctXs_JTKNQBh8JxAClA-P5JihfUSaRJZEbadcYzys76XPmFmBx32x9sAoSxaemB7oe8xhyreHJ5y-O";
  static Future<void> initializeAwesomeNotifications() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'chat_wat',
          channelName: 'chat wat',
          channelDescription: 'Chat with friends',
          defaultColor: Colors.red,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        )
      ],
    );
  }

  static Future<void> getNotoficationToken() async {
    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      final sveToken = await SharedPreferences.getInstance();
      sveToken.setString('token', fcmToken ?? '');
      print('.......................fcmToken..${sveToken.getString('token')}');
    } catch (e) {
      print('.............................Error in geting token:$e');
    }
  }

  Future<void> listenNotification() async {
    await initializeAwesomeNotifications();
    FirebaseMessaging.onBackgroundMessage(listenBackgroundMessage);
    FirebaseMessaging.onMessage.listen(listenForgroundNotification);
  }

  Future<void> listenBackgroundMessage(RemoteMessage message) async {
    String? title = message.notification!.title;
    String? body = message.notification!.body;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 123,
        channelKey: 'chat_wat',
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Message,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> listenForgroundNotification(RemoteMessage message) async {
    String? title = message.notification!.title;
    String? body = message.notification!.body;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 123,
        channelKey: 'chat_wat',
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Message,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> pushNotificationFromFirebase(
      {required String deviceToken,
      required String msg,
      required String sendBy}) async {
    var baseUrl = "https://fcm.googleapis.com/fcm/send";

    try {
      http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(
          {
            "AIzaSyBjp4ZJeHHnKOzXMAhwzPduiX-c5Vfc97s"
            "to": deviceToken,
            "notification": {"title": sendBy, "body": msg}
          },
        ),
      );
    } on PlatformException catch (ex) {
      print(
          '............................Error in send notification:${ex.message}');
    } catch (e) {
      print('............................Error in send notification:$e');
    }
  }
}
