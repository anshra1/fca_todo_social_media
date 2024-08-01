// ignore_for_file: lines_longer_than_80_chars, require_trailing_commas

import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/src/home_view/data/datasources/remote_data_source.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
import 'package:flutter_learning_go_router/src/home_view/data/repo/todo_repo_impl.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

void main() {
  late AuthTodoImpl repository;
  late MockTodoRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTodoRemoteDataSource();
    repository = AuthTodoImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('addTask', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      final todo = Todo.empty();
      when(() => mockRemoteDataSource.addTask(todo))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.addTask(todo);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.addTask(todo)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      final todo = Todo.empty();
      when(() => mockRemoteDataSource.addTask(todo)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.addTask(todo);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(message: 'Error addTask', statusCode: '500'),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.addTask(todo)).called(1);
    });
  });

  group('createFolders', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const folder = FolderModel.empty();
      when(() => mockRemoteDataSource.createFolders(folder))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.createFolders(folder);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.createFolders(folder)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const folder = FolderModel.empty();

      when(() => mockRemoteDataSource.createFolders(folder)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.createFolders(folder);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(message: 'Error createFolders', statusCode: '500'),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.createFolders(folder)).called(1);
    });
  });

  group('getTodos', () {
    test(
        'should return Right(List<Todo>) when the call to remote data source is successful',
        () async {
      // Arrange
      final todos = [Todo.empty()];

      when(
        () => mockRemoteDataSource.getTodos(
          'test',
        ),
      ).thenAnswer((_) async => todos);

      // Act
      final result = await repository.getTodos(
        'test',
      );

      // Assert
      expect(result, equals(Right<Failure, List<Todo>>(todos)));

      verify(
        () => mockRemoteDataSource.getTodos(
          'test',
        ),
      ).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange

      when(
        () => mockRemoteDataSource.getTodos(
          'test',
        ),
      ).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.getTodos(
        'test',
      );

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, List<Todo>>(
            ServerFailure(message: 'Error getTodos', statusCode: '500'),
          ),
        ),
      );
      verify(
        () => mockRemoteDataSource.getTodos('test'),
      ).called(1);
    });
  });

  group('deleteFolders', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const folderId = '1';

      when(() => mockRemoteDataSource.deleteFolders(folderId))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteFolders(folderId);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.deleteFolders(folderId)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const folderId = '1';

      when(() => mockRemoteDataSource.deleteFolders(folderId)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.deleteFolders(folderId);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(message: 'Error deleteFolders', statusCode: '500'),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.deleteFolders(folderId)).called(1);
    });
  });

  group('deleteMultipleTodo', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      final todos = [Todo.empty()];

      when(() => mockRemoteDataSource.deleteMultipleTodo(todos))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteMultipleTodo(todos);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.deleteMultipleTodo(todos)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      final todos = [Todo.empty()];

      when(() => mockRemoteDataSource.deleteMultipleTodo(todos)).thenThrow(
        const ServerException(
          message: 'Error',
          statusCode: '500',
        ),
      );

      // Act
      final result = await repository.deleteMultipleTodo(todos);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(
              message: 'Error deleteMultipleTodo',
              statusCode: '500',
            ),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.deleteMultipleTodo(todos)).called(1);
    });
  });

  group('deleteTodo', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.deleteTodo(todoId))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteTodo(todoId);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.deleteTodo(todoId)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.deleteTodo(todoId)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.deleteTodo(todoId);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(message: 'Error deleteTodo', statusCode: '500'),
          ),
        ),
      );

      verify(() => mockRemoteDataSource.deleteTodo(todoId)).called(1);
    });
  });

  group('firstTimeLoad', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.firstTimeLoad())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.firstTimeLoad();

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.firstTimeLoad()).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.firstTimeLoad()).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.firstTimeLoad();

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
            ServerFailure(message: 'Error firstTimeLoad', statusCode: '500'),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.firstTimeLoad()).called(1);
    });
  });

  group('getFolders', () {
    test(
        'should return Right(List<Folder>) when the call to remote data source is successful',
        () async {
      // Arrange
      final folders = [const FolderModel.empty()];

      when(() => mockRemoteDataSource.getFolders())
          .thenAnswer((_) async => folders);

      // Act
      final result = await repository.getFolders();

      // Assert
      expect(result, equals(Right<Failure, List<Folder>>(folders)));

      verify(() => mockRemoteDataSource.getFolders()).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getFolders()).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.getFolders();

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, List<Folder>>(
            ServerFailure(message: 'Error getFolders', statusCode: '500'),
          ),
        ),
      );
      verify(() => mockRemoteDataSource.getFolders()).called(1);
    });
  });

  // ... (continuing with the remaining methods)
  group('startListening', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.startListening())
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.startListening();

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.startListening()).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.startListening()).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.startListening();

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(ServerFailure(
              message: 'Error startListening', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.startListening()).called(1);
    });
  });

  group('stopListening', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.stopListening())
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.stopListening();

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.stopListening()).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.stopListening()).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.stopListening();

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
              ServerFailure(message: 'Error stopListening', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.stopListening()).called(1);
    });
  });

  group('sync', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.sync()).thenAnswer((_) async => {});

      // Act
      final result = await repository.sync();

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => mockRemoteDataSource.sync()).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.sync()).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.sync();

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
              ServerFailure(message: 'Error sync', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.sync()).called(1);
    });
  });

  group('updateCompleted', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.updateCompleted(todoId))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.updateCompleted(todoId);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.updateCompleted(todoId)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.updateCompleted(todoId)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.updateCompleted(todoId);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(ServerFailure(
              message: 'Error updateCompleted', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.updateCompleted(todoId)).called(1);
    });
  });

  group('updateMakeImportant', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.updateMakeImportant(todoId))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.updateMakeImportant(todoId);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.updateMakeImportant(todoId)).called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const todoId = '1';

      when(() => mockRemoteDataSource.updateMakeImportant(todoId)).thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.updateMakeImportant(todoId);

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(ServerFailure(
              message: 'Error updateMakeImportant', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.updateMakeImportant(todoId)).called(1);
    });
  });

  group('updateNameTodo', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const todoId = '1';
      const newTodoName = 'Updated Todo';
      when(() => mockRemoteDataSource.updateNameTodo(todoId, newTodoName))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.updateNameTodo(
        todoID: todoId,
        newTodoName: newTodoName,
      );

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.updateNameTodo(todoId, newTodoName))
          .called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const todoId = '1';
      const newTodoName = 'Updated Todo';
      when(() => mockRemoteDataSource.updateNameTodo(todoId, newTodoName))
          .thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.updateNameTodo(
        todoID: todoId,
        newTodoName: newTodoName,
      );

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(ServerFailure(
              message: 'Error updateNameTodo', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.updateNameTodo(todoId, newTodoName))
          .called(1);
    });
  });

  group('updateFolder', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      const folderId = '1';
      const newFolderName = 'Updated Folder';
      when(() => mockRemoteDataSource.updateFolder(folderId, newFolderName))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.updateFolder(
        folderId: folderId,
        newFolderName: newFolderName,
      );

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(() => mockRemoteDataSource.updateFolder(folderId, newFolderName))
          .called(1);
    });

    test(
        'should return Left(ServerFailure) when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      const folderId = '1';
      const newFolderName = 'Updated Folder';

      when(() => mockRemoteDataSource.updateFolder(folderId, newFolderName))
          .thenThrow(
        const ServerException(message: 'Error', statusCode: '500'),
      );

      // Act
      final result = await repository.updateFolder(
        folderId: folderId,
        newFolderName: newFolderName,
      );

      // Assert
      expect(
        result,
        equals(
          const Left<Failure, void>(
              ServerFailure(message: 'Error updateFolder', statusCode: '500')),
        ),
      );
      verify(() => mockRemoteDataSource.updateFolder(folderId, newFolderName))
          .called(1);
    });
  });
}
