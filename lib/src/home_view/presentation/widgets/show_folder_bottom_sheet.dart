
part of '../import.dart';
class ShowFolderBottomSheet extends StatelessWidget {
  const ShowFolderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: HiveBox.folderBox.values.map((folder) {
        return DrawerTile(
          icon: Icon(
            Icons.list,
            color: Colors.blue.shade700,
          ),
          title: folder.folderName,
          onTap: () {
            context.pop(folder);
          },
        ).leftPadding(20);
      }).toList(),
    );
  }
}
