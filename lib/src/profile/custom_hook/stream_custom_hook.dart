import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/provider/user_provider.dart';

import 'package:flutter_learning_go_router/core/utils/stream_local_user_model.dart';
import 'package:flutter_learning_go_router/src/auth/data/model/local_user_model.dart';

class UserDataHook extends Hook<LocalUserModel?> {
  @override
  HookState<LocalUserModel?, UserDataHook> createState() =>
      _UserDataHookState();
}

class _UserDataHookState extends HookState<LocalUserModel?, UserDataHook> {
  StreamSubscription<LocalUserModel>? _subscription;

  @override
  void initHook() {
    super.initHook();
    _subscription = StreamUserDataUtis.userDataStream.listen((userData) {
      // ignore: use_build_context_synchronously
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
