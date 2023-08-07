import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled1/layout/default_layout.dart';
import 'package:untitled1/riverpod/listen_provider.dart';

class ListenProvierScreen extends ConsumerStatefulWidget {
  const ListenProvierScreen({super.key});

  @override
  ConsumerState<ListenProvierScreen> createState() =>
      _ListenProvierScreenState();
}

class _ListenProvierScreenState extends ConsumerState<ListenProvierScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 10,
      vsync: this,
      initialIndex: ref.read(listenProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(listenProvider, (previous, next) {
      if (previous != next) {
        controller.animateTo(
          next,
        );
      }
    });

    return DefaultLayout(
      title: 'ListenProvierScreen',
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: List.generate(
          10,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                index.toString(),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(listenProvider.notifier)
                      .update((state) => state == 10 ? 10 : state + 1);
                },
                child: Text('다음'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(listenProvider.notifier)
                      .update((state) => state == 0 ? 0 : state - 1);
                },
                child: Text('이전'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
