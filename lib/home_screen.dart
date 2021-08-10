import 'package:fcm_notification_flutter/firebase_notification_handler.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter FCM Demo'),
      ),
      body: Container(
        child: Center(
          child: TextButton(
            child: Text('Flutter FCM Demo'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
