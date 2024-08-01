import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/core/common/provider/user_provider.dart';
import 'package:flutter_learning_go_router/src/auth/domain/entities/user.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  UserProvider get userProvider => read<UserProvider>();
  LocalUser? get currentUser => userProvider.user;
}
