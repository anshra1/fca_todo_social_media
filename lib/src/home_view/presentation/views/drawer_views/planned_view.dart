part of '../../import.dart';

sealed class PlannedManager {
  static List<DateTime> getSortedDates(Map<DateTime, List<Todo>> groupedTodos) {
    return groupedTodos.keys.toList()
      ..sort((a, b) =>
          b.millisecondsSinceEpoch.compareTo(a.millisecondsSinceEpoch));
  }

  static List<Todo> getIncompleteTodos() {
    return TodoManager.todoList.where((todo) => !todo.isCompleted).toList();
  }
}

class PlannedView extends StatelessWidget {
  const PlannedView({super.key});

  static const routeName = 'all-planned-view';

  @override
  Widget build(BuildContext context) {
    return const BaseDateGroupedTodosView(
      title: 'Planned',
      listOfTodo: PlannedManager.getIncompleteTodos,
    );
  }
}

class BaseDateGroupedTodosView extends HookWidget {
  const BaseDateGroupedTodosView({
    required this.title,
    required this.listOfTodo,
    super.key,
  });

  final String title;
  final List<Todo> Function() listOfTodo;

  static const routeName = 'date-grouped-todos-view';

  @override
  Widget build(BuildContext context) {
    return BaseClass(
      title: title,
      isSort: false,
      isFloatingActionButton: true,
      settingNotifier: ValueNotifier<Setting>(
        // HiveBox.settingBox.get(title) ?? Setting.defaultSetting(),
        TodoManager.getViewSelectedSetting(title),
      ),
      body: ValueListenableBuilder<Box<Todo>>(
        valueListenable: TodoManager.taskBoxListenable,
        builder: (context, box, _) {
          final todos = listOfTodo();

          final groupedTodos = groupBy(
            todos.where(
              (todo) {
                return todo.dueTime.isNotEmpty &&
                    todo.dueTime.isValidDateTime();
              },
            ),
            (Todo todo) {
              final date = DateTime.parse(todo.dueTime);

              return DateTime(date.year, date.month, date.day);
            },
          );

          final sortedDates = PlannedManager.getSortedDates(groupedTodos);

          return GroupedTodosListView(
            sortedDates: sortedDates,
            groupedTodos: groupedTodos,
          );
        },
      ),
    );
  }
}

class GroupedTodosListView extends StatelessWidget {
  const GroupedTodosListView({
    required this.sortedDates,
    required this.groupedTodos,
    super.key,
  });

  final List<DateTime> sortedDates;
  final Map<DateTime, List<Todo>> groupedTodos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final todosForDate = groupedTodos[date] ?? [];
        return DateGroup(date: date, todos: todosForDate);
      },
    );
  }
}

class DateGroup extends HookWidget {
  const DateGroup({
    required this.date,
    required this.todos,
    super.key,
  });

  final DateTime date;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FolderTile(
          onPressed: () => isExpanded.value = !isExpanded.value,
          title: DateFormat('MMMM d, yyyy').format(date),
          isCollapse: isExpanded.value,
        ),
        AnimatedCrossFade(
          firstChild: Column(
            children: todos.map((todo) => CustomListTile(todo: todo)).toList(),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded.value
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
