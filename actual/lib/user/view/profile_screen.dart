import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_me_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        ref.read(userMeProvider.notifier).logout();
      },
      child: const Text('로그아웃'),
    ));
  }
}
