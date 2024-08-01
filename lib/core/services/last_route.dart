import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _saveLastRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _saveLastRoute(newRoute);
    }
  }

  Future<void> _saveLastRoute(Route<dynamic> route) async {
    if (route.settings.name != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastRoute', route.settings.name!);

      print('Last route saved: ${route.settings.name}');
      await HiveBox.commonBox.put('lastRoute', Common(route.settings.name!));
    }
  }
}
