import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
              return todo.folderName == folder.folderName;
            });
            return [
              if (folderList.isNotEmpty)
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        expanded.value = !expanded.value;
                        // setState(() {
                        //   expandedStates[folder.folderName] =
                        //       !(expandedStates[folder.folderName] ?? false);
                        // });
                      },
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
