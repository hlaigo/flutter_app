import 'dart:async';
import 'dart:convert';

import 'package:aigo/api/restful.dart';
import 'package:aigo/firebase_options.dart';
import 'package:aigo/frames/main_frame.dart';
import 'package:aigo/screens/competition_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
StreamController<String> streamController = StreamController.broadcast();

var logger = Logger();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Notification Received!');
  streamController.add('home');
  if (message.notification != null) {
    logger.d(message.notification);
  }
}

void onDidReceiveNotificationResponse(NotificationResponse details) async {
  // 여기서 핸들링!
  print('onDidReceiveNotificationResponse - payload: ${details.payload}');
  final payload = details.payload ?? '';
  streamController.add('home');
  Fluttertoast.showToast(msg: "test");
  final parsedJson = jsonDecode(payload);
  if (!parsedJson.containsKey('d')) {
    return;
  }
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
}

void _handleMessage(RemoteMessage message) {
  Future.delayed(Duration(seconds: 1), () {
    streamController.add('home');
  });
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotification();
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'a2f0af05c136aff5517f6245755d787d',
    javaScriptAppKey: '3b750bac44af65011c7bb5f31612eda6',
  );
  await initializeDateFormatting();
  auth = FirebaseAuth.instanceFor(app: app);
  setupInteractedMessage();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var messageString = "";

  Future<String> getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    logger.d("디바이스 토큰: $token");
    if (token != null) {
      return token;
    } else {
      return 'tempToken';
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('Got a message whilst in the foreground!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        logger.d(
            'Message also contained a notification: ${message.notification}');
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var deviceToken = await getMyDeviceToken();
      Restful.deviceTokenReporting('YEOPJONG', deviceToken);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainFrame(),
    );
  }
}
