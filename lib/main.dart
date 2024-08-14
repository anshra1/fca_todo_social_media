import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/provider/user_provider.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/res/app_theme.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/import.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'core/enum/sort_criteria.dart';
import 'core/hive/common.dart';
import 'core/services/import.dart';
import 'firebase_options.dart';
import 'src/home_view/domain/entities/folder.dart';
import 'src/home_view/domain/entities/todos.dart';
import 'src/home_view/domain/entities/w_todo.dart';
import 'src/home_view/presentation/user_settings/user_selected_setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive
    ..registerAdapter(TodoAdapter())
    ..registerAdapter(WhatTodoAdapter())
    ..registerAdapter(CommonAdapter())
    ..registerAdapter(SortCriteriaAdapter())
    ..registerAdapter(SettingAdapter())
    ..registerAdapter(FolderAdapter());

  await HiveBox.init();

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TodoManager()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'To-do List',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
