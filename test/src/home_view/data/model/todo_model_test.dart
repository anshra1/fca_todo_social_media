import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_learning_go_router/core/enum/file_type.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/todo_model.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTodo = Todo.defaults(
    uid: 'uid',
    userName: 'ansh',
    important: false,
    todoId: 'todoId',
    todoName: 'todoName',
    time: DateTime.now(),
    type: '',
    folderName: '',
  );

  test(
    'timestamp',
    () async {},
  );

  final map = {
    Strings.todoName: 'Test Todo',
    Strings.date: Timestamp.fromDate(DateTime(2023, 10)),
    Strings.todoId: '123',
    Strings.type: 'private',
    Strings.uid: 'uid_123',
    Strings.userName: 'test_user',
    Strings.isImportant: false,
    Strings.isCompleted: false,
    Strings.folderName: 'test_folder',
  };

  test(
    'should be sublclass of Todo',
    () async {
      expect(tTodo, isA<Todo>());
    },
  );

  test(
    'creating_todo_model_with_all_required_fields',
    () {
      final todo = tTodo;

      expect(todo.todoName, 'Test Todo');
      expect(todo.date, DateTime(2023, 10));
      expect(todo.todoId, '123');
      expect(todo.type, TodoType.Private.value);
      expect(todo.uid, 'uid_123');
      expect(todo.userName, 'test_user');
      expect(todo.isImportant, false);
      expect(todo.isCompleted, false);
      expect(todo.folderName, 'test_folder');
    },
  );

  test(
    'from_map',
    () {
      final todo = TodoModel.fromMap(map);

      expect(todo, tTodo);
      expect(todo.todoName, 'Test Todo');
      expect(todo.date, DateTime(2023, 10));
      expect(todo.todoId, '123');
      expect(todo.type, 'private');
      expect(todo.uid, 'uid_123');
      expect(todo.userName, 'test_user');
      expect(todo.isImportant, false);
      expect(todo.isCompleted, false);
      expect(todo.folderName, 'test_folder');
    },
  );

  test(
    'should return a JSON map containing the proper data',
    () {
      final result = (tTodo as TodoModel).toMap()..remove(Strings.date);

      expect(result, map..remove(Strings.date));
    },
  );

  test('copyWith should return a copy with updated values', () {
    final updatedTodo = (tTodo as TodoModel).copyWith(
      todoName: 'Updated Todo',
      isImportant: true,
    );
    expect(updatedTodo.todoName, 'Updated Todo');
    expect(updatedTodo.isImportant, true);
    expect(updatedTodo.date, tTodo.date);
    expect(updatedTodo.todoId, tTodo.todoId);
    expect(updatedTodo.type, tTodo.type);
    expect(updatedTodo.uid, tTodo.uid);
    expect(updatedTodo.userName, tTodo.userName);
    expect(updatedTodo.isCompleted, tTodo.isCompleted);
    expect(updatedTodo.folderName, tTodo.folderName);
  });
}
