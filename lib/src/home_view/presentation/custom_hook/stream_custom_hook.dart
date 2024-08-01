// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/provider/user_provider.dart';
import 'package:flutter_learning_go_router/core/utils/stream_local_user_model.dart';
import 'package:flutter_learning_go_router/src/auth/data/model/local_user_model.dart';

LocalUserModel? useLocalUserModelStreamHook() {
  return use(const _UserDataHook());
}

class _UserDataHook extends Hook<LocalUserModel?> {
  const _UserDataHook();

  @override
  HookState<LocalUserModel?, _UserDataHook> createState() => _UserDataHookState();
}

class _UserDataHookState extends HookState<LocalUserModel?, _UserDataHook> {
  StreamSubscription<LocalUserModel>? _subscription;

  @override
  void initHook() {
    super.initHook();
    _subscription = StreamUserDataUtis.userDataStream.listen((userData) {
      context.read<UserProvider>().user = userData;
    });
  }

  @override
  LocalUserModel? build(BuildContext context) {
    return context.read<UserProvider>().user;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
