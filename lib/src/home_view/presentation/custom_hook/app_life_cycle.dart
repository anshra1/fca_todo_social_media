import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';

AppLifecycleState? useAppLifecycleTodo() {
  return use(const TodoAppLifeCycle());
}

class TodoAppLifeCycle extends Hook<AppLifecycleState?> {
  const TodoAppLifeCycle();

  @override
  HookState<AppLifecycleState?, Hook<AppLifecycleState?>> createState() =>
      _TodoAppLifeCycleState();
}

class _TodoAppLifeCycleState extends HookState<AppLifecycleState?, TodoAppLifeCycle>
    with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleState = WidgetsBinding.instance.lifecycleState;
  }

  @override
  AppLifecycleState? build(BuildContext context) => _appLifecycleState;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<TodoCubit>().startListening();
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.hidden:
        break;

      case AppLifecycleState.paused:
        context.read<TodoCubit>().stopListening();
        break;

      case AppLifecycleState.detached:
        break;
    }
  }
}
