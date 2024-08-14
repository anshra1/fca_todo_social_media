import 'package:flutter/widgets.dart';

extension FunctionExt on VoidCallback {
  void executeAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this();
    });
  }
}
