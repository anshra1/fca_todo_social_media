import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/global_dialog/global_dialog.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/last_navigations.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/drawer_views/folder_view.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class RenameFolderDialog extends HookWidget {
  const RenameFolderDialog(this.folderId, {super.key});

  final String folderId;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final controller = useTextEditingController();
    final folderNameNotifier = useValueNotifier<String>('');

    final folderNotifierMemo = useMemoized(() {
      return HiveBox.folderBox.get(folderId);
    });

    useEffect(() {
      if (folderNotifierMemo != null) {
        controller.text = folderNotifierMemo.folderName;
      }

      controller.addListener(() {
        folderNameNotifier.value = controller.text;
      });

      focusNode.requestFocus();

      return null;
    });

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text(
        'Rename List',
        style: p20.copyWith(fontWeight: FontWeight.w500),
      ),
      content: TextField(
        focusNode: focusNode,
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            //context.pop();
            GlobalWidgetDialog.instance().hide();
          },
          child: Text(
            'CANCEL',
            style: p16.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<TodoCubit>().updateFolder(
                folderId: folderId, newFolderName: controller.text.trim());

            LastNaviagtions.navigateTo(
              context,
              FolderView.routeName,
              foldername: controller.text.trim(),
              folderId: folderNotifierMemo!.folderId,
            );

            GlobalWidgetDialog.instance().hide();
          },
          child: ValueListenableBuilder<String>(
            valueListenable: folderNameNotifier,
            builder: (context, folderName, _) {
              return folderName.isNotEmpty &&
                      folderNotifierMemo!.folderName != controller.text.trim()
                  ? Text(
                      'Update',
                      style: p16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade800,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
