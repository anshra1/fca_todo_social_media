// ignore_for_file: lines_longer_than_80_chars


part of '../../import.dart';

class AllTodosView extends ShowAllFoldersShell {
  const AllTodosView({
    super.key,
  }) : super(
          title: 'All',
          isFloatingActionButton: true,
          filterFolderTodosFunc: _getTodosAsFolder,
          listOfTodoFunction: _getTodos,
        );

  static List<Todo> _getTodosAsFolder(String folderId) {
    return HiveBox.taskBox.values
        .where((todo) => !todo.isCompleted && todo.folderId == folderId)
        .toList();
  }

  static List<Todo> _getTodos() {
    return HiveBox.taskBox.values.where((todo) => !todo.isCompleted).toList();
  }

  static const routeName = 'all-todos-view';
}
