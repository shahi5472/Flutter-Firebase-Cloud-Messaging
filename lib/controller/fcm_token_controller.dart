
import 'package:fcm_notification_flutter/apiz/TokenApi.dart';
import 'package:get/get.dart';

class FCMTokenController extends GetxController{
  void setFCMToken({required String token}){
    print('FCMTokenController $token');
    TokenApi.instance.setToken(token: token);
  }
}