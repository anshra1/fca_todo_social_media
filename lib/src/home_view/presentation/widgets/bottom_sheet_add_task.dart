// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters



part of '../import.dart';

class BottomSheetAddTask {
  BottomSheetAddTask._();

  static void showAddTaskBottomSheet(
    BuildContext context,
    TodoCubit cubit,
    String? folderId,
    bool type,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: AddTaskBottomSheet(
            folderId: folderId,
            type: type,
          ),
        );
      },
    );
  }
}

class AddTaskBottomSheet extends HookWidget {
  const AddTaskBottomSheet({this.folderId, this.type = false, super.key});

  final String? folderId;
  final bool type;

  @override
  Widget build(BuildContext context) {
    'ids $folderId'.printFirst();
    final controller = useTextEditingController();
    final folderNotifier = ValueNotifier<Folder>(Strings.taskFolder);

    final dueDateNotifier = useValueNotifier('');
    final typeNotifier = useValueNotifier(type);

    useEffect(() {
      if (folderId != null) {
        final getFolder = HiveBox.folderBox.get(folderId);
        if (getFolder != null) {
          folderNotifier.value = getFolder;
        }
      }

      return null;
    }, [folderId]);

    return BlocListener<TodoCubit, TodoState>(
      listener: (context, state) {
        if (state is TodoError) {
          ErrorDialog(message: state.message).present(context);
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addTaskField(controller, context, folderNotifier, dueDateNotifier,
                  typeNotifier),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    setFolderId(folderNotifier),
                    setDueDate(dueDateNotifier),
                    setType(typeNotifier),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField addTaskField(
      TextEditingController controller,
      BuildContext context,
      ValueNotifier<Folder> folderNotifier,
      ValueNotifier<String> dueDateNotifier,
      ValueNotifier<bool> typeNotifier) {
    return TextField(
      controller: controller,
      autofocus: true,
      onEditingComplete: () => context.pop(),
      decoration: InputDecoration(
        hintText: 'Add Task',
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16).copyWith(left: 25),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 25),
          child: GestureDetector(
            onTap: () {
              final id = const Uuid().v1();
              final uid = context.currentUser?.uid;
              final userName = context.currentUser?.name;

              //
              if (uid != null && userName != null) {
                final todo = Todo.defaults(
                  important: false,
                  uid: uid,
                  userName: userName,
                  todoId: id,
                  todoName: controller.text.trim(),
                  time: DateTime.now(),
                  folderId: folderNotifier.value.folderId,
                  dueTime: dueDateNotifier.value,
                  type: typeNotifier.value ? Strings.public : Strings.private,
                );
                //
                context.read<TodoCubit>().addTask(todo);
                controller.clear();
                dueDateNotifier.value = '';
                //
              } else {
                context.go(PhoneNumberView.routeName);
              }
            },
            child: const Icon(Icons.upload),
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> setType(ValueNotifier<bool> typeNotifier) {
    return ValueListenableBuilder(
      valueListenable: typeNotifier,
      builder: (context, _, widget) {
        return TextButton.icon(
          icon: const Icon(Icons.av_timer_sharp),
          label: Text(
            typeNotifier.value ? Strings.public : Strings.private,
          ),
          onPressed: () {
            typeNotifier.value = !typeNotifier.value;
          },
        );
      },
    );
  }

  ValueListenableBuilder<String> setDueDate(
      ValueNotifier<String> dueDateNotifier) {
    return ValueListenableBuilder(
      valueListenable: dueDateNotifier,
      builder: (context, dueDate, widget) {
        if (dueDateNotifier.value.isEmpty) {
          return TextButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Set due date'),
            onPressed: () async {
              final date = await CoreUtils.pickDate(context);
              if (date != null) {
                dueDateNotifier.value = date.toIso8601String();
              }
            },
          );
        } else {
          return GestureDetector(
            onTap: () async {
              final date = await CoreUtils.pickDate(context);
              if (date != null) {
                dueDateNotifier.value = date.toIso8601String();
              }
            },
            child: SelectDateWidget(
              onPressed: () {
                dueDateNotifier.value = '';
              },
              selectedDate: dueDateNotifier.value.toDueDateString(),
            ),
          );
        }
      },
    );
  }

  ValueListenableBuilder<Folder> setFolderId(
    ValueNotifier<Folder> folderNotifier,
  ) {
    return ValueListenableBuilder(
      valueListenable: folderNotifier,
      builder: (context, folder, widget) {
        return folderId == null
            ? TextButton.icon(
                icon: const Icon(Icons.list),
                label: Text(folder.folderName),
                onPressed: () async {
                  final sheetFolder = await showModalBottomSheet<Folder>(
                      context: context,
                      builder: (context) {
                        return const ShowFolderBottomSheet();
                      });

                  if (sheetFolder != null) {
                    folderNotifier.value = sheetFolder;
                  }
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}
