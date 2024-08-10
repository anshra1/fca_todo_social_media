import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/import.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/drawer_views/public_todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/home_screen.dart';
import 'package:flutter_learning_go_router/src/profile/views/profile_view.dart';
import 'package:flutter_learning_go_router/src/public_view/public_view.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AppBottomNavigation extends HookWidget {
  const AppBottomNavigation(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        return null;

        // final subcription = FireStoreTaskStream.getTasksStream();
        // return subcription.cancel;
      },
      [],
    );
    return Scaffold(
      body: child,
      bottomNavigationBar: SalomonBottomBar(
        items: _navigationItem,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}

int _calculateSelectedIndex(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();

  if (location.startsWith(HomeClass.routeName)) {
    return 0;
  }

  if (location.startsWith(PublicView.routeName)) {
    return 1;
  }
  if (location.startsWith(ProfileView.routeName)) {
    return 2;
  }
  return 0;
}

void _onTap(
  BuildContext context,
  int index,
) {
  switch (index) {
    case 0:
      context.go(HomeClass.routeName);
    case 1:
      context.go(PublicView.routeName);
    case 2:
      context.go(ProfileView.routeName);
    default:
      break;
  }
}

var _navigationItem = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text('Home'),
    selectedColor: Colors.purple,
  ),

  /// Likes
  SalomonBottomBarItem(
    icon: const Icon(Icons.data_array),
    title: const Text('Public'),
    selectedColor: Colors.pink,
  ),

  SalomonBottomBarItem(
    icon: const Icon(Icons.verified_user),
    title: const Text('Profile'),
    selectedColor: Colors.pink,
  ),
];
