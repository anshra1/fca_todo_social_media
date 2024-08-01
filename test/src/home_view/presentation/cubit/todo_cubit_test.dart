// ignore_for_file: lines_longer_than_80_chars
// // ignore_for_file: lines_longer_than_80_chars

// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_learning_go_router/core/error/exception.dart';
// import 'package:flutter_learning_go_router/core/error/failure.dart';
// import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
// import 'package:flutter_learning_go_router/src/home_view/data/model/todo_model.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/entities/todo.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/add_task.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/create_folder.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_folder.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_multiple_todo.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/delete_todo.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/first_time_load.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/get_folders.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/get_todos.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/start_listening.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/stop_listening.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/stream_error.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/sync_todo.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_completed.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_folder.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_make_important.dart';
// import 'package:flutter_learning_go_router/src/home_view/domain/usecases/update_name_todo.dart';
// import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockAddTask extends Mock implements AddTask {}

// class MockCreateFolder extends Mock implements CreateFolder {}

// class MockDeleteFolder extends Mock implements DeleteFolder {}

// class MockDeleteMultipleTodo extends Mock implements DeleteMultipleTodo {}

// class MockDeleteTodo extends Mock implements DeleteTodo {}

// class MockFirstTimeLoad extends Mock implements FirstTimeLoad {}

// class MockGetFolders extends Mock implements GetFolders {}

// class MockGetTodos extends Mock implements GetTodos {}

// class MockStartListening extends Mock implements StartListenings {}

// class MockStopListening extends Mock implements StopListenings {}

// class MockSyncTodo extends Mock implements SyncTodo {}

// class MockUpdateCompleted extends Mock implements UpdateCompleted {}

// class MockUpdateMakeImportant extends Mock implements UpdateMakeImportant {}

// class MockUpdateNameTodo extends Mock implements UpdateNameTodo {}

// class MockUpdateFolder extends Mock implements UpdateFolder {}

// class MockStream extends Mock implements StreamError {}

// void main() {
//   late TodoCubit todoCubit;
//   late MockAddTask mockAddTask;
//   late MockCreateFolder mockCreateFolder;
//   late MockDeleteFolder mockDeleteFolder;
//   late MockDeleteMultipleTodo mockDeleteMultipleTodo;
//   late MockDeleteTodo mockDeleteTodo;
//   late MockFirstTimeLoad mockFirstTimeLoad;
//   late MockGetFolders mockGetFolders;
//   late MockGetTodos mockGetTodos;
//   late MockStartListening mockStartListening;
//   late MockStopListening mockStopListening;
//   late MockSyncTodo mockSyncTodo;
//   late MockUpdateCompleted mockUpdateCompleted;
//   late MockUpdateMakeImportant mockUpdateMakeImportant;
//   late MockUpdateNameTodo mockUpdateNameTodo;
//   late MockUpdateFolder mockUpdateFolder;
//   late StreamError streamError;

//   setUp(() {
//     mockAddTask = MockAddTask();
//     mockCreateFolder = MockCreateFolder();
//     mockDeleteFolder = MockDeleteFolder();
//     mockDeleteMultipleTodo = MockDeleteMultipleTodo();
//     mockDeleteTodo = MockDeleteTodo();
//     mockFirstTimeLoad = MockFirstTimeLoad();
//     mockGetFolders = MockGetFolders();
//     mockGetTodos = MockGetTodos();
//     mockStartListening = MockStartListening();
//     mockStopListening = MockStopListening();
//     mockSyncTodo = MockSyncTodo();
//     mockUpdateCompleted = MockUpdateCompleted();
//     mockUpdateMakeImportant = MockUpdateMakeImportant();
//     mockUpdateNameTodo = MockUpdateNameTodo();
//     mockUpdateFolder = MockUpdateFolder();
//     mockStreamError = MockStream();

//     todoCubit = TodoCubit(
//       addTask: mockAddTask,
//       createFolder: mockCreateFolder,
//       deleteFolder: mockDeleteFolder,
//       deleteMultipleTodo: mockDeleteMultipleTodo,
//       deleteTodo: mockDeleteTodo,
//       firstTimeLoad: mockFirstTimeLoad,
//       getFolders: mockGetFolders,
//       getTodos: mockGetTodos,
//       startListening: mockStartListening,
//       stopListening: mockStopListening,
//       sync: mockSyncTodo,
//       updateCompleted: mockUpdateCompleted,
//       updateMakeImportant: mockUpdateMakeImportant,
//       updateNameTodo: mockUpdateNameTodo,
//       updateFolder: mockUpdateFolder, streamError: streamError,
//     );
//   });

//   registerFallbackValue(Todo.empty());
//   registerFallbackValue(const FolderModel.empty());

//   registerFallbackValue(
//     UpdateFolderParams(folderId: 'folderId', newFolderName: 'newFolderName'),
//   );
//   registerFallbackValue(
//     UpdateFolderParams(folderId: 'folderId', newFolderName: 'newFolderName'),
//   );

