
part of '../../import.dart';

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
      isFloatingActionButton: true,
      showCompletedTaskNotifier: showCompletedTaskNotifier,
      onShowCompletedTasksChanged: () =>
          showCompletedTaskNotifier.value = !showCompletedTaskNotifier.value,
    );
  }
}
