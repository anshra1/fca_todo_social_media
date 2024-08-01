// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/provider/todo_manager.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/last_navigations.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/folder_view.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/drawer_tile.dart';
import 'package:hive_flutter/adapters.dart';

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
                    .folderTodoLength(folder.folderName),
              );
            },
          ),
        );
      },
    );
  }
}
