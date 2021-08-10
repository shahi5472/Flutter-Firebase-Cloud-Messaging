import 'package:fcm_notification_flutter/controller/fcm_token_controller.dart';
import 'package:fcm_notification_flutter/firebase_notification_handler.dart';
import 'package:fcm_notification_flutter/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FCMTokenController tokenController = Get.put(FCMTokenController());
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter FCM Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: $message');
  dynamic data = message.data['data'];
  FirebaseNotifications.showNotification(data['title'], data['body']);
}
