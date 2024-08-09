// ignore_for_file: lines_longer_than_80_chars

part of 'import.dart';

final LastRouteObserver routeObserver = LastRouteObserver();

class AppRoutes {
  static final mainMenuRoutes = <RouteBase>[
    GoRoute(
      path: HomeClass.routeName,
      name: HomeClass.routeName,
      pageBuilder: (context, state) {
        return _buildTransition(
          child: BlocProvider(
            create: (context) => sl<TodoCubit>(),
            child: const HomeClass(),
          ),
          state: state,
        );
      },
      routes: [
        GoRoute(
          path: AllTodosView.routeName,
          name: AllTodosView.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const AllTodosView(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: FolderView.routeName,
          name: FolderView.routeName,
          pageBuilder: (_, state) {
            final title = (state.extra
                    as Map<String, dynamic>?)?[Strings.folderName] as String? ??
                'Default Title';

            final folderId = (state.extra
                    as Map<String, dynamic>?)?[Strings.folderId] as String? ??
                '';

            final newFolder = (state.extra
                    as Map<String, dynamic>?)?[Strings.newFolder] as bool? ??
                false;

            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: FolderView(
                  title: title,
                  folderid: folderId,
                  newFolder: newFolder,
                ),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: PublicTodos.routeName,
          name: PublicTodos.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const PublicTodos(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: AddFolderDialog.routeName,
          name: AddFolderDialog.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const AddFolderDialog(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: ImportantTodos.routeName,
          name: ImportantTodos.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const ImportantTodos(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: CompletedTodoView.routeName,
          name: CompletedTodoView.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const CompletedTodoView(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: HomeViewFloatingActionButton.routeName,
          name: HomeViewFloatingActionButton.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const HomeViewFloatingActionButton(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: HomeViewDrawer.routeName,
          name: HomeViewDrawer.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const HomeViewDrawer(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: PlannedView.routeName,
          name: PlannedView.routeName,
          pageBuilder: (_, state) {
            return _buildTransition(
              child: BlocProvider<TodoCubit>.value(
                value: sl<TodoCubit>(),
                child: const PlannedView(),
              ),
              state: state,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: PublicView.routeName,
      name: PublicView.routeName,
      pageBuilder: (_, state) => _buildTransition(
        child: const PublicView(),
        state: state,
      ),
    ),
    GoRoute(
      path: ProfileView.routeName,
      name: ProfileView.routeName,
      pageBuilder: (_, state) => _buildTransition(
        child: BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const ProfileView(),
        ),
        state: state,
      ),
    ),
  ];

  static Page<void> _buildTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: kThemeAnimationDuration,
      reverseTransitionDuration: kThemeAnimationDuration,
    );
  }
}
