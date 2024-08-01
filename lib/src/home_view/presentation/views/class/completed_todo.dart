import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/show_all_folder_view_shell.dart';

class CompletedTodoView extends ShowAllFoldersShell {
  const CompletedTodoView({super.key})
      : super(
          title: 'Completed',
          isFloatingActionButton: false,
          filterFolderTodosFunc: _getCompletedTodos,
          listOfTodoFunction: _getCompletedTodosAll,
        );

  static List<Todo> _getCompletedTodos(String folderName) {
    return HiveBox.taskBox.values
        .where(
          (todo) => todo.isCompleted && todo.folderName == folderName,
        )
        .toList();
  }

  static List<Todo> _getCompletedTodosAll() {
    return HiveBox.taskBox.values.where((todo) => todo.isCompleted).toList();
  }

  static const routeName = 'completed-todo-view';
}
