import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/screens/1_basic_screen.dart';

import '../screens/root_screen.dart';

// https://blog.codefactory.ai -> / -> path
// https://blog/codefactory.ai/flutter -> /flutter
// / -> home
// /basic -> basic screen
// /basic/basic_two ->
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const RootScreen();
      },
      routes: [
        GoRoute(
          path: 'basic',
          builder: (context, state) {
            return const BasicScreen();
          },
        ),
      ],
    ),
  ],
);
