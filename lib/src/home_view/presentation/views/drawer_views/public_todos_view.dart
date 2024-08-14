part of '../../import.dart';

class PublicTodos extends OnlyTodoShell {
  const PublicTodos({super.key})
      : super(
          isFloatingActionButton: true,
          title: 'Public',
          type: true,
          listOfTodo: _getPublicTodos,
        );

  static List<Todo> _getPublicTodos() {
    return TodoManager.todoList.where((todo) {
      return todo.type == Strings.public;
    }).toList();
  }

  static const routeName = 'private-todos';
}
