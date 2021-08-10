import 'dart:io';

import 'package:fcm_notification_flutter/controller/fcm_token_controller.dart';
import 'package:fcm_notification_flutter/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseNotifications {
  FirebaseMessaging? _messaging;
  BuildContext? buildContext;

  FCMTokenController controller = Get.find();

  void setupFirebase(BuildContext? context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessagingListener(context);
    buildContext = context;
  }

  void firebaseCloudMessagingListener(BuildContext? context) async {
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Settings ${settings.authorizationStatus}');

    _messaging!.getToken().then((value) {
      if (value != null) {
        print('My Token $value');
        controller.setFCMToken(token: value);
      }
    });

    _messaging!
        .subscribeToTopic('flutter_fcm_demo')
        .whenComplete(() => print('Subscribe ok'));

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      if (Platform.isAndroid) {
        showNotification(
            remoteMessage.data['title'], remoteMessage.data['body']);
      } else if (Platform.isIOS) {
        showNotification(remoteMessage.notification!.title,
            remoteMessage.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('Receive Message open: $remoteMessage');
      if (Platform.isIOS) {
        showDialog(
          context: buildContext!,
          builder: (context) => CupertinoAlertDialog(
            title: Text('${remoteMessage.notification!.title}'),
            content: Text('${remoteMessage.notification!.body!}'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  static void showNotification(String? title, String? body) async {
    var androidChannel = AndroidNotificationDetails(
      'com.s.m.shahi.flutter_fcm_demo',
      'Flutter FCM Demo',
      'Flutter FCM Demo Description',
      autoCancel: false,
      ongoing: true,
      importance: Importance.high,
      priority: Priority.high,
    );

    var iosChannel = IOSNotificationDetails();

    var platForm = NotificationDetails(
      android: androidChannel,
      iOS: iosChannel,
    );

    await NotificationHandler.firebaseLocalNotificationPlugin
        .show(0, title, body, platForm, payload: 'My Payload');
  }
}
