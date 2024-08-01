import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SyncManager {
  SyncManager(this.context);

  final BuildContext context;
  bool _isUploading = false;
  StreamSubscription<dynamic>? _internetSubscription;

  void startListening() {
    context.read<TodoCubit>().startListening();
    HiveBox.pendingTaskBox
        .listenable()
        .addListener(_startUploadingPendingItems);
  }

  void stopUploading() {
    _isUploading = false;
    _internetSubscription?.cancel();
    _internetSubscription = null;
  }

  void _startUploadingPendingItems() {
    if (!_isUploading) {
      _isUploading = true;
      _internetSubscription =
          InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
        //    context.read<TodoCubit>().sync();
          case InternetStatus.disconnected:
          // Do nothing
        }
      });
    }
  }
o
  void dispose() {
    stopUploading();
    context.read<TodoCubit>().stopListening();
  }
}
