// ignore_for_file: require_trailing_commas

import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';

abstract class TodoRepo {
  const TodoRepo();

  ResultFuture<void> addTask(Todo todo);

  ResultFuture<void> updateNameTodo(
      {required String todoID, required String newTodoName});

  ResultFuture<void> deleteTodo(String todoId);

  ResultFuture<void> deleteMultipleTodo(List<Todo> todoList);

  ResultFuture<List<Todo>> getTodos(String filterData);

  ResultFuture<void> sync();

  ResultFuture<void> createFolders(Folder folderName);

  ResultFuture<void> deleteFolders(String folderId);
  

  ResultFuture<void> updateFolder(
      {required String folderId, required String newFolderName});

  ResultFuture<List<Folder>> getFolders();

  ResultFuture<void> firstTimeLoad();

  ResultFuture<void> updateMakeImportant(String todoId);

  ResultFuture<void> updateCompleted(String todoId);

  ResultFuture<void> startListening();

  ResultFuture<void> stopListening();

  ResultStream<Exception> streamError();
}
