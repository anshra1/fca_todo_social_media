import 'package:flutter/widgets.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:go_router/go_router.dart';

class LastNaviagtions {
  static Future<void> navigateTo(
    BuildContext context,
    String routeName, {
    String? foldername,
    String? folderId,
  }) async {
    final map = <String, String?>{
      Strings.lastPage: routeName,
      Strings.folderName: foldername,
      Strings.folderId: folderId,
    };

    await HiveBox.commonBox.put(Strings.lastPage, Common(map)).then((_) {
      context.pushNamed(
        routeName,
        extra: {
          Strings.folderName: foldername,
          Strings.folderId: folderId,
        },
      );
    });
  }
}
