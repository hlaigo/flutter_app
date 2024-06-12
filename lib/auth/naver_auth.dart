import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverAuth {
  static void naverLogin() async {
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn().timeout(
          Duration(seconds: 10),
          onTimeout: () => null as NaverLoginResult);
      print('accessToken = ${res.accessToken}');
      print('id = ${res.account.id}');
      print('email = ${res.account.email}');
      print('name = ${res.account.name}');
    } catch (error) {
      print(error);
    }
  }
}
