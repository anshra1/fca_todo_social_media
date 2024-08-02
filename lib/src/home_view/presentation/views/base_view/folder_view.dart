// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/dialog/alert_dialog_model.dart';
import 'package:flutter_learning_go_router/core/common/dialog/delete_dialog.dart';
import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:flutter_learning_go_router/core/extension/list_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/services/import.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/import.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/user_settings/user_selected_setting.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/last_navigations.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/base_class.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/class/all_todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/home_screen.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/custom_list_tile.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/folder_tile.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/sorted_tile_title.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    required this.title,
    required this.folderid,
    super.key,
  });

  static const routeName = 'folder-view';
  final String title;
  final String folderid;

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  late ValueNotifier<Setting> setting;

  @override
  void initState() {
    super.initState();
    setting = ValueNotifier<Setting>(
        HiveBox.settingBox.get(widget.title) ?? Setting.defaultSetting());
  }

  @override
  Widget build(BuildContext context) {
    return BaseClass(
      title: widget.title,
      folderName: widget.title,
      isFolder: true,
      settingNotifier: setting,
      renameListFunction: () {},
      deleteListFunction: () async {
        final folder = HiveBox.folderBox.get(widget.folderid);
        if (folder != null) {
          await const DeleteDialog().present(context).then((onValue) {
            if (onValue == null) return;
            if (onValue == true) {
              LastNaviagtions.navigateTo(context, AllTodosView.routeName);
              sl<TodoCubit>().deleteFolders(folder.folderId);
            }
          });
        }
      },
      body: ValueListenableBuilder(
        valueListenable: setting,
        builder: (context, _, __) {
          HiveBox.settingBox.put(
            widget.title,
            Setting(
              sortCriteria: setting.value.sortCriteria,
              colorName: setting.value.colorName,
            ),
          );
    
          return ValueListenableBuilder(
            valueListenable: HiveBox.taskBox.listenable(),
            builder: (context, box, __) {
              return HookBuilder(
                builder: (context) {
                  final sortReverse = useState(false);
                  var folderItemListTodos = <Todo>[];
                  if (setting.value.sortCriteria == SortCriteria.none) {
                    folderItemListTodos = HiveBox.taskBox.values
                        .where((todo) => todo.folderName == widget.title)
                        .toList();
                  } else {
                    if (sortReverse.value) {
                      folderItemListTodos = HiveBox.taskBox.values
                          .where((todo) => todo.folderName == widget.title)
                          .toList()
                          .sortByCriteria(setting.value.sortCriteria)
                          .reversed
                          .toList();
                    } else {
                      folderItemListTodos = HiveBox.taskBox.values
                          .where((todo) => todo.folderName == widget.title)
                          .toList()
                          .sortByCriteria(setting.value.sortCriteria)
                          .toList();
                    }
                  }
    
                  final unDoneTodoList = useMemoized(() {
                    return folderItemListTodos
                        .where((todo) => !todo.isCompleted)
                        .toList();
                  }, [folderItemListTodos]);
    
                  final doneTodoList = useMemoized(() {
                    return folderItemListTodos
                        .where((todo) => todo.isCompleted)
                        .toList();
                  }, [folderItemListTodos]);
    
                  return Column(
                    children: [
                      if (setting.value.sortCriteria != SortCriteria.none)
                        SortedTileTitle(
                          title:
                              'Sorted by ${setting.value.sortCriteria.name}',
                          isCollapse: sortReverse.value,
                          reverseSortCriteria: () =>
                              sortReverse.value = !sortReverse.value,
                          closeSorting: () => setting.value = setting.value
                              .copyWith(sortCriteria: SortCriteria.none),
                        ),
                      Expanded(
                        child: CustomScrollSingleFolderView(
                          unDoneTodoList: unDoneTodoList,
                          doneTodoList: doneTodoList,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CustomScrollSingleFolderView extends HookWidget {
  const CustomScrollSingleFolderView({
    required this.unDoneTodoList,
    required this.doneTodoList,
    super.key,
  });

  final List<Todo> unDoneTodoList;
  final Iterable<Todo> doneTodoList;

  @override
  Widget build(BuildContext context) {
    final collapse = useValueNotifier(true);
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final todo = unDoneTodoList.elementAt(index);
              return CustomListTile(todo: todo);
            },
            childCount: unDoneTodoList.length,
          ),
        ),
        if (doneTodoList.isNotEmpty)
          SliverToBoxAdapter(
            child: FolderTile(
              title: 'Completed',
              isCollapse: collapse.value,
              onPressed: () {
                collapse.value = !collapse.value;
              },
            ),
          ),
        ValueListenableBuilder(
          valueListenable: collapse,
          builder: (context, value, widget) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = doneTodoList.elementAt(index);
                  return collapse.value
                      ? CustomListTile(todo: todo)
                      : const SizedBox.shrink();
                },
                childCount: doneTodoList.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
