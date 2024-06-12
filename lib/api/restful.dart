import 'dart:convert';

import 'package:aigo/main.dart';
import 'package:http/http.dart' as http;

class Restful {
  static const host = 'https://hlaigo.co.kr';
  static const authURI = '$host/app/auth/';
  static const reportTokenURI = '$host/regist/token';
  static const jsonHeader = {"Content-Type": "application/json"};

  static Future<void> deviceTokenReporting(
      String deviceName, String deviceToken) async {
    Map<String, String> body = {
      "device_name": deviceName,
      "device_token": deviceToken
    };
    var res = await http.post(Uri.parse(reportTokenURI),
        headers: jsonHeader, body: jsonEncode(body));
    logger.d(res.statusCode);
  }

  static Future<bool> requestAuthentication(
      String platform, String? userId, String? socialUuid) async {
    if (userId == null || socialUuid == null) {
      logger.e('Value null dectected');
      return false;
    }
    Map<String, String> body = {"user_id": userId, "social_uuid": socialUuid};
    var res = await http.post(Uri.parse(authURI + platform),
        headers: jsonHeader, body: jsonEncode(body));
    logger.d(res.body);
    return true;
  }
}
