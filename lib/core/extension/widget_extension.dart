import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension WidgetExt on Widget {
  Widget get shrinkSizedBox => const SizedBox.shrink();

  Widget get center => const SizedBox.shrink();

  Widget leftPadding(double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: this,
    );
  }

  Widget topPadding(double padding) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: this,
    );
  }

  Widget allPadding(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}
