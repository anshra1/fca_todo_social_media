import 'package:flutter/material.dart';

extension ColorToString on Color {
  String toHex() => value.toRadixString(16).padLeft(8, '0');
}

extension StringToColor on String {}
