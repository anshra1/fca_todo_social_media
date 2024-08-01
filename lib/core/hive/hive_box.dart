import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/w_todo.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/user_settings/user_selected_setting.dart';
import 'package:hive/hive.dart';

class HiveBox {
  HiveBox._();
  static const taskBoxName = 'newTasks';
  static late Box<Todo> taskBox;

  static const pendingTaskBoxName = 'newPendingBoxs';
  static late Box<WhatTodo> pendingTaskBox;

  static const taskFolderName = 'newTaskFolderNamest';
  static late Box<Folder> folderBox;

  static late Box<Common> commonBox;
  static const commonBoxName = 'newCommonBoxs';

  static late Box<Setting> settingBox;
  static const settingBoxName = 'newSettingBoxs';

  static Future<void> init() async {
    taskBox = await Hive.openBox<Todo>(HiveBox.taskBoxName);
    folderBox = await Hive.openBox<Folder>(HiveBox.taskFolderName);
    pendingTaskBox = await Hive.openBox<WhatTodo>(HiveBox.pendingTaskBoxName);
    commonBox = await Hive.openBox<Common>(HiveBox.commonBoxName);
    settingBox = await Hive.openBox<Setting>(HiveBox.settingBoxName);
    await folderBox.put(Strings.tasksId, Strings.taskFolder);
  }

  static Future<void> close() async {
    await taskBox.close();
    await folderBox.close();
    await pendingTaskBox.close();
    await commonBox.close();
    await settingBox.close();
  }

  static Future<void> clear() async {
    await taskBox.clear();
    await folderBox.clear();
    await pendingTaskBox.clear();
    await commonBox.clear();
    await settingBox.clear();
  }
}
