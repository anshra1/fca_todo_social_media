import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';
import 'package:flutter_learning_go_router/core/services/import.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/drawer_folder_view.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/drawer_header.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/drawer_tile.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/new_list_tile.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/show_folder_dialog.dart';

class HomeViewDrawer extends StatelessWidget {
  const HomeViewDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height * .89;
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            const DrawerHead(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: drawerTopListItem.length,
                      (context, index) {
                        return drawerTopListItem[index];
                      },
                    ),
                  ),
                  const DrawerFolderView(),
                ],
              ),
            ),
            NewListTile(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => sl<TodoCubit>(),
                      child: const AddFolderDialog(),
                    );
                  },
                );
              },
            ),
            kGaps5,
          ],
        ),
      ),
    );
  }
}

List<Widget> drawerTopListItem = [
  DrawerTile(
    icon: Icon(
      Icons.wb_sunny_outlined,
      size: 22,
      color: Colors.grey.shade700,
    ),
    title: 'My Day',
    onTap: () {},
    listLength: 11,
  ),
  DrawerTile(
    icon: const Icon(Icons.star_border, size: 22, color: Colors.pink),
    title: 'Important',
    onTap: () {},
    listLength: 11,
  ),
  DrawerTile(
    icon: const Icon(
      Icons.calendar_month,
      size: 22,
      color: Colors.green,
    ),
    title: 'Planned',
    onTap: () {},
    listLength: 11,
  ),
  DrawerTile(
    icon: Icon(
      Icons.all_inclusive,
      size: 22,
      color: Colors.red.shade500,
    ),
    title: 'All',
    onTap: () {},
    listLength: 11,
  ),
  DrawerTile(
    icon: Icon(
      Icons.check_circle_outlined,
      size: 22,
      color: Colors.red.shade500,
    ),
    title: 'Completed',
    onTap: () {},
    listLength: 11,
  ),
  DrawerTile(
    icon: Icon(
      Icons.home_outlined,
      size: 22,
      color: Colors.green.shade600,
    ),
    title: 'Tasks',
    onTap: () {},
    listLength: 11,
  ),
  const Padding(
    padding: EdgeInsets.only(top: 30),
    child: Divider(color: Colors.grey, thickness: .3),
  ),
];
