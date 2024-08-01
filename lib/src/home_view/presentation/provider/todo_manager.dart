// ignore_for_file: lines_longer_than_80_chars, require_trailing_commas
import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:flutter_learning_go_router/core/extension/color_extension.dart';
import 'package:flutter_learning_go_router/core/extension/string_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/user_settings/user_selected_setting.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoManager extends ChangeNotifier {
  TodoManager() {
    _updateTodos();
    HiveBox.taskBox.listenable().addListener(_updateTodos);
  }

  List<Todo> list = [];
  List<Todo> importantTodos = [];
  List<Todo> completedTodos = [];
  List<Todo> publicTodos = [];
  List<Todo> plannedTodos = [];
  Map<String, int> folderLengths = {};

  void _updateTodos() {
    list = HiveBox.taskBox.values.toList();
    importantTodos =
        list.where((todo) => todo.isImportant && !todo.isCompleted).toList();
    completedTodos = list.where((todo) => todo.isCompleted).toList();
    publicTodos = list.where((todo) => todo.type == Strings.public).toList();
    plannedTodos =
        list.where((todo) => todo.dueTime.correctDateCheck()).toList();
    folderLengths = {};
    for (final todo in list) {
      folderLengths[todo.folderName] =
          (folderLengths[todo.folderName] ?? 0) + 1;
    }

    notifyListeners();
  }

  int get importantLength => importantTodos.length;
  int get completedTodoLength => completedTodos.length;
  int get allTodoLength => list.length;
  int get publicTodoLength => publicTodos.length;
  int get plannedTodoLength => plannedTodos.length;
  int folderTodoLength(String folderName) => folderLengths[folderName] ?? 0;

  @override
  void dispose() {
    HiveBox.taskBox.listenable().removeListener(_updateTodos);
    super.dispose();
  }

  static void updateViewSelectedSetting({
    required String title,
    String? color,
    SortCriteria? sortCriteria,
  }) {
    final currentSetting = HiveBox.settingBox.get(title) ??
        Setting(
          sortCriteria: SortCriteria.none,
          colorName: Colors.green.shade900.toHex(),
        );

    final newSetting = Setting(
      sortCriteria: sortCriteria ?? currentSetting.sortCriteria,
      colorName: color ?? currentSetting.colorName,
    );

    HiveBox.settingBox.put(title, newSetting);
  }
}
