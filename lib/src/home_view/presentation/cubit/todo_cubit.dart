import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/core/enum/todo_views.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';

import 'package:flutter_learning_go_router/src/home_view/domain/usecases/add_task.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/create_folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_multiple_todo.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_todo.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/first_time_load.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/get_folders.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/get_todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/new_delete_folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/start_listening.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/stop_listening.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/stream_error.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/sync_todo.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_completed.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_make_important.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_name_todo.dart';
import 'package:uuid/uuid.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit({
    required AddTask addTask,
    required CreateFolder createFolder,
    required DeleteFolder deleteFolder,
    required DeleteMultipleTodo deleteMultipleTodo,
    required DeleteTodo deleteTodo,
    required FirstTimeLoad firstTimeLoad,
    required GetFolders getFolders,
    required GetTodos getTodos,
    required StartListenings startListening,
    required StopListenings stopListening,
    required SyncTodo sync,
    required UpdateCompleted updateCompleted,
    required UpdateMakeImportant updateMakeImportant,
    required UpdateNameTodo updateNameTodo,
    required UpdateFolder updateFolder,
    required StreamError streamError,
    required NewDeleteFolder newDeleteFolder,
  })  : _addTask = addTask,
        _createFolder = createFolder,
        _deleteFolder = deleteFolder,
        _deleteMultipleTodo = deleteMultipleTodo,
        _deleteTodo = deleteTodo,
        _firstTimeLoad = firstTimeLoad,
        _getFolders = getFolders,
        _getTodos = getTodos,
        _startListening = startListening,
        _stopListening = stopListening,
        _sync = sync,
        _streamError = streamError,
        _updateCompleted = updateCompleted,
        _updateMakeImportant = updateMakeImportant,
        _updateNameTodo = updateNameTodo,
        _updateFolder = updateFolder,
        _newDeleteFolder = newDeleteFolder,
        super(TodoInitial());

  final AddTask _addTask;
  final CreateFolder _createFolder;
  final DeleteFolder _deleteFolder;
  final DeleteMultipleTodo _deleteMultipleTodo;
  final DeleteTodo _deleteTodo;
  final FirstTimeLoad _firstTimeLoad;
  final GetFolders _getFolders;
  final GetTodos _getTodos;
  final StartListenings _startListening;
  final StopListenings _stopListening;
  final SyncTodo _sync;
  final UpdateCompleted _updateCompleted;
  final UpdateMakeImportant _updateMakeImportant;
  final UpdateNameTodo _updateNameTodo;
  final UpdateFolder _updateFolder;
  final StreamError _streamError;
  final NewDeleteFolder _newDeleteFolder;

  late StreamSubscription<Either<Failure, Exception>> subscription;

  
  Future<void> addTask(Todo todo) async {
    emit(TodoLoading(state));
    final result = await _addTask(todo);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) {
        emit(AddTaskCompletedState());
      },
    );
  }

  Future<void> createFolder(Folder folder) async {
    emit(TodoLoading(state));
    final result = await _createFolder(folder);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(CreateFolderCompletedState()),
    );
  }

  Future<void> deleteFolders(String folderId) async {
    emit(TodoLoading(state));
    final result = await _deleteFolder(folderId);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(DeleteSucessfulFolderState()),
    );
  }

  Future<void> deleteMultipleTodos(List<Todo> todoList) async {
    emit(TodoLoading(state));
    final result = await _deleteMultipleTodo(todoList);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(DeleteMultipleSucessfulFolderState()),
    );
  }

  Future<void> deleteTodo(String todoId) async {
    emit(TodoLoading(state));
    final result = await _deleteTodo(todoId);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(DeleteTodoCompletedState()),
    );
  }

  Future<void> firstTimeLoad() async {
    // emit(TodoLoading(state));
    final result = await _firstTimeLoad();
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(FirstTimeLoadCompletedState()),
    );
  }

  Future<void> getFolders() async {
    emit(TodoLoading(state));
    final result = await _getFolders();
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (folders) {
        emit(FoldersLoaded(folders));
      },
    );
  }

  Future<void> getTodos(String filterData) async {
    emit(TodoLoading(state));
    final result = await _getTodos(filterData);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (filteredTodos) {
        emit(TodosLoaded(filteredTodos));
      },
    );
  }

  Future<void> startListening() async {
    emit(TodoLoading(state));
    final result = await _startListening();
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(StartListeningsCompletedState()),
    );
  }

  Future<void> stopListening() async {
    // emit(TodoLoading(state));
    final result = await _stopListening();
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(StopListeningsCompletedState()),
    );
    // await subscription.cancel();
  }

  // Future<void> sync() async {
  //   print('sat9 $state');
  //   emit(TodoLoading(state));
  //   final result = await _sync();
  //   result.fold(
  //     (failure) {
  //       emit(TodoError(failure.errorMessage));
  //     },
  //     (_) => emit(SyncCompleted()),
  //   );
  // }

  Future<void> updateCompleted(String todoId) async {
    emit(TodoLoading(state));
    final result = await _updateCompleted(todoId);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) => emit(UpdateTodoCompletedState()),
    );
  }

  Future<void> updateMakeImportant(String todoId) async {
    print('sat important $state');

    emit(TodoLoading(state));
    print('sat2 important $state');
    final result = await _updateMakeImportant(todoId);
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) {
        print('sat3 important $state');
        emit(UpdateImportantCompletedState());
        print('sat4 important $state');
      },
    );
  }

  Future<void> updateNameTodo({
    required String todoID,
    required String newTodoName,
  }) async {
    emit(TodoLoading(state));
    final result = await _updateNameTodo(
      UpdateTodoParams(todoId: todoID, newTodoName: newTodoName),
    );
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) {
        emit(UpdateTodoCompletedState());
      },
    );
  }

  Future<void> updateFolder({
    required String folderId,
    required String newFolderName,
  }) async {
    emit(TodoLoading(state));
    final result = await _updateFolder(
      UpdateFolderParams(folderId: folderId, newFolderName: newFolderName),
    );
    result.fold(
      (failure) => emit(TodoError(failure.errorMessage)),
      (_) {
        emit(TodoActionCompleted());
      },
    );
  }

  Future<void> getErrors() async {
    emit(TodoLoading(state));
    subscription = _streamError().listen(
      (result) {
        result.fold(
          (l) {
            emit(TodoError.withUuid(l.errorMessage));
            subscription.cancel();
          },
          (exception) {
            if (exception is ServerException) {
              emit(TodoError.withUuid(exception.message));
            } else {
              emit(TodoError.withUuid(exception.toString()));
            }
          },
        );
      },
      onError: (dynamic error) => emit(TodoError.withUuid(error.toString())),
    );
  }
}
