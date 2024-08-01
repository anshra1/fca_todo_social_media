import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:flutter_learning_go_router/core/extension/color_extension.dart';
import 'package:hive/hive.dart';

part 'user_selected_setting.g.dart';

@HiveType(typeId: 10)
class Setting {
  Setting({
    required this.sortCriteria,
    required this.colorName,
  });

  Setting.defaultSetting()
      : sortCriteria = SortCriteria.none,
        colorName = Colors.green.shade900.toHex();

  @HiveField(0)
  final SortCriteria sortCriteria;

  @HiveField(1)
  final String colorName;

  Setting copyWith({
    SortCriteria? sortCriteria,
    String? colorName,
  }) {
    return Setting(
      sortCriteria: sortCriteria ?? this.sortCriteria,
      colorName: colorName ?? this.colorName,
    );
  }

  @override
  String toString() {
    return 'ViewSelectedSetting{sortCriteria: $sortCriteria, colorName: $colorName}';
  }
}
