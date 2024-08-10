

part of '../import.dart';



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
