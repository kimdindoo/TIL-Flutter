import 'package:firebase_cli/notification_controller2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('MessagePage >> build');

    return Container(
      color: Colors.red,
      child: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                NotificationController2.to.remoteMessage.value.notification!.title.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0,),
              Text(
                NotificationController2.to.remoteMessage.value.notification!.body.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0,),
              Text(
                NotificationController2.to.dateTime.value.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
