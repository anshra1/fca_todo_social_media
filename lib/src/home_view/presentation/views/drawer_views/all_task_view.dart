
part of '../../import.dart';

class AllTaskView extends StatefulHookWidget {
  const AllTaskView({super.key});

  @override
  State<AllTaskView> createState() => _AllTaskViewState();
}

class _AllTaskViewState extends State<AllTaskView> {
  Map<String, bool> expandedStates = {};

  @override
  Widget build(BuildContext context) {
    final expanded = ValueNotifier(true);

    return ValueListenableBuilder(
      valueListenable: HiveBox.taskBox.listenable(),
      builder: (BuildContext context, Box<Todo> value, Widget? child) {
        return CustomScrollView(
          slivers: HiveBox.folderBox.values.expand((folder) {
            final folderList = HiveBox.taskBox.values.where((todo) {
              return todo.folderId == folder.folderName;
            });
            return [
              if (folderList.isNotEmpty)
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => expanded.value = !expanded.value,
                      child: Text(folder.folderName),
                    ),
                  ),
                ),
              ValueListenableBuilder(
                valueListenable: expanded,
                builder: (context, object, _) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final todo = folderList.elementAt(index);
                        return expanded.value
                            ? ListTile(
                                title: Text('Item $index in ${todo.todoName}'),
                              )
                            : null;
                      },
                      childCount: folderList.length,
                    ),
                  );
                },
              ),
            ];
          }).toList(),
        );
      },
    );
  }
}
