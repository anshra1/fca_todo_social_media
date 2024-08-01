// ignore_for_file: lines_longer_than_80_chars

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/firebase_strings.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/data/datasources/remote_data_source.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/todo_model.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/w_todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:uuid/uuid.dart';

class MockHive extends Mock implements HiveInterface {}

class MockPathProvider with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationCachePath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<String?> getDownloadsPath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return ['tst/apasq'];
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return ['test/support/pathsq'];
  }

  @override
  Future<String?> getLibraryPath() async {
    return 'test/support/pathsq';
  }

  @override
  Future<String?> getTemporaryPath() async {
    return 'test/support/pathsq';
  }
}

// ignore: type_annotate_public_apis
var todo = TodoModel(
  todoName: 'Test Todo',
  date: DateTime(2023, 10, 27, 10, 30),
  todoId: 'todoId',
  type: 'private',
  uid: 'uid_123',
  isCompleted: true,
  userName: 'test_user',
  folderName: folder.folderName,
  dueTime: '',
);

// ignore: type_annotate_public_apis
var folder = const FolderModel(
  folderName: 'test_folder',
  folderId: 'folderId',
  icon: 'folder.icon',
);

void main() {
  late TodoRemoteDataSourceImpl dataSource;
  late MockPathProvider mockPathProvider;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    firestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    mockPathProvider = MockPathProvider();
    final appDocDir = await mockPathProvider.getApplicationDocumentsPath();

    Hive
      ..init(appDocDir)
      ..registerAdapter(TodoAdapter())
      ..registerAdapter(WhatTodoAdapter())
      ..registerAdapter(FolderAdapter());

    await HiveBox.init();

    dataSource = TodoRemoteDataSourceImpl(
      taskBox: HiveBox.taskBox,
      folderBox: HiveBox.folderBox,
      pendingBox: HiveBox.pendingTaskBox,
      firestore: firestore,
      auth: auth,
    );
  });

  tearDown(
    () async {
      // await Hive.close();
    },
  );

  test(
    'is Hive working',
    () async {
      final box = Hive.box<Todo>(HiveBox.taskBoxName);
      expect(box.isOpen, true);
    },
  );

  test(
    'add task',
    () async {
      await HiveBox.taskBox.clear();
      await HiveBox.pendingTaskBox.clear();

      for (var i = 0; i < 5; i++) {
        final localTodo = todo.copyWith(todoId: '$i') as Todo;
        await dataSource.addTask(localTodo);
      }

      expect(HiveBox.taskBox.length, 5);

      final getTodo = HiveBox.taskBox.get('0')!;

      final to = todo.copyWith(todoId: '0') as Todo;
      expect(getTodo, equals(to));

      final lengthTask = HiveBox.pendingTaskBox.values.length;

      expect(lengthTask, 0);

      final fire = await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .get();

      final listOfTodoModel = fire.docs.map((e) {
        return TodoModel.fromMap(e.data());
      }).toList();

      final name = listOfTodoModel.first.todoName;

      expect(getTodo.todoName, equals(name));

      final firestoreLength = fire.docs.length;

      expect(firestoreLength, 5);
    },
  );
  test('updateTodo should update the todo in the Hive box and firestroe', () async {
    await HiveBox.taskBox.clear();
    await HiveBox.pendingTaskBox.clear();

    const newTodoName = 'Updated Todo';

    await firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.todos)
        .doc(todo.todoId)
        .set(todo.toMap());

    await HiveBox.taskBox.put(todo.todoId, todo);

    final get = HiveBox.taskBox.get(todo.todoId)!;

    expect(get.todoName, todo.todoName);

    // Act
    await dataSource.updateNameTodo(todo.todoId, newTodoName);

    // Assert

    final docSnap = await firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.todos)
        .doc(todo.todoId)
        .get();

    final todoNew = TodoModel.fromMap(docSnap.data() ?? {});

    expect(todoNew.todoName, newTodoName);

    // Assert

    final newTodo = HiveBox.taskBox.get(todo.todoId)!;

    expect(newTodo.todoName, newTodoName);
  });

  test(
    'make todo important ',
    () async {
      await HiveBox.taskBox.clear();
      await HiveBox.pendingTaskBox.clear();

      await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .doc(todo.todoId)
          .set(todo.toMap());

      await HiveBox.taskBox.put(todo.todoId, todo);

      final get = HiveBox.taskBox.get(todo.todoId)!;

      expect(get.todoName, todo.todoName);

      expect(get.isImportant, false);

      // Act
      await dataSource.updateMakeImportant(todo.todoId);

      // Assert

      final docSnap = await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .doc(todo.todoId)
          .get();

      final todoNew = TodoModel.fromMap(docSnap.data() ?? {});

      expect(todoNew.isImportant, true);

      // Assert

      final newTodo = HiveBox.taskBox.get(todo.todoId)!;

      expect(newTodo.isImportant, true);
    },
  );

  test(
    'make todo completed ',
    () async {
      await HiveBox.taskBox.clear();
      await HiveBox.pendingTaskBox.clear();

      await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .doc(todo.todoId)
          .set(todo.toMap());

      await HiveBox.taskBox.put(todo.todoId, todo);

      final get = HiveBox.taskBox.get(todo.todoId)!;

      expect(get.todoName, todo.todoName);

      expect(get.isCompleted, true);

      // Act
      await dataSource.updateCompleted(todo.todoId);

      // Assert

      final docSnap = await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos)
          .doc(todo.todoId)
          .get();

      final todoNew = TodoModel.fromMap(docSnap.data() ?? {});

      expect(todoNew.isCompleted, false);

      // Assert

      final newTodo = HiveBox.taskBox.get(todo.todoId)!;

      expect(newTodo.isCompleted, false);
    },
  );

  test(
    'delete task',
    () async {
      await HiveBox.taskBox.clear();

      await HiveBox.pendingTaskBox.clear();

      await HiveBox.taskBox.put(todo.todoId, todo);

      expect(HiveBox.taskBox.length, 1);

      final todoCollectionRef = firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos);

      await todoCollectionRef.doc(todo.todoId).set(todo.toMap());

      final querySnap2 = await todoCollectionRef.count().get();
      final fireLength2 = querySnap2.count ?? 111111111111111;

      expect(fireLength2, 1);
      expect(HiveBox.taskBox.length, 1);

      await dataSource.deleteTodo(todo.todoId);

      final querySnap = await todoCollectionRef.count().get();
      final fireLength = querySnap.count ?? 111111111111111;

      expect(fireLength, 0);

      expect(HiveBox.taskBox.length, 0);
      expect(HiveBox.pendingTaskBox.length, 0);
    },
  );

  test(
    'delete Multiple todos',
    () async {
      await HiveBox.taskBox.clear();
      await HiveBox.pendingTaskBox.clear();

      final todosColRef = firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos);

      for (var i = 0; i < 5; i++) {
        final t = todo.copyWith(
          todoId: i.toString(),
        );
        await HiveBox.taskBox.put(i.toString(), t);
        await todosColRef.doc(t.todoId).set(t.toMap());
      }

      //  await batch.commit();
      expect(HiveBox.taskBox.length, 5);

      final querySnap = await todosColRef.count().get();
      final fireLength = querySnap.count ?? 111111111111111;

      expect(fireLength, 5);

      await dataSource.deleteMultipleTodo(HiveBox.taskBox.values.toList());

      final query2 = await todosColRef.count().get();
      final fireLength2 = query2.count ?? 111111111111111;

      expect(fireLength2, 0);

      expect(HiveBox.taskBox.length, 0);
      expect(HiveBox.pendingTaskBox.length, 0);
    },
  );

  group(
    'start Listening',
    () {
      setUp(() async {
        await HiveBox.taskBox.clear();
        await HiveBox.pendingTaskBox.clear();

        // dataSource.startListening();
      });
      test(
        'adding task after listening should add the task to the Hive box',
        () async {
          expect(HiveBox.taskBox.length, 0);

          await dataSource.startListening();

          final t = TodoModel.empty();

          await firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.todos)
              .doc(t.todoId)
              .set(t.toMap());

          final doc = await firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.todos)
              .doc(t.todoId)
              .get();

          if (doc.data() != null && doc.exists) return;

          final s = doc.data() ?? {};
          final docTodo = TodoModel.fromMap(s);

          final todoCopy = docTodo.copyWith(date: DateTime.now());

          expect(
            docTodo.copyWith(date: DateTime(2023, 10, 27, 10, 30)),
            todo.copyWith(date: DateTime(2023, 10, 27, 10, 30)),
          );

          expect(HiveBox.taskBox.get(todoCopy.todoId), todoCopy);

          expect(HiveBox.taskBox.length, 1);
          expect(HiveBox.pendingTaskBox.length, 0);

          await firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.todos)
              .doc(t.todoId)
              .set(t.copyWith(uid: 'uid king').toMap());

          await dataSource.stopListening();

          expect(HiveBox.taskBox.length, 1);
          expect(HiveBox.pendingTaskBox.length, 0);
        },
      );

      test(
        'modifying the task after listening should update the '
        'task in the Hive box',
        () async {
          expect(HiveBox.taskBox.length, 0);

          final userDocRefTodos = firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.todos);

          await userDocRefTodos.doc(todo.todoId).set(todo.toMap());

          const newTodoName = 'Updated Todo Firestore';

          await dataSource.startListening();

          await userDocRefTodos.doc(todo.todoId).update({Strings.todoName: newTodoName});

          final doc = await userDocRefTodos.doc(todo.todoId).get();

          expect(HiveBox.taskBox.get(todo.todoId)?.todoName, newTodoName);

          final s = doc.data() ?? {};

          final docTodo = TodoModel.fromMap(s);

          final todoCopy = docTodo.copyWith(date: DateTime(2023, 10, 27, 10, 30));

          final todos =
              (HiveBox.taskBox.get(docTodo.todoId) ?? TodoModel.empty()) as TodoModel;

          final c = todos.copyWith(date: DateTime(2023, 10, 27, 10, 30));

          expect(c, todoCopy);

          expect(HiveBox.taskBox.length, 1);
        },
      );

      test(
        'deleting the task after listening should delete the task '
        'from the Hive box',
        () async {
          expect(HiveBox.taskBox.length, 0);

          final todoCollecRef = firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.todos);

          await todoCollecRef.doc(todo.todoId).set(todo.toMap());
          await HiveBox.taskBox.put(todo.todoId, todo);

          await dataSource.startListening();

          final docSnap = await todoCollecRef.doc(todo.todoId).get();

          final todoNew = TodoModel.fromMap(docSnap.data() ?? {});

          expect(todo.todoId, todoNew.todoId);

          await todoCollecRef.doc(todo.todoId).delete();

          final doc = await todoCollecRef.get();

          final length = doc.docs.length;

          expect(length, 0);
          expect(HiveBox.taskBox.length, 0);
        },
      );

      test(
        'adding folder after listening should add the folder to the Hive box',
        () async {
          await HiveBox.folderBox.clear();
          expect(HiveBox.folderBox.length, 0);

          await dataSource.startListening();

          const t = FolderModel.empty();

          await firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.folders)
              .doc(t.folderId)
              .set(t.toMap());

          final doc = await firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.folders)
              .doc(t.folderId)
              .get();

          if (doc.data() != null && doc.exists) return;

          final s = doc.data()!;

          final docTodo = FolderModel.fromMap(s);

          expect(docTodo, t);

          expect(HiveBox.taskBox.get(t.folderId), t);

          expect(HiveBox.folderBox.length, 1);
        },
      );

      test(
        'modifying the folder after listening should update the '
        'folder in the Hive box',
        () async {
          await HiveBox.folderBox.clear();
          expect(HiveBox.folderBox.length, 0);

          final userDocRefFolders = firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.folders);

          await userDocRefFolders.doc(folder.folderId).set(folder.toMap());

          const newFolderName = 'Updated Todo Firestore';

          await dataSource.startListening();

          await userDocRefFolders
              .doc(folder.folderId)
              .update({Strings.folderName: newFolderName});

          final doc = await userDocRefFolders.doc(folder.folderId).get();

          expect(
            HiveBox.folderBox.get(folder.folderId)?.folderName,
            newFolderName,
          );

          final s = doc.data() ?? {};

          final docFolder = FolderModel.fromMap(s);

          final folders = HiveBox.folderBox.get(folder.folderId)!;

          expect(docFolder, folders);

          expect(HiveBox.folderBox.length, 1);
        },
      );

      test(
        'deleting the folder after listening should delete the folder '
        'from the Hive box',
        () async {
          await HiveBox.folderBox.clear();
          expect(HiveBox.folderBox.length, 0);

          final folderCollecRef = firestore
              .collection(FirebaseStrings.users)
              .doc(auth.currentUser?.uid)
              .collection(FirebaseStrings.folders);

          await folderCollecRef.doc(folder.folderId).set(folder.toMap());

          await HiveBox.folderBox.put(folder.folderId, folder);

          await dataSource.startListening();

          final docSnap = await folderCollecRef.doc(folder.folderId).get();

          final folderNew = FolderModel.fromMap(docSnap.data() ?? {});

          expect(folder.folderId, folderNew.folderId);

          await folderCollecRef.doc(folderNew.folderId).delete();

          final doc = await folderCollecRef.get();

          final length = doc.docs.length;

          expect(length, 0);
          expect(HiveBox.folderBox.length, 0);
        },
      );
    },
  );

  test(
    'getTodos',
    () async {
      await HiveBox.taskBox.clear();
      expect(HiveBox.taskBox.length, 0);

      for (var i = 0; i < 5; i++) {
        await HiveBox.taskBox.put(i.toString(), todo);
      }

      final fTodo = todo.copyWith(folderName: 'folder').copyWith(isImportant: false);

      await HiveBox.taskBox.put('folderId', fTodo);

      final todoList = await dataSource.getTodos(
        Strings.isImportant,
      );

      expect(todoList.length, 5);

      final folderList = await dataSource.getTodos(
        fTodo.folderName,
      );

      expect(folderList.length, 1);

      final allList = await dataSource.getTodos('');

      expect(allList.length, 0);
    },
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'create folder',
    () async {
      await HiveBox.folderBox.clear();
      await HiveBox.pendingTaskBox.clear();

      await dataSource.createFolders(folder);

      final getFolder = HiveBox.folderBox.get('folderId');

      expect(getFolder, folder);

      final firestoreFolder = await firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.folders)
          .doc(folder.folderId)
          .get();

      final folderModel = FolderModel.fromMap(firestoreFolder.data()!);

      expect(folderModel, folder);

      expect(HiveBox.folderBox.length, 1);

      expect(HiveBox.folderBox.length, 1);
    },
  );

  test('delete Folder', () async {
    await HiveBox.folderBox.clear();
    await HiveBox.pendingTaskBox.clear();
    await HiveBox.taskBox.clear();

    await HiveBox.folderBox.put(folder.folderId, folder);

    expect(HiveBox.folderBox.length, 1);

    for (var i = 0; i < 5; i++) {
      final id = const Uuid().v4();
      final t = todo.copyWith(folderName: folder.folderName).copyWith(todoId: id);
      await HiveBox.taskBox.put(t.todoId, t);
    }

    expect(HiveBox.taskBox.length, 5);

    await HiveBox.taskBox.put('key', todo.copyWith(folderName: 'NoDeleteFolder'));

    await firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.folders)
        .doc(folder.folderId)
        .set(folder.toMap());

    final count = firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.folders)
        .count();

    final length = await count.count().get();

    expect(length.count, 1);

    await dataSource.deleteFolders(folder.folderId);

    final len = await count.count().get();

    expect(HiveBox.folderBox.length, 0);

    expect(len.count, 0);

    expect(HiveBox.pendingTaskBox.length, 0);

    expect(HiveBox.taskBox.length, 1);
    expect(HiveBox.taskBox.get('key')?.folderName, 'NoDeleteFolder');
  });

  test('upate Folder', () async {
    await HiveBox.folderBox.clear();
    await HiveBox.pendingTaskBox.clear();

    await HiveBox.folderBox.put(folder.folderId, folder);

    expect(HiveBox.folderBox.length, 1);

    await firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.folders)
        .doc(folder.folderId)
        .set(folder.toMap());

    final count = firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.folders)
        .count();

    final length = await count.count().get();

    expect(length.count, 1);

    const updateFolderName = 'updated Folder Name';

    await dataSource.updateFolder(folder.folderId, updateFolderName);

    final fol = HiveBox.folderBox.get(folder.folderId);

    expect(fol?.folderName, updateFolderName);

    final folderData = await firestore
        .collection(FirebaseStrings.users)
        .doc(auth.currentUser?.uid)
        .collection(FirebaseStrings.folders)
        .doc(folder.folderId)
        .get();

    final folderFirestore = FolderModel.fromMap(folderData.data()!);

    expect(folderFirestore.folderName, updateFolderName);

    final len = await count.count().get();

    expect(HiveBox.folderBox.length, 1);

    expect(len.count, 1);
  });

  test(
    'get folders',
    () async {
      await HiveBox.folderBox.clear();
      expect(HiveBox.folderBox.length, 0);

      for (var i = 0; i < 5; i++) {
        await HiveBox.folderBox.put(i.toString(), folder);
      }

      final folders = await dataSource.getFolders();

      expect(folders.length, 5);

      expect(HiveBox.folderBox.length, 5);
    },
  );

  test(
    'load intial data',
    () async {
      await HiveBox.taskBox.clear();
      await HiveBox.folderBox.clear();
      await HiveBox.commonBox.clear();

      final todosRef = firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.todos);

      final foldersRef = firestore
          .collection(FirebaseStrings.users)
          .doc(auth.currentUser?.uid)
          .collection(FirebaseStrings.folders);

      for (var i = 0; i < 5; i++) {
        final id = const Uuid().v1();
        await todosRef.add(todo.copyWith(todoId: id).toMap());
        await foldersRef.add(folder.copyWith(folderId: id).toMap());
      }

      await dataSource.firstTimeLoad();

      expect(HiveBox.taskBox.length, 5);
      expect(HiveBox.folderBox.length, 5);
    },
  );
}
