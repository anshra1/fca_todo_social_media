
part of '../import.dart';
Color _getColor(DateTime? date) {
  if (date == null) return Colors.grey;
  return DateTime.now().isBefore(DateTime(date.year, date.month, date.day))
      ? Colors.grey.shade700
      : Colors.red;
}

class CustomListTile extends HookWidget {
  const CustomListTile({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          children: [
            7.gap,
            GestureDetector(
              onTap: () =>
                  context.read<TodoCubit>().updateCompleted(todo.todoId),
              child: todo.isCompleted
                  ? const CircularContainer(
                      color: Colors.pink,
                      boxShape: BoxShape.circle,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      color: Colors.black,
                    ),
            ),
            7.gap,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.todoName,
                    style: p17.copyWith(
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  3.gap,
                  if (todo.dueTime.isNotEmpty && todo.dueTime.toDate() != null)
                    Text(
                      todo.dueTime.toDate()!.toDueDateString(),
                      style:
                          p13.copyWith(color: _getColor(todo.dueTime.toDate())),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  context.read<TodoCubit>().updateMakeImportant(todo.todoId),
              child: Icon(
                todo.isImportant ? Icons.star : Icons.star_border,
                color: todo.isImportant ? Colors.pink : Colors.black,
              ),
            ),
            15.gap,
          ],
        ),
      ),
    );
  }
}
