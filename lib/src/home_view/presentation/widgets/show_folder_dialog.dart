import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/global_dialog/global_dialog.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/folder_view.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddFolderDialog extends HookWidget {
  const AddFolderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useValueNotifier(controller.text.trim());
    final focusNode = useFocusNode();

    useEffect(() {
      controller.addListener(() {
        text.value = controller.text.trim();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        focusNode.requestFocus();
      });
      return null;
    });

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text(
        'New List',
        style: p20.copyWith(fontWeight: FontWeight.w500),
      ),
      content: TextField(
        focusNode: focusNode,
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter list name',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
          onPressed: () async {
            final id = const Uuid().v1();
            final folder = Folder.defaults(
              folderId: id,
              folderName: controller.text.trim(),
            );

            if (controller.text.isNotEmpty) {
              await context.read<TodoCubit>().createFolder(folder);

              if (context.mounted) {
                Navigator.of(context).pop();
                context.pushReplacementNamed(
                  FolderView.routeName,
                  extra: {
                    Strings.folderName: folder.folderName,
                    Strings.folderId: folder.folderId,
                  },
                );
              }
            }
          },
          child: ValueListenableBuilder<String>(
            valueListenable: text,
            builder: (context, value, _) {
              return Text(
                value.isNotEmpty ? 'ADD' : '',
                style: p16.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade800,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
