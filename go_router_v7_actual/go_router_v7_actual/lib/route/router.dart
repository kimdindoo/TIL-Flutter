import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/screens/1_basic_screen.dart';
import 'package:go_router_v7_actual/screens/3_push_screen.dart';
import 'package:go_router_v7_actual/screens/4_pop_base_screen.dart';
import 'package:go_router_v7_actual/screens/5_pop_return_screen.dart';
import 'package:go_router_v7_actual/screens/6_path_param_screen.dart';
import 'package:go_router_v7_actual/screens/7_query_parameter.dart';
import 'package:go_router_v7_actual/screens/8_%20nested_screen.dart';
import 'package:go_router_v7_actual/screens/8_nested_child_screen.dart';

import '../screens/root_screen.dart';

// https://blog.codefactory.ai -> / -> path
// https://blog/codefactory.ai/flutter -> /flutter
// / -> home
// /basic -> basic screen
// /basic/basic_two ->
// /named
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
        GoRoute(
          path: 'named',
          name: 'named_screen',
          builder: (context, state) {
            return const BasicScreen();
          },
        ),
        GoRoute(
          path: 'push',
          builder: (context, state) {
            return const PushScreen();
          },
        ),
        GoRoute(
          path: 'pop',
          builder: (context, state) {
            // /pop
            return const PopBaseScreen();
          },
          routes: [
            GoRoute(
              path: 'return',
              builder: (context, state) {
                // /pop/return
                return const PopReturnScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'path_param/:id', // /path_param/123
          builder: (context, state) {
            return const PathParamScreen();
          },
          routes: [
            GoRoute(
              path: ':name', // /path_param/123/sub_path_param/456
              builder: (context, state) {
                return const PathParamScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'query_param',
          builder: (context, state) {
            return const QueryParameterScreen();
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            return NestedScreen(child: child);
          },
          routes: [
            // /nested/a
            GoRoute(
              path: 'nested/a',
              builder: (_, state) {
                return const NestedChildScreen(
                  routeName: 'nested/a',
                );
              },
            ),
            // /nested/b
            GoRoute(
              path: 'nested/b',
              builder: (_, state) {
                return const NestedChildScreen(
                  routeName: 'nested/b',
                );
              },
            ),
            // /nested/c
            GoRoute(
              path: 'nested/c',
              builder: (_, state) {
                return const NestedChildScreen(
                  routeName: 'nested/c',
                );
              },
            ),
          ],
        )
      ],
    ),
  ],
);
