import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/object_extension.dart';
import 'package:flutter_learning_go_router/core/extension/string_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/provider/todo_manager.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/user_settings/user_selected_setting.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/screen_components/app_bar.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/screen_components/drawer.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/screen_components/floating_action_button.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/color_picker_bottom_sheet.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/sorting_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class BaseClass extends StatelessWidget {
  const BaseClass({
    required this.body,
    required this.title,
    required this.settingNotifier,
    this.isFloatingActionButton = true,
    this.folderName,
    this.type = false,
    this.showImportantSheetTile = true,
    this.isFolder = false,
    this.showCompletedTaskNotifier,
    this.deleteListFunction,
    this.renameListFunction,
    this.onShowCompletedTasksChanged,
    this.isSort = true,
    super.key,
  });

  final String title;
  final Widget body;
  final bool isFloatingActionButton;
  final String? folderName;
  final bool type;
  final bool showImportantSheetTile;
  final bool isFolder;
  final ValueNotifier<bool>? showCompletedTaskNotifier;
  final void Function()? renameListFunction;
  final void Function()? deleteListFunction;
  final VoidCallback? onShowCompletedTasksChanged;
  final bool isSort;
  final ValueNotifier<Setting> settingNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingNotifier,
      builder: (context, setting, _) {
        TodoManager.updateViewSelectedSetting(
          title: title,
          color: setting.colorName,
          sortCriteria: setting.sortCriteria,
        );
        final color = setting.colorName.toColor();
        return Scaffold(
          backgroundColor: color,
          floatingActionButton: isFloatingActionButton
              ? HomeViewFloatingActionButton(
                  iconColor: color,
                  folderName: folderName,
                  type: type,
                )
              : null,
          appBar: HomeViewAppBar(
            title: title,
            appBarColor: color,
            onSortSelected: () async => BaseClassFunction.onSortSelected(
              context: context,
              title: title,
              showImportantSheetTile: showImportantSheetTile,
              settingNotifier: settingNotifier,
            ),
            onThemeChanged: () => BaseClassFunction.onThemeChanged(
              context: context,
              settingNotifier: settingNotifier,
            ),
            onShowCompletedTasksChanged: onShowCompletedTasksChanged,
            showCompletedTaskNotifier: showCompletedTaskNotifier,
            isFolder: isFolder,
            renameListFunction: renameListFunction,
            deleteListFunction: deleteListFunction,
            isSort: isSort,
          ),
          drawer: const HomeViewDrawer(),
          body: body,
        );
      },
    );
  }
}

sealed class BaseClassFunction {
  const BaseClassFunction();

  static Future<void> onSortSelected({
    required BuildContext context,
    required String title,
    required bool showImportantSheetTile,
    required ValueNotifier<Setting>? settingNotifier,
  }) async {
    final currentSetting =
        HiveBox.settingBox.get(title) ?? Setting.defaultSetting();
    final sortCriteriaSheetValue =
        await SortingBottomSheet.showSortOptionsSheet(
      showImportant: showImportantSheetTile,
      context: context,
      sortCriteria: currentSetting.sortCriteria,
    );

    if (sortCriteriaSheetValue != null) {
      TodoManager.updateViewSelectedSetting(
        title: title,
        sortCriteria: sortCriteriaSheetValue,
      );

      settingNotifier!.value = settingNotifier.value.copyWith(
        sortCriteria: sortCriteriaSheetValue,
      );
    }
  }

  static void onThemeChanged({
    required BuildContext context,
    required ValueNotifier<Setting> settingNotifier,
  }) {
    ColorPickerBottomSheet.showColorBottomSheet(
      context: context,
      colorNotifier: settingNotifier,
    );
  }
}
