import 'package:get/get.dart';

class TokenApi extends GetConnect {
  TokenApi._();

  static final TokenApi _instance = TokenApi._();

  static TokenApi get instance => _instance;

  Future<void> setToken({required String token}) async {
    Response response = await post(
        'http://fcm-notification-flutter.herokuapp.com/api/token/save',
        {'token': token});

    print('Response ${response.body}');
  }
}
