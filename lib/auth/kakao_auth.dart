import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuth {
  static var REDIRECT_URI = 'http://aigo.iptime.org:9999/callback/kakao';
  static login() async {
    bool talkInstalled = await isKakaoTalkInstalled();

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (talkInstalled) {
      // 카카오톡으로 로그인
      try {
        await AuthCodeClient.instance.authorizeWithTalk(
          redirectUri: 'http://aigo.iptime.org:9999/callback/kakao',
        );
      } catch (error) {
        print('Login with Kakao Talk fails $error');
      }
    } else {
      // 카카오계정으로 로그인
      try {
        await AuthCodeClient.instance.authorize(
          redirectUri: '${REDIRECT_URI}',
        );
      } catch (error) {
        print('Login with Kakao Account fails. $error');
      }
    }
  }
}
