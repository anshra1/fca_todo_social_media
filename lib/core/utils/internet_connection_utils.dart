import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_learning_go_router/core/extension/object_extension.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionUtils {
  InternetConnectionUtils._();

  static (StreamSubscription<InternetStatus>, bool)
      startListeningInternetStatus(
    BuildContext context,
  ) {
    var kstatus = false;
    var internetCheck = false;

    final listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          internetCheck = true;
          if (kstatus) {
            CoreUtils.showSnackBar(
              context,
              'Your Internet is Restored',
            );
          }

        case InternetStatus.disconnected:
          kstatus = true;
          internetCheck = false;
          CoreUtils.showSnackBar(
            context,
            'Please check your internet connection',
          );
      }
    });

    return (listener, internetCheck);
  }

  static StreamSubscription<InternetStatus> listenToInternetStatus({
    VoidCallback? onInternetConnected,
    VoidCallback? onInternetDisconnected,
    VoidCallback? onDone,
    Function(Object, StackTrace)? onError,
  }) {
    var subcription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            onInternetConnected?.call();
          case InternetStatus.disconnected:
            onInternetDisconnected?.call();
        }
      },
      onError: (error, stackTrace) {
        onError?.call(error, stackTrace);
      },
      onDone: () {
        onDone?.call();
      },
    );
    return subcription;
  }

  static Future<bool> get haveInternet async =>
      await InternetConnection().hasInternetAccess;
}
