import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController2 extends GetxController {
  static NotificationController2 get to => Get.find();

  // 최신버전의 초기화 방법
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Rx<RemoteMessage> remoteMessage = const RemoteMessage().obs;

  // remoteMessage 가 obx 에서 검출이 잘되지 않아서 dateTime 을 추가함
  Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  void onInit() {
    _initNotification();
    // 토큰을 알면 특정 디바이스에게 문자를 전달가능
    _getToken();

    super.onInit();
  }

  void _getToken() {
    _messaging.getToken().then((token) {
      debugPrint('token~: [$token]');
    });
  }

  void _initNotification() {
    // 앱이 동작중일때 호출됨
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _addNotification(event);
      debugPrint("NotificationController >> message received");
      debugPrint('Title >> ${event.notification!.title.toString()}');
      debugPrint('Body >> ${event.notification!.body.toString()}');
    });
    // 앱이 background 동작중일때 호출됨, 종료중일때도 호출됨?
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _addNotification(message);
      debugPrint('------------------------Message clicked!');
    });

  }

  // 메시지를 변수에 저장
  void _addNotification(RemoteMessage event) {
    dateTime(event.sentTime);
    remoteMessage(event);
    // debugPrint(event.toMap().toString());
    debugPrint(dateTime.toString());
  }
}
