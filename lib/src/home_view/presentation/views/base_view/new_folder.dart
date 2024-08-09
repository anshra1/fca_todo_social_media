import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/global_dialog/global_dialog.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/utils/last_navigations.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/base_view/folder_view.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddFolderDialog extends HookWidget {
  static const routeName = 'new-folder-view';

  const AddFolderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final textNotifier = useValueNotifier(controller.text.trim());
    final focusNode = useFocusNode();

    useEffect(() {
      controller.addListener(() {
        textNotifier.value = controller.text.trim();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        focusNode.requestFocus();
      });
      return null;
    });

    return Scaffold(
      backgroundColor: Colors.green.shade900,
      resizeToAvoidBottomInset: false,
      // floatingActionButton: const HomeViewFloatingActionButton(),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green.shade900,
        title: ValueListenableBuilder(
          valueListenable: textNotifier,
          builder: (context, text, _) {
            return Text(
              text,
              style: p26.white.medium.copyWith(letterSpacing: .8),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: const [
          Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(),
          AlertDialog(
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
                  context.pop();
                  
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
                  if (controller.text.isNotEmpty) {
                    final id = const Uuid().v1();
                    final folder = Folder.defaults(
                      folderId: id,
                      folderName: controller.text.trim(),
                    );

                    LastNaviagtions.navigateTo(
                      context,
                      FolderView.routeName,
                      foldername: folder.folderName,
                      folderId: folder.folderId,
                    );

                    context.read<TodoCubit>().createFolder(folder);
                  }
                },
                child: ValueListenableBuilder<String>(
                  valueListenable: textNotifier,
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
          ),
        ],
      ),
    );
  }
}
