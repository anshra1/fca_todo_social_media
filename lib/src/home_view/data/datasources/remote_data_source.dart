import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_learning_go_router/core/enum/todo_what.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/firebase_strings.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/core/utils/autrorize_user_utils.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/todo_model.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/w_todo.dart';
import 'package:hive_flutter/adapters.dart';

abstract class TodoRemoteDataSource {
  const TodoRemoteDataSource();

  Future<void> addTask(Todo todo);

  Future<void> updateNameTodo(String todoID, String newTodoName);

  Future<void> deleteTodo(String todoId);

  Future<void> deleteMultipleTodo(List<Todo> todoList);

  Future<List<Todo>> getTodos(String filterData);

  Future<void> sync();

  Future<void> createFolders(Folder folderName);

  Future<void> deleteFolders(String folderId);

  Future<void> updateFolder(String folderId, String newFolderName);

  Future<List<Folder>> getFolders();

  Future<void> firstTimeLoad();

  Future<void> updateMakeImportant(String todoId);

  Future<void> updateCompleted(String todoId);

  Future<void> startListening();

  Future<void> stopListening();

  Stream<Exception> errorStream();
}

class TodoRemoteDataSourceImpl extends TodoRemoteDataSource {
  TodoRemoteDataSourceImpl({
    required Box<Todo> taskBox,
    required Box<Folder> folderBox,
    required Box<WhatTodo> pendingBox,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _taskBox = taskBox,
        _folderBox = folderBox,
        _pendingBox = pendingBox,
        _firestore = firestore,
        _auth = auth;

  final Box<Todo> _taskBox;
  final Box<Folder> _folderBox;
  final Box<WhatTodo> _pendingBox;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  StreamSubscription<dynamic>? _folderSubcription;
  StreamSubscription<dynamic>? _todosSubcription;

  final _errorController = StreamController<Exception>.broadcast();
  bool intial = true;

  @override
  Future<void> addTask(Todo todo) async {
    try {
      if (_taskBox.isOpen && _pendingBox.isOpen && todo.todoName.isNotEmpty) {
        await _taskBox.put(todo.todoId, todo);

        await _pendingBox.put(
          todo.todoId,
          WhatTodo(what: TodoWhat.create, object: todo, key: todo.todoId),
        );
      }

      await sync();
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    try {
      final todo = _taskBox.get(todoId);

      if (todo != null) {
        await _taskBox.delete(todo.todoId);

        await _pendingBox.put(
          todo.todoId,
          WhatTodo(what: TodoWhat.delete, object: todo, key: todoId),
        );

        await sync();
      }
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<List<Todo>> getTodos(
    String filterData,
  ) async {
    try {
      if (filterData == 'All') {
        return _taskBox.values.toList();
      }

      final filterTodos = HiveBox.taskBox.values.where((todo) {
        final folder = todo.folderId;

        if (filterData == Strings.isCompleted) {
          return todo.isCompleted == true;
        } else if (filterData == Strings.isImportant) {
          return todo.isImportant == true;
        } else if (filterData == folder) {
          return true;
        } else {
          return false;
        }
      }).toList();

      return filterTodos;
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<void> createFolders(Folder folderName) async {
    try {
      if (_folderBox.isOpen) {
        await HiveBox.folderBox.put(folderName.folderId, folderName);

        await _pendingBox.put(
          folderName.folderId,
          WhatTodo(
            what: TodoWhat.createFolder,
            object: folderName,
            key: folderName.folderId,
          ),
        );

        await sync();
      }
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<void> deleteFolders(String folderId) async {
    try {
      final getFolder = HiveBox.folderBox.get(folderId);

      if (getFolder != null) {
        for (final todo in _taskBox.values.toList()) {
          if (todo.folderId == getFolder.folderName) {
            await _taskBox.delete(todo.todoId);

            await _pendingBox.put(
              todo.todoId,
              WhatTodo(what: TodoWhat.delete, object: todo, key: todo.todoId),
            );
          }
        }

        await _folderBox.delete(folderId);

        await _pendingBox.put(
          getFolder.folderId,
          WhatTodo(
            what: TodoWhat.deleteFolder,
            object: getFolder,
            key: getFolder.folderId,
          ),
        );
        await sync();
        //   _startUploadingPendingItems();
      }
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<void> deleteMultipleTodo(List<Todo> todoList) async {
    try {
      for (final todo in todoList) {
        await _taskBox.delete(todo.todoId);

        await _pendingBox.put(
          todo.todoId,
          WhatTodo(
            what: TodoWhat.delete,
            object: todo,
            key: todo.todoId,
          ),
        );
      }

      await sync();
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<List<Folder>> getFolders() async {
    if (HiveBox.folderBox.isOpen) {
      return HiveBox.folderBox.values.toList();
    }

    return [];
  }

  @override
  Future<void> updateCompleted(String todoId) async {
    final todo = _taskBox.get(todoId);

    if (todo != null) {
      final updatedTodo =
          TodoModel.fromTodo(todo).copyWith(isCompleted: !todo.isCompleted);

      await _taskBox.put(todoId, updatedTodo);

      await _pendingBox.put(
        todoId,
        WhatTodo(what: TodoWhat.isComleted, object: updatedTodo, key: todoId),
      );
      await sync();
    }
  }

  @override
  Future<void> updateMakeImportant(String todoId) async {
    final todo = _taskBox.get(todoId);

    if (todo != null) {
      final updatedTodo =
          TodoModel.fromTodo(todo).copyWith(isImportant: !todo.isImportant);

      await _taskBox.put(todoId, updatedTodo);

      await _pendingBox.put(
        todoId,
        WhatTodo(what: TodoWhat.isImportant, object: updatedTodo, key: todoId),
      );
      await sync();
    }
  }

  @override
  Future<void> updateNameTodo(String todoID, String newTodoName) async {
    final todo = _taskBox.get(todoID);

    if (todo != null) {
      final updatedTodo =
          TodoModel.fromTodo(todo).copyWith(todoName: newTodoName);
      await _taskBox.put(todoID, updatedTodo);

      await _pendingBox.put(
        todoID,
        WhatTodo(what: TodoWhat.updateName, object: updatedTodo, key: todoID),
      );

      await sync();
    }
  }

  @override
  Future<void> updateFolder(String folderId, String newFolderName) async {
    try {
      final folder = _folderBox.get(folderId);

      if (folder != null) {
        final updatedFolder =
            FolderModel.fromFolder(folder).copyWith(folderName: newFolderName);

        await _folderBox.put(folderId, updatedFolder);

        await _pendingBox.put(
          folderId,
          WhatTodo(
            what: TodoWhat.updateFolder,
            object: updatedFolder,
            key: folderId,
          ),
        );

        await sync();
      }
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Hive Error', statusCode: 501);
    }
  }

  @override
  Future<void> sync() async {
    try {
      await _uploadingPendingItems();
    } on FirebaseException catch (e) {
      debugPrint('Error $e');
      throw const ServerException(message: 'Firebase Error', statusCode: 404);
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Sync Error', statusCode: 501);
    }
  }

  @override
  Future<void> startListening() async {
    try {
      await AutorizeUserUtils.authorizeUser(_auth);
      final uid = _auth.currentUser?.uid;

      if (!intial) {
        if (uid != null) {
          final lastSync = HiveBox.commonBox.get(
            FirebaseStrings.lastSyncTime,
            defaultValue: Common(DateTime(1111)),
          );

          if (lastSync != null) {
            final time = lastSync.value as DateTime;

            _todosSubcription = _firestore
                .collection(FirebaseStrings.users)
                .doc(uid)
                .collection(FirebaseStrings.todos)
                .where(Strings.isDeleted, isEqualTo: false)
                .where(FirebaseStrings.lastSyncTime,
                    isGreaterThan: time.toUtc())
                .snapshots()
                .listen(_handleTodoChanges, onError: _handleError);

            _folderSubcription = _firestore
                .collection(FirebaseStrings.users)
                .doc(uid)
                .collection(FirebaseStrings.folders)
                .snapshots()
                .listen(_handleFolderChanges, onError: _handleError);
          }
        }
      }
      intial = false;
    } catch (e) {
      debugPrint(e.toString());
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    debugPrint('Handle Error $error');
    if (error is FirebaseException) {
      _errorController.add(
        ServerException(
          message: 'Firebase Error: ${error.message}',
          statusCode: error.code,
        ),
      );
    } else {
      _errorController.add(
        ServerException(
          message: 'Unknown Error: $error',
          statusCode: '500',
        ),
      );
    }
  }

  // Future<void> handleDeletedTodos(String uid) async {
  //   // final batch = _firestore.batch();
  //   final snapshot = await _firestore
  //       .collection(FirebaseStrings.users)
  //       .doc(uid)
  //       .collection(FirebaseStrings.todos)
  //       .where(Strings.delete, isEqualTo: true)
  //       .get();

  //   for (final doc in snapshot.docs) {
  //     await _firestore
  //         .collection(FirebaseStrings.users)
  //         .doc(uid)
  //         .collection(FirebaseStrings.todos)
  //         .doc(doc.reference.id)
  //         .delete();
  //   }

  //   //await batch.commit();
  // }

  void _handleTodoChanges(QuerySnapshot snapshot) {
    try {
      for (final change in snapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            debugPrint('change Modify ${change.type} ${Random().nextInt(100)}');
            final todoData = change.doc.data();
            if (todoData != null) {
              final todo = TodoModel.fromMap(todoData as DataMap);
              if (_taskBox.get(todo.todoId) != todo) {
                if (todo.isDelete) {
                  _taskBox.delete(todo.todoId);
                } else {
                  _taskBox.put(
                    todo.todoId,
                    todo.copyWith(date: DateTime.now()),
                  );
                }
              }
            }

          case DocumentChangeType.removed:
            debugPrint('change Delete ${change.type} ${Random().nextInt(100)}');
            final todoData = change.doc.data();

            if (todoData != null) {
              final todo = TodoModel.fromMap(todoData as DataMap);
              _taskBox.delete(todo.todoId);
            }
        }
      }

      HiveBox.commonBox
          .put(FirebaseStrings.lastSyncTime, Common(DateTime.now()));
    } catch (e) {
      debugPrint(e.toString());
      _handleError(e);
    }
  }

  bool initial = true;

  void _handleFolderChanges(QuerySnapshot snapshot) {
    try {
      if (!initial) {
        for (final change in snapshot.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
            case DocumentChangeType.modified:
              final folderData = change.doc.data();
              if (folderData != null) {
                final folder = FolderModel.fromMap(folderData as DataMap);
                _folderBox.put(folder.folderId, folder);
              }

            case DocumentChangeType.removed:
              final folderData = change.doc.data();
              if (folderData != null) {
                final folder = FolderModel.fromMap(folderData as DataMap);
                _folderBox.delete(folder.folderId);
              }
          }
        }
      }
      initial = false;
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> stopListening() async {
    await _folderSubcription?.cancel();
    await _todosSubcription?.cancel();
    _folderSubcription = null;
    _todosSubcription = null;
  }

  @override
  Future<void> firstTimeLoad() async {
    try {
      await AutorizeUserUtils.authorizeUser(_auth);

      await createFolders(Strings.taskFolder);

      final todosSnapshot = await _firestore
          .collection(FirebaseStrings.users)
          .doc(_auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .get();

      for (final doc in todosSnapshot.docs) {
        if (doc.exists) {
          final todoData = doc.data();

          final todo = TodoModel.fromMap(todoData);

          await _taskBox.put(todo.todoId, todo);
        }
      }

      final folderSnapshot = await _firestore
          .collection(FirebaseStrings.users)
          .doc(_auth.currentUser?.uid)
          .collection(FirebaseStrings.folders)
          .get();

      for (final doc in folderSnapshot.docs) {
        if (doc.exists) {
          final folderData = doc.data();
          final folder = FolderModel.fromMap(folderData);
          await _folderBox.put(folder.folderId, folder);
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Error $e');
      throw const ServerException(message: 'Firebase Error', statusCode: 404);
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      debugPrint('Error $e');
      throw const CacheException(message: 'Sync Error', statusCode: 501);
    }
  }

  Future<void> _uploadingPendingItems() async {
    try {
      await AutorizeUserUtils.authorizeUser(_auth);

      final pendingJobs = _pendingBox.values.toList();

      if (pendingJobs.isEmpty) {
        return;
      }

      final userDocRefTodos = _firestore
          .collection(FirebaseStrings.users)
          .doc(_auth.currentUser?.uid)
          .collection(FirebaseStrings.todos);

      final userDocRefFolders = _firestore
          .collection(FirebaseStrings.users)
          .doc(_auth.currentUser?.uid)
          .collection(FirebaseStrings.folders);

      for (final whatTodo in pendingJobs) {
        final currentJob = whatTodo.what;

        switch (currentJob) {
          case TodoWhat.create:
            final todoModel = TodoModel.fromTodo(whatTodo.object as Todo);

            await userDocRefTodos.doc(todoModel.todoId).set(todoModel.toMap());

          case TodoWhat.delete:
            final todo = TodoModel.fromTodo(whatTodo.object as Todo);
            await userDocRefTodos.doc(todo.todoId).update(
              {
                Strings.isDeleted: true,
                Strings.date: DateTime.now(),
              },
            );

          case TodoWhat.isImportant:
            final todo = TodoModel.fromTodo(whatTodo.object as Todo);
            await userDocRefTodos.doc(todo.todoId).update({
              Strings.isImportant: todo.isImportant,
              Strings.date: DateTime.now(),
            });

          case TodoWhat.isComleted:
            final todo = TodoModel.fromTodo(whatTodo.object as Todo);
            await userDocRefTodos.doc(todo.todoId).update({
              Strings.isCompleted: todo.isCompleted,
              Strings.date: DateTime.now(),
            });

          case TodoWhat.updateName:
            final todoModel = TodoModel.fromTodo(whatTodo.object as Todo);
            await userDocRefTodos.doc(todoModel.todoId).update(
              {
                Strings.todoName: todoModel.todoName,
                Strings.date: DateTime.now(),
              },
            );

          case TodoWhat.createFolder:
            final folderModel = FolderModel.fromFolder(
              whatTodo.object as Folder,
            );

            await userDocRefFolders.doc(folderModel.folderId).set(
                  folderModel.toMap(),
                );

          case TodoWhat.deleteFolder:
            await userDocRefFolders.doc(whatTodo.key).delete();

          case TodoWhat.updateFolder:
            final folderModel =
                FolderModel.fromFolder(whatTodo.object as Folder);
            final data = folderModel.toMap();
            await userDocRefFolders
                .doc((whatTodo.object as FolderModel).folderId)
                .set(data);
        }

        await _pendingBox.delete(whatTodo.key);
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Stream<Exception> errorStream() {
    return _errorController.stream;
  }
}
