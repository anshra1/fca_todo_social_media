
part of '../../import.dart';

class FolderView extends StatefulHookWidget {
  const FolderView({
    required this.title,
    required this.folderid,
    required this.newFolder,
    super.key,
  });

  static const routeName = 'folder-view';
  final String title;
  final String folderid;
  final bool newFolder;

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  late ValueNotifier<Setting> setting;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.newFolder && !GlobalWidgetDialog.instance().isShowing) {
    //     GlobalWidgetDialog.instance().show(
    //         context: context,
    //         child: BlocProvider.value(
    //           value: sl<TodoCubit>(),
    //           child: const AddFolderDialog(),
    //         ));
    //   } else {
    //     GlobalWidgetDialog.instance().isShowing
    //         ? GlobalWidgetDialog.instance().hide()
    //         : null;
    //   }
    //   // showModalBottomSheet<void>(
    //   //   context: context,
    //   //   isScrollControlled: true,
    //   //   isDismissible: false,
    //   //   backgroundColor: Colors.transparent,
    //   //   builder: (context) {
    //   //     return Padding(
    //   //       padding: EdgeInsets.only(
    //   //           bottom: MediaQuery.of(context).viewInsets.bottom +
    //   //               20 // 20 is the gap
    //   //           ),
    //   //       child: SingleChildScrollView(
    //   //         child: Center(
    //   //           child: Column(
    //   //             mainAxisSize: MainAxisSize.min,
    //   //             children: [
    //   //               Container(
    //   //                 width: context.width * 0.9, // Adjust width as needed
    //   //                 margin: const EdgeInsets.symmetric(vertical: 10),
    //   //                 child: const AddFolderDialog(),
    //   //               ),
    //   //             ],
    //   //           ),
    //   //         ),
    //   //       ),
    //   //     );
    //   //   },
    //   // );
    // });

    setting = ValueNotifier<Setting>(
        HiveBox.settingBox.get(widget.title) ?? Setting.defaultSetting());
  }

  @override
  void dispose() {
    setting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseClass(
      title: widget.title,
      folderId: widget.folderid,
      isFolder: true,
      settingNotifier: setting,
      renameListFunction: () {
        final folder = HiveBox.folderBox.get(widget.folderid);
        if (folder != null) {
          GlobalWidgetDialog.instance().show(
            context: context,
            child: BlocProvider.value(
              value: sl<TodoCubit>(),
              child: RenameFolderDialog(folder.folderId),
            ),
          );
        }
      },
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
                        .where((todo) => todo.folderId == widget.folderid)
                        .toList();
                  } else {
                    if (sortReverse.value) {
                      folderItemListTodos = HiveBox.taskBox.values
                          .where((todo) => todo.folderId == widget.folderid)
                          .toList()
                          .sortByCriteria(setting.value.sortCriteria)
                          .reversed
                          .toList();
                    } else {
                      folderItemListTodos = HiveBox.taskBox.values
                          .where((todo) => todo.folderId == widget.folderid)
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
                          title: 'Sorted by ${setting.value.sortCriteria.name}',
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
