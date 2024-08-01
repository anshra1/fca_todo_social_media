import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';

import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/only_todo_view_shell.dart';

class PublicTodos extends OnlyTodoShell {
  const PublicTodos({super.key})
      : super(
          isFloatingActionButton: true,
          title: 'Public',
          type: true,
          listOfTodo: _getPublicTodos,
        );

  static List<Todo> _getPublicTodos() {
    return HiveBox.taskBox.values.where((todo) {
      return todo.type == Strings.public;
    }).toList();
  }

  static const routeName = 'private-todos';
}
