import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_bar_provider.dart';
export 'navigation_bar_provider.dart';

Widget navBar() {
  return Consumer(
    builder: (context, ref, child) {
      final currentIndex = ref.watch(bottomNavigationBarProvider);
      return NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sunny),
            label: "Trang chủ",
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_rounded),
            label: "Dự báo",
          ),
          NavigationDestination(
            icon: Icon(Icons.map_rounded),
            label: "Bản đồ",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
        selectedIndex: currentIndex,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        onDestinationSelected: (value) {
          // Update the selected index
          ref
              .read(bottomNavigationBarProvider.notifier)
              .update((state) => value);
        },
      );
    },
  );
}
