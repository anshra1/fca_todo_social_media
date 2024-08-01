import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';

import 'package:flutter_learning_go_router/src/home_view/data/datasources/remote_data_source.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class AuthTodoImpl implements TodoRepo {
  AuthTodoImpl({required TodoRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final TodoRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> addTask(Todo todo) async {
    try {
      await _remoteDataSource.addTask(todo);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> createFolders(Folder folderName) async {
    try {
      await _remoteDataSource.createFolders(folderName);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteFolders(String folderId) async {
    try {
      await _remoteDataSource.deleteFolders(folderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteMultipleTodo(List<Todo> todoList) async {
    try {
      await _remoteDataSource.deleteMultipleTodo(todoList);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteTodo(String todoId) async {
    try {
      await _remoteDataSource.deleteTodo(todoId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> firstTimeLoad() async {
    try {
      await _remoteDataSource.firstTimeLoad();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Folder>> getFolders() async {
    try {
      final folders = await _remoteDataSource.getFolders();
      return Right(folders);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Todo>> getTodos(String filterData) async {
    try {
      final filteredTodos = await _remoteDataSource.getTodos(filterData);
      return Right(filteredTodos);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> startListening() async {
    try {
      await _remoteDataSource.startListening();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> stopListening() async {
    try {
      await _remoteDataSource.stopListening();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sync() async {
    try {
      await _remoteDataSource.sync();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateCompleted(String todoId) async {
    try {
      await _remoteDataSource.updateCompleted(todoId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateMakeImportant(String todoId) async {
    try {
      await _remoteDataSource.updateMakeImportant(todoId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateNameTodo({
    required String todoID,
    required String newTodoName,
  }) async {
    try {
      await _remoteDataSource.updateNameTodo(todoID, newTodoName);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateFolder({
    required String folderId,
    required String newFolderName,
  }) async {
    try {
      await _remoteDataSource.updateFolder(folderId, newFolderName);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<Exception> streamError() {
    return _remoteDataSource.errorStream().transform(
          StreamTransformer<Exception, Either<Failure, Exception>>.fromHandlers(
            handleData: (exception, sink) {
              sink.add(Right(exception));
            },
            handleError: (error, stackTrace, sink) {
              if (error is ServerException) {
                sink.add(Left(ServerFailure.fromException(error)));
              } else {
                sink.add(
                  Left(ServerFailure(message: error.toString(), statusCode: 0)),
                );
              }
            },
          ),
        );
  }

  @override
  ResultFuture<void> newDeleteFolders(String folderId) {
    // TODO: implement newDeleteFolders
    throw UnimplementedError();
  }
}
