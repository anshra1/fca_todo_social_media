import 'package:flutter/widgets.dart';
import 'package:flutter_learning_go_router/core/extension/date_time_extension.dart';
import 'package:intl/intl.dart';

extension StringExt on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }

  Color toColor() => Color(int.parse(this, radix: 16));

  bool isValidDateTime() {
    try {
      DateTime.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  DateTime fromDueDateString() {
    final formatter = DateFormat('Due EEE, d MMM');
    final dateString = replaceFirst('Due ', '');
    return formatter.parse(dateString);
  }

  DateTime? toDate() {
    if (isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(this);
    } on FormatException {
      try {
        return fromDueDateString();
      } catch (e) {
        return null;
      }
    }
  }

  bool correctDateCheck() {
    try {
      DateTime.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  String toDueDateString() {
    try {
      final date = DateTime.parse(this);
      return date.toDueDateString();
    } catch (e) {
      return this;
    }
  }
}
