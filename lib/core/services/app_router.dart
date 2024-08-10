// ignore_for_file: lines_longer_than_80_chars
part of 'import.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> mainMenuNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'main_menu');

  static final GoRouter router = GoRouter(
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: const PageUnderConstruction(),
      );
    },
    navigatorKey: _rootNavigatorKey,
    initialLocation: HomeClass.routeName,
    routes: [
      GoRoute(
        path: EditProfileView.routeName,
        name: EditProfileView.routeName,
        pageBuilder: (_, state) => _buildTransition(
          child: BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const EditProfileView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: PhoneNumberView.routeName,
        name: PhoneNumberView.routeName,
        pageBuilder: (_, state) => _buildTransition(
          child: BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const PhoneNumberView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: OtpVerifyView.routeName,
        name: OtpVerifyView.routeName,
        pageBuilder: (_, state) {
          final verificationID = (state.extra!
              as Map<String, dynamic>)[Strings.verificationId] as String;
          final phoneNumber = (state.extra!
              as Map<String, dynamic>)[Strings.phoneNumber] as String;
          return _buildTransition(
            child: BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: OtpVerifyView(
                verificationID: verificationID,
                phoneNumber: phoneNumber,
              ),
            ),
            state: state,
          );
        },
      ),

       GoRoute(
        path: RegisterTheUserView.routeName,
        name: RegisterTheUserView.routeName,
        pageBuilder: (_, state) => _buildTransition(
          child: BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const RegisterTheUserView(),
          ),
          state: state,
        ),
      ),
      // ... other routes
      ShellRoute(
        navigatorKey: mainMenuNavigatorKey,
        observers: [routeObserver],
        builder: (context, state, child) {
          final user = sl<FirebaseAuth>().currentUser;
          final prefs = sl<SharedPreferences>();

          if (prefs.getBool(kFirstTimer) ?? true) {
            return BlocProvider(
              create: (context) => sl<OnBoardingCubit>(),
              child: const OnBoardingViews(),
            );
          } else if (user == null) {
            return BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: const PhoneNumberView(),
            );
          } else {
            return AppBottomNavigation(child);
          }
        },
        routes: AppRoutes.mainMenuRoutes,
      ),
    ],
  );

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
