import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension IntExt on int {
  String get timer {
    if (this < 10) {
      return '0$this';
    }
    return '$this';
  }

  Widget get gap => Gap(double.parse(toDouble().toStringAsFixed(1)));
}
