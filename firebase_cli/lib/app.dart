import 'package:firebase_cli/message_page.dart';
import 'package:firebase_cli/notification_controller2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase cloud Message"),
      ),
      body: Obx(() {
        // 메시지를 받으면 새로운 화면으로 전화하는 조건문
        if (NotificationController2.to.remoteMessage.value.messageId != null) {//message
          return const MessagePage();
        }
        return const Center(
          child: Text('Firebase cloud Message'),
        );
      }),
    );
  }
}