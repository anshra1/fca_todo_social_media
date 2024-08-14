part of 'import.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  await initOnBoarding();
  await initAuth();
  await initTodo();
}

Future<void> initTodo() async {
  sl
    ..registerFactory(
      () => TodoCubit(
        addTask: sl(),
        createFolder: sl(),
        deleteFolder: sl(),
        deleteMultipleTodo: sl(),
        deleteTodo: sl(),
        firstTimeLoad: sl(),
        getFolders: sl(),
        getTodos: sl(),
        startListening: sl(),
        stopListening: sl(),
        sync: sl(),
        updateCompleted: sl(),
        updateMakeImportant: sl(),
        updateNameTodo: sl(),
        updateFolder: sl(),
        streamError: sl(),
      ),
    )
    ..registerLazySingleton(() => AddTask(todoRepo: sl()))
    ..registerLazySingleton(() => StreamError(sl()))
    ..registerLazySingleton(() => CreateFolder(todoRepo: sl()))
    ..registerLazySingleton(() => DeleteFolder(todoRepo: sl()))
    ..registerLazySingleton(() => DeleteMultipleTodo(todoRepo: sl()))
    ..registerLazySingleton(() => DeleteTodo(todoRepo: sl()))
    ..registerLazySingleton(() => FirstTimeLoad(todoRepo: sl()))
    ..registerLazySingleton(() => GetFolders(todoRepo: sl()))
    ..registerLazySingleton(() => GetTodos(todoRepo: sl()))
    ..registerLazySingleton(() => StartListenings(todoRepo: sl()))
    ..registerLazySingleton(() => StopListenings(todoRepo: sl()))
    ..registerLazySingleton(() => SyncTodo(todoRepo: sl()))
    ..registerLazySingleton(() => UpdateCompleted(todoRepo: sl()))
    ..registerLazySingleton(() => UpdateMakeImportant(todoRepo: sl()))
    ..registerLazySingleton(() => UpdateNameTodo(todoRepo: sl()))
    ..registerLazySingleton(() => UpdateFolder(todoRepo: sl()))
    ..registerLazySingleton<TodoRepo>(
      () => AuthTodoImpl(remoteDataSource: sl()),
    )
    //
    ..registerLazySingleton<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(
        taskBox: HiveBox.taskBox,
        folderBox: HiveBox.folderBox,
        pendingBox: HiveBox.pendingTaskBox,
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        verifyThePhoneNumber: sl(),
        verifyTheOtp: sl(),
        signOut: sl(),
        deleteAccount: sl(),
        updateUser: sl(),
        resendOtp: sl(),
        registerTheUser: sl(),
      ),
    )
    //
    ..registerLazySingleton(() => VerifyThePhoneNumber(authRepo: sl()))
    ..registerLazySingleton(() => VerifyTheOtp(authRepo: sl()))
    ..registerLazySingleton(() => SignOut(authRepo: sl()))
    ..registerLazySingleton(() => DeleteAccount(authRepo: sl()))
    ..registerLazySingleton(() => UpdateUser(authRepo: sl()))
    ..registerLazySingleton(() => ResendOtp(authRepo: sl()))
    ..registerLazySingleton(() => RegisterTheUser(authRepo: sl()))

    //
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(authRemoteDataSource: sl()),
    )
    //
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        firestoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        checkIfUserIsFirstTimer: sl(),
        cacheFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(repo: sl()))
    ..registerLazySingleton(() => CacheFirstTimer(repo: sl()))
    //
    ..registerLazySingleton<OnBoardingRepo>(() => OnboardingRepoImpl(sl()))
    //
    ..registerLazySingleton<OnboardingLocaDataSrc>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    //
    ..registerLazySingleton(() => prefs);
}
