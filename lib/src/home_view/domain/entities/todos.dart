import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'todos.g.dart';

@HiveType(typeId: 1)
class Todo extends Equatable {
  const Todo({
    required this.todoName,
    required this.date,
    required this.todoId,
    required this.type,
    required this.uid,
    required this.userName,
    required this.dueTime,
    this.isDelete = false,
    this.isImportant = false,
    this.isCompleted = false,
    this.folderId = 'Task',
  });

  const Todo.defaults({
    required String uid,
    required String userName,
    required String todoId,
    required String todoName,
    required DateTime time,
    required String type,
    required String folderId,
    required bool important,
    String? dueTime,
  }) : this(
          todoId: todoId,
          todoName: todoName,
          date: time,
          type: type,
          uid: uid,
          userName: userName,
          isImportant: important,
          isCompleted: false,
          folderId: folderId,
          dueTime: dueTime ?? '',
        );

  Todo.empty()
      : this(
          todoId: 'empty_todoId',
          todoName: 'todoName',
          date: DateTime.now().toUtc(),
          type: 'private',
          uid: 'uid',
          userName: 'ansh',
          isImportant: true,
          isCompleted: false,
          folderId: 'Tasks',
          dueTime: DateTime.now().toIso8601String(),
        );

  @HiveField(1)
  final String todoId;

  @HiveField(2)
  final String todoName;

  @HiveField(3)
  final bool isImportant;

  @HiveField(4)
  final String folderId;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final String uid;

  @HiveField(8)
  final String userName;

  @HiveField(9)
  final String type;

  @HiveField(10)
  final bool isDelete;

  @HiveField(11)
  final String dueTime;

  @override
  String toString() {
    return 'LocalTask{'
        'todoId: $todoId, '
        'todoName: $todoName, '
        'isImportant: $isImportant, '
        'isCompleted: $isCompleted, '
        'date: $date, '
        'type: $type, '
        'uid: $uid, '
        'folderId: $folderId, '
        'userName: $userName}';
  }

  @override
  List<Object?> get props => [
        todoId,
        todoName,
        isImportant,
        isCompleted,
        date,
        type,
        uid,
        folderId,
        userName,
      ];
}