//   tearDown(() {
//     todoCubit.close();
//   });

//   group('TodoCubit', () {
//     final testTodo = TodoModel.empty();
//     const testFolder = FolderModel.empty();

//     blocTest<TodoCubit, TodoState>(
//       'addTask emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockAddTask(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.addTask(testTodo),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'createFolder emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockCreateFolder(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.createFolder(testFolder),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteFolder emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockDeleteFolder(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteFolder('1'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteMultipleTodos emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockDeleteMultipleTodo(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteMultipleTodos([testTodo]),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteTodo emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockDeleteTodo(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteTodo('1'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'firstTimeLoad emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockFirstTimeLoad())
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.firstTimeLoad(),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'getFolders emits [TodoLoading, FoldersLoaded] when successful',
//       build: () {
//         when(() => mockGetFolders())
//             .thenAnswer((_) async => const Right([testFolder]));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.getFolders(),
//       expect: () => [
//         TodoLoading(),
//         const FoldersLoaded([testFolder]),
//       ],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'getTodos emits [TodoLoading, TodosLoaded] when successful',
//       build: () {
//         when(() => mockGetTodos(any()))
//             .thenAnswer((_) async => Right([testTodo]));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.getTodos(
//         'all',
//       ),
//       expect: () => [
//         TodoLoading(),
//         TodosLoaded([testTodo]),
//       ],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'startListening emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockStartListening())
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.startListening(),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'stopListening emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockStopListening())
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.stopListening(),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'sync emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockSyncTodo()).thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.sync(),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateCompleted emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockUpdateCompleted(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.updateCompleted('1'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateMakeImportant emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockUpdateMakeImportant(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.updateMakeImportant('1'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateNameTodo emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockUpdateNameTodo(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) =>
//           cubit.updateNameTodo(todoID: '1', newTodoName: 'New Name'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateFolder emits [TodoLoading, TodoActionCompleted] when successful',
//       build: () {
//         when(() => mockUpdateFolder(any()))
//             .thenAnswer((_) async => const Right(null));
//         return todoCubit;
//       },
//       act: (cubit) =>
//           cubit.updateFolder(folderId: '1', newFolderName: 'New Folder Name'),
//       expect: () => [TodoLoading(), TodoActionCompleted()],
//     );
//   });

//   group('TodoCubit', () {
// ignore: flutter_style_todos
//     final testTodo = Todo.empty();
//     const testFolder = FolderModel.empty();

//     // const tServerFailure = ServerFailure(
//     //   message: 'user-not-found',
//     //   statusCode: 'There is no user record corresponding to this identifier. '
//     //       'The user may have been deleted',
//     // );

//     const serExce =
//         ServerException(message: 'message', statusCode: 'statusCode');

//     final tServerFailure = ServerFailure.fromException(serExce);

//     // Success cases (as defined in the previous response)

//     // Error cases
//     blocTest<TodoCubit, TodoState>(
//       'addTask emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockAddTask(any())).thenAnswer(
//           (_) async => Left(tServerFailure),
//         );

//         return todoCubit;
//       },
//       act: (cubit) => cubit.addTask(testTodo),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'createFolder emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockCreateFolder(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.createFolder(testFolder),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteFolder emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockDeleteFolder(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteFolder('1'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteMultipleTodos emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockDeleteMultipleTodo(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteMultipleTodos([testTodo]),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'deleteTodo emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockDeleteTodo(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.deleteTodo('1'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'firstTimeLoad emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockFirstTimeLoad())
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.firstTimeLoad(),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'getFolders emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockGetFolders())
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.getFolders(),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'getTodos emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockGetTodos(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.getTodos('all'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'startListening emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockStartListening())
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.startListening(),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'stopListening emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockStopListening())
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.stopListening(),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'sync emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockSyncTodo())
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.sync(),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateCompleted emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockUpdateCompleted(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.updateCompleted('1'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateMakeImportant emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockUpdateMakeImportant(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) => cubit.updateMakeImportant('1'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateNameTodo emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockUpdateNameTodo(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) =>
//           cubit.updateNameTodo(todoID: '1', newTodoName: 'New Name'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );

//     blocTest<TodoCubit, TodoState>(
//       'updateFolder emits [TodoLoading, TodoError] when unsuccessful',
//       build: () {
//         when(() => mockUpdateFolder(any()))
//             .thenAnswer((_) async => Left(tServerFailure));
//         return todoCubit;
//       },
//       act: (cubit) =>
//           cubit.updateFolder(folderId: '1', newFolderName: 'New Folder Name'),
//       expect: () => [TodoLoading(), TodoError(tServerFailure.errorMessage)],
//     );
//   });
// }
