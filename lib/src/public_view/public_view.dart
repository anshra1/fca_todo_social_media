import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';

class PublicView extends StatelessWidget {
  const PublicView({super.key});

  static const routeName = '/public-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => HiveBox.clear,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: HiveBox.folderBox.values.map((folder) {
            return GestureDetector(
              onTap: (){
                HiveBox.clear();
              },
                child: Text(
                    '${folder.folderName} ${folder.folderId}'));
          }).toList(),
        ),
      ),
    );
  }
}
