part of '../../import.dart';

class ShowAllFoldersShell extends StatefulHookWidget {
  const ShowAllFoldersShell({
    required this.title,
    required this.listOfTodoFunction,
    required this.filterFolderTodosFunc,
    this.isFloatingActionButton = false,
    this.showImportantSheetTile = true,
    super.key,
  });

  final String title;
  final List<Todo> Function(String folderId) filterFolderTodosFunc;
  final List<Todo> Function() listOfTodoFunction;
  final bool isFloatingActionButton;
  final bool showImportantSheetTile;

  static const routeName = 'all-folder-view';

  @override
  State<ShowAllFoldersShell> createState() => _ShowAllFoldersShellState();
}

class _ShowAllFoldersShellState extends State<ShowAllFoldersShell> {
  late ValueNotifier<Map<String, bool>> mapNotifier;
  late ValueNotifier<Setting> settingNotifier;
  late bool reverse;

  @override
  void initState() {
    super.initState();
    reverse = false;
    settingNotifier = ValueNotifier<Setting>(
      HiveBox.settingBox.get(widget.title) ?? Setting.defaultSetting(),
    );
    mapNotifier = ValueNotifier<Map<String, bool>>({});

    for (final folder in HiveBox.folderBox.values) {
      mapNotifier.value[folder.folderName] = true;
    }
  }

  @override
  void dispose() {
    mapNotifier.dispose();
    settingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseClass(
      title: widget.title,
      showImportantSheetTile: widget.showImportantSheetTile,
      isFloatingActionButton: widget.isFloatingActionButton,
      body: ValueListenableBuilder(
        valueListenable: HiveBox.settingBox.listenable(),
        builder: (context, _, __) {
          return ValueListenableBuilder(
            valueListenable: HiveBox.taskBox.listenable(),
            builder: (context, _, __) {
              final settings = HiveBox.settingBox.get(widget.title);

              return CustomScrollView(
                slivers: settings != null &&
                        settings.sortCriteria != SortCriteria.none
                    ? _buildAllTodosSilvers(settings.sortCriteria, settings)
                    : _buildFolderSlivers(),
              );
            },
          );
        },
      ),
      settingNotifier: settingNotifier,
    );
  }

  List<Widget> _buildAllTodosSilvers(
    SortCriteria sortCriteria,
    Setting settings,
  ) {
    var todos = <Todo>[];

    if (!reverse) {
      todos = widget.listOfTodoFunction().reverseSortByCriteria(sortCriteria);
    } else {
      todos = widget.listOfTodoFunction().sortByCriteria(sortCriteria);
    }

    return [
      SliverToBoxAdapter(
        child: SortedTileTitle(
          reverseSortCriteria: () {
            setState(() {
              reverse = !reverse;
            });
          },
          title: 'Sorted by ${sortCriteria.toDisplayString()}',
          isCollapse: reverse,
          closeSorting: () async {
            await HiveBox.settingBox.put(
              widget.title,
              settings.copyWith(sortCriteria: SortCriteria.none),
            );

            settingNotifier.value =
                settings.copyWith(sortCriteria: SortCriteria.none);
          },
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return CustomListTile(todo: todos[index]);
          },
          childCount: todos.length,
        ),
      ),
    ];
  }

  List<Widget> _buildFolderSlivers() {
    return HiveBox.folderBox.values.sorted((folder1, folder2) {
      return folder1.folderName.compareTo(folder2.folderName);
    }).expand((folder) {
      final folderList = widget.filterFolderTodosFunc(folder.folderId);

      return [
        if (folderList.isNotEmpty)
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder(
                valueListenable: mapNotifier,
                builder: (BuildContext context, map, Widget? child) {
                  return FolderTile(
                    onPressed: () => _toggleFolder(folder.folderName),
                    title: folder.folderName,
                    isCollapse: map[folder.folderName] ?? false,
                  );
                },
              ),
            ),
          ),
        ValueListenableBuilder(
          valueListenable: mapNotifier,
          builder: (context, maps, _) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = folderList.elementAt(index);
                  return AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: CustomListTile(todo: todo),
                    crossFadeState: maps[folder.folderName] ?? false
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                childCount: folderList.length,
              ),
            );
          },
        ),
      ];
    }).toList();
  }

  void _toggleFolder(String folderName) {
    final newMap = Map<String, bool>.from(mapNotifier.value);
    newMap[folderName] = !(newMap[folderName] ?? false);
    mapNotifier.value = newMap;
  }
}
