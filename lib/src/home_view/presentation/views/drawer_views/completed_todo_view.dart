
part of '../../import.dart';

class CompletedTodoView extends ShowAllFoldersShell {
  const CompletedTodoView({super.key})
      : super(
          title: 'Completed',
          isFloatingActionButton: false,
          filterFolderTodosFunc: _getCompletedTodos,
          listOfTodoFunction: _getCompletedTodosAll,
        );

  static List<Todo> _getCompletedTodos(String folderName) {
    return TodoManager.todoList
        .where(
          (todo) => todo.isCompleted && todo.folderId == folderName,
        )
        .toList();
  }

  static List<Todo> _getCompletedTodosAll() {
    return TodoManager.todoList.where((todo) => todo.isCompleted).toList();
  }

  static const routeName = 'completed-todo-view';
}
