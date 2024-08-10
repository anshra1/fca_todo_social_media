import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/only_todo_view_shell.dart';

class ImportantTodos extends HookWidget {
  const ImportantTodos({super.key});

  static const routeName = 'important-todos-view';

  static List<Todo> _getImportantTodos(bool showCompleted) {
    return HiveBox.taskBox.values.where((todo) {
      return todo.isImportant == true &&
          (showCompleted || todo.isCompleted == false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final showCompletedTaskNotifier = useState<bool>(false);
    return OnlyTodoShell(
      title: 'Important',
      type: true,
      listOfTodo: () => _getImportantTodos(showCompletedTaskNotifier.value),
      showImportantSheetTile: false,
      showCompletedTask: true,
      isFloatingActionButton: false,
      showCompletedTaskNotifier: showCompletedTaskNotifier,
      onShowCompletedTasksChanged: () =>
          showCompletedTaskNotifier.value = !showCompletedTaskNotifier.value,
    );
  }
}
