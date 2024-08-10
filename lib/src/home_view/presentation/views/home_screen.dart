// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/loading/loading_screen.dart';
import 'package:flutter_learning_go_router/core/extension/function_extension.dart';
import 'package:flutter_learning_go_router/core/extension/object_extension.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/custom_hook/stream_custom_hook.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/sync_manager.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/drawer_views/all_task_view.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/drawer_views/all_todos.dart';
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

  @override
  void initState() {
    super.initState();

    var firstTimeLoad = (HiveBox.commonBox
            .get(Strings.firstTimeLoad, defaultValue: const Common(false)))
        ?.value as bool;

    if (!firstTimeLoad) {
      context.read<TodoCubit>().firstTimeLoad();
      HiveBox.commonBox.put(Strings.firstTimeLoad, const Common(true));
    }

    _syncManager = SyncManager(context);
    _syncManager.startListening();
    _navigateToLastRoute();
  }

  void clear() async {
    await HiveBox.clear();
  }

  Future<void> _navigateToLastRoute() async {
    final lastRoute = HiveBox.commonBox.get(Strings.lastPage)?.value
        as Map<dynamic, dynamic>?;

    (() {
    //  LoadingScreen.instance().show(context: context);
      if (lastRoute != null &&
          lastRoute[Strings.lastPage].toString() != HomeClass.routeName) {
        context.pushReplacementNamed(
          lastRoute[Strings.lastPage] as String? ?? AllTodosView.routeName,
          extra: {
            Strings.folderName: lastRoute[Strings.folderName] as String?,
            Strings.folderId: lastRoute[Strings.folderId] as String?,
          },
        );
      } else {
        context.pushReplacementNamed(AllTodosView.routeName);
      }
    }).executeAfterFrame();

    // if (lastRoute != null &&
    //     lastRoute[Strings.lastPage].toString() != HomeClass.routeName) {
    //   (() {
    //     context.pushReplacementNamed(
    //       lastRoute[Strings.lastPage] as String? ?? AllTodosView.routeName,
    //       extra: {
    //         Strings.folderName: lastRoute[Strings.folderName] as String?,
    //         Strings.folderId: lastRoute[Strings.folderId] as String?,
    //       },
    //     );
    //   }).executeAfterFrame();
    // } else {
    //   (() {
    //     context.pushReplacementNamed(AllTodosView.routeName);
    //   }).executeAfterFrame();
    // }
  }

  @override
  void dispose() {
    //  _syncManager.dispose();
   // LoadingScreen.instance().hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return const SizedBox.shrink();
  }
}
