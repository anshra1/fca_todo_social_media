import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/widget_extension.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/drawer_tile.dart';
import 'package:go_router/go_router.dart';

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
