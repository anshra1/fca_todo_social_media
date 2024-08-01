// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/show_all_folder_view_shell.dart';

class AllTodosView extends ShowAllFoldersShell {
  const AllTodosView({
    super.key,
  }) : super(
          title: 'All',
          isFloatingActionButton: true,
          filterFolderTodosFunc: _getTodosAsFolder,
          listOfTodoFunction: _getTodos,
        );

  static List<Todo> _getTodosAsFolder(String folderName) {
    return HiveBox.taskBox.values
        .where((todo) => !todo.isCompleted && todo.folderName == folderName)
        .toList();
  }

  static List<Todo> _getTodos() {
    return HiveBox.taskBox.values.where((todo) => !todo.isCompleted).toList();
  }

  static const routeName = 'all-todos-view';
}
