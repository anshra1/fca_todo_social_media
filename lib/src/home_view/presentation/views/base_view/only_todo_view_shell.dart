import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:flutter_learning_go_router/core/extension/list_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/user_settings/user_selected_setting.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/base_class.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/custom_list_tile.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/sorted_tile_title.dart';
import 'package:hive_flutter/adapters.dart';

class OnlyTodoShell extends StatefulWidget {
  const OnlyTodoShell({
    required this.title,
    required this.listOfTodo,
    required this.isFloatingActionButton,
    this.type = false,
    this.showImportantSheetTile = true,
    this.showCompletedTask = false,
    this.showCompletedTaskNotifier,
    this.onShowCompletedTasksChanged,
    super.key,
  });

  final List<Todo> Function() listOfTodo;
  final String title;
  final bool isFloatingActionButton;
  final bool type;
  final bool showImportantSheetTile;
  final bool showCompletedTask;
  final ValueNotifier<bool>? showCompletedTaskNotifier;
  final VoidCallback? onShowCompletedTasksChanged;

  @override
  State<OnlyTodoShell> createState() => _OnlyTodoShellState();
}

class _OnlyTodoShellState extends State<OnlyTodoShell> {
  late ValueNotifier<Setting> settingNotifier;

  @override
  void initState() {
    super.initState();
    settingNotifier = ValueNotifier<Setting>(
      HiveBox.settingBox.get(widget.title) ?? Setting.defaultSetting(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseClass(
      title: widget.title,
      settingNotifier: settingNotifier,
      isFloatingActionButton: widget.isFloatingActionButton,
      type: widget.type,
      showImportantSheetTile: widget.showImportantSheetTile,
      onShowCompletedTasksChanged: widget.onShowCompletedTasksChanged,
      showCompletedTaskNotifier: widget.showCompletedTaskNotifier,
      body: ValueListenableBuilder(
        valueListenable: settingNotifier,
        builder: (context, setting, _) {
          return ValueListenableBuilder(
            valueListenable: HiveBox.taskBox.listenable(),
            builder: (context, __, _) {
              return ListViewTodoBuilder(
                settingNotifier: settingNotifier,
                widget: widget,
              );
            },
          );
        },
      ),
    );
  }
}

class ListViewTodoBuilder extends StatelessWidget {
  const ListViewTodoBuilder({
    required this.settingNotifier,
    required this.widget,
    super.key,
  });

  final ValueNotifier<Setting> settingNotifier;
  final OnlyTodoShell widget;

  @override
  Widget build(BuildContext context) {
    final setting = settingNotifier.value;
    return HookBuilder(
      builder: (context) {
        final reverseSortCriteria = useState(false);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (setting.sortCriteria != SortCriteria.none)
              SortedTileTitle(
                title: 'Sorted by ${setting.sortCriteria.name}',
                isCollapse: reverseSortCriteria.value,
                reverseSortCriteria: () =>
                    reverseSortCriteria.value = !reverseSortCriteria.value,
                closeSorting: () {
                  settingNotifier.value = settingNotifier.value
                      .copyWith(sortCriteria: SortCriteria.none);
                },
              ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.listOfTodo().length,
                itemBuilder: (context, index) {
                  var showList = <Todo>[];
                      
                  if (setting.sortCriteria != SortCriteria.none) {
                    if (reverseSortCriteria.value) {
                      showList = widget
                          .listOfTodo()
                          .sortByCriteria(setting.sortCriteria)
                          .reversed
                          .toList();
                    } else {
                      showList = widget
                          .listOfTodo()
                          .sortByCriteria(setting.sortCriteria)
                          .toList();
                    }
                  } else {
                    showList = widget.listOfTodo();
                  }
                      
                  final todo = showList.elementAt(index);
                  return CustomListTile(todo: todo);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
