import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_learning_go_router/core/enum/file_type.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.todoName,
    required super.date,
    required super.todoId,
    required super.type,
    required super.uid,
    required super.userName,
    required super.dueTime,
    super.isImportant,
    super.isCompleted,
    super.folderName,
    super.isDelete,
  });

  factory TodoModel.fromTodo(Todo todo) {
    return TodoModel(
      todoName: todo.todoName,
      date: todo.date,
      todoId: todo.todoId,
      type: todo.type,
      uid: todo.uid,
      userName: todo.userName,
      isImportant: todo.isImportant,
      isCompleted: todo.isCompleted,
      folderName: todo.folderName,
      dueTime: todo.dueTime,
    );
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      todoName: map[Strings.todoName] as String? ?? '',
      date: ((map[Strings.date] as Timestamp).toDate()) as DateTime? ?? DateTime.now(),
      todoId: map[Strings.todoId] as String? ?? '',
      type: map[Strings.type] as String? ?? '',
      uid: map[Strings.uid] as String? ?? '',
      userName: map[Strings.userName] as String? ?? '',
      isImportant: map[Strings.isImportant] as bool? ?? false,
      isCompleted: map[Strings.isCompleted] as bool? ?? false,
      folderName: map[Strings.folderName] as String? ?? '',
      dueTime: map[Strings.dueTime] as String? ?? '',
      isDelete: map[Strings.isDeleted] as bool? ?? false,
    );
  }

  factory TodoModel.empty() {
    return TodoModel(
      todoName: 'Test Todo',
      date: DateTime.now(),
      todoId: '123',
      type: TodoType.Private.value,
      uid: 'uid_123',
      userName: 'test_user',
      folderName: 'test_folder',
      dueTime: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Strings.todoName: todoName,
      Strings.date: date,
      Strings.todoId: todoId,
      Strings.type: type,
      Strings.uid: uid,
      Strings.userName: userName,
      Strings.isImportant: isImportant,
      Strings.isCompleted: isCompleted,
      Strings.folderName: folderName,
      Strings.dueTime: dueTime,
      Strings.isDeleted: isDelete,
    };
  }

  TodoModel copyWith({
    String? todoName,
    DateTime? date,
    String? todoId,
    String? type,
    String? uid,
    String? userName,
    bool? isImportant,
    bool? isCompleted,
    String? folderName,
    bool? isDelete,
    String? dueTime,
  }) {
    return TodoModel(
      todoName: todoName ?? this.todoName,
      date: date ?? this.date,
      todoId: todoId ?? this.todoId,
      type: type ?? this.type,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      isImportant: isImportant ?? this.isImportant,
      isCompleted: isCompleted ?? this.isCompleted,
      folderName: folderName ?? this.folderName,
      dueTime: dueTime ?? this.dueTime,
      isDelete: isDelete ?? this.isDelete,
    );
  }

  @override
  String toString() {
    return 'TodoModel{'
        'todoName: $todoName, '
        'date: $date, '
        'todoId: $todoId, '
        'type: $type, '
        'uid: $uid, '
        'userName: $userName, '
        'isImportant: $isImportant, '
        'isCompleted: $isCompleted, '
        'dueTime: $dueTime, '
        'isDeleted: $isDelete, '
        'folderName: $folderName}';
  }
}
