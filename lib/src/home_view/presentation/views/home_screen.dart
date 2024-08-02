// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/extension/object_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/custom_hook/stream_custom_hook.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/sync_manager.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/all_task_view.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/class/all_todos.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/strings.dart';

class HomeClass extends StatefulHookWidget {
  const HomeClass({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeClass> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeClass> {
  late SyncManager _syncManager;

  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();

    if (!_initialLoadComplete) {
      // need to do something with this
      context.read<TodoCubit>().firstTimeLoad();
      _initialLoadComplete = true;
    }

    _syncManager = SyncManager(context);
    _syncManager.startListening();
    _navigateToLastRoute();
  }

  Future<void> _navigateToLastRoute() async {
    final lastRoute = HiveBox.commonBox.get(Strings.lastPage)?.value
        as Map<dynamic, dynamic>?;

    if (lastRoute != null &&
        lastRoute[Strings.lastPage].toString() != HomeClass.routeName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacementNamed(
          lastRoute[Strings.lastPage] as String? ?? AllTodosView.routeName,
          extra: {
            Strings.folderName: lastRoute[Strings.folderName] as String?,
            Strings.folderId: lastRoute[Strings.folderId] as String?,
          },
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacementNamed(AllTodosView.routeName);
      });
    }
  }

  @override
  void dispose() {
    //  _syncManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    'sate'.printFirst();
    useLocalUserModelStreamHook();
    final appLifecycleState = useAppLifecycleState();

    if (appLifecycleState == AppLifecycleState.resumed) {
      //'app resume'.printFirst();
      //  _syncManager.startListening();
    } else if (appLifecycleState == AppLifecycleState.detached) {
      'app detach'.printFirst();
      _syncManager.dispose();
    } else if (appLifecycleState == AppLifecycleState.inactive) {
      'app inative'.printFirst();
      _syncManager.dispose();
    }

    return AllTodosView();
  }
}
