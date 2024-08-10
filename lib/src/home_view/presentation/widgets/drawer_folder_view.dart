
part of '../import.dart';
class DrawerFolderView extends StatelessWidget {
  const DrawerFolderView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveBox.folderBox.listenable(),
      builder: (context, list, widget) {
        final filterList = list.values.toList().where((folder) {
          return folder.folderId != Strings.taskFolder.folderId;
        }).toList();
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: filterList.length,
            (context, index) {
              final folder = filterList[index];

              return DrawerTile(
                icon: const Icon(Icons.checklist_outlined, size: 22),
                title: folder.folderName,
                onTap: () => LastNaviagtions.navigateTo(
                  context,
                  FolderView.routeName,
                  foldername: folder.folderName,
                  folderId: folder.folderId,
                ),
                listLength: context
                    .read<TodoManager>()
                    .folderTodoLength(folder.folderId),
              );
            },
          ),
        );
      },
    );
  }
}
