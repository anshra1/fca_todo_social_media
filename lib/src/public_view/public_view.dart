import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';

class PublicView extends StatelessWidget {
  const PublicView({super.key});

  static const routeName = '/public-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: HiveBox.taskBox.values.map((todo) {
          return GestureDetector(
            onTap: (){
              HiveBox.clear();
            },
              child: Text(
                  '${todo.todoName} ${todo.folderId} ${todo.isCompleted}'));
        }).toList(),
      ),
    );
  }
}
