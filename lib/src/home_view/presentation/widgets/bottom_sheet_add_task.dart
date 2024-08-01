// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/dialog/alert_dialog_model.dart';
import 'package:flutter_learning_go_router/core/common/dialog/error_dialog.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/string_extension.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/import.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/views/animation.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/select_date_widget.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/show_folder_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class BottomSheetAddTask {
  BottomSheetAddTask._();

  static void showAddTaskBottomSheet(
    BuildContext context,
    TodoCubit cubit,
    String? folderName,
    bool type,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: AddTaskBottomSheet(
            folderName: folderName,
            type: type,
          ),
        );
      },
    );
  }
}

class AddTaskBottomSheet extends HookWidget {
  const AddTaskBottomSheet({this.folderName, this.type = false, super.key});

  final String? folderName;
  final bool type;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final folderNotifier = useValueNotifier<String?>(folderName);
    final dueDateNotifier = useValueNotifier('');
    final typeNotifier = useValueNotifier(type);

    final smoothKeyboardKey =
        useMemoized(() => GlobalKey<SmoothKeyboardDismissState>());

    return BlocListener<TodoCubit, TodoState>(
      listener: (context, state) {
        if (state is TodoError) {
          ErrorDialog(message: state.message).present(context);
        }
      },
      child: SmoothKeyboardDismiss(
        key: smoothKeyboardKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  onEditingComplete: () => context.pop(),
                  decoration: InputDecoration(
                    hintText: 'Add a task',
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
                              folderName: folderNotifier.value != null
                                  ? folderNotifier.value!
                                  : Strings.tasks,
                              dueTime: dueDateNotifier.value,
                              type: typeNotifier.value
                                  ? Strings.public
                                  : Strings.private,
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
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (folderNotifier.value == null)
                        ValueListenableBuilder(
                          valueListenable: folderNotifier,
                          builder: (context, folderNa, widget) {
                            return TextButton.icon(
                              icon: const Icon(Icons.list),
                              label: Text(folderNotifier.value ?? 'Set folder'),
                              onPressed: () async {
                                final folder =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  builder: (context) {
                                    return const ShowFolderBottomSheet();
                                  },
                                );

                                if (folder != null) {
                                  folderNotifier.value = folder;
                                }
                              },
                            );
                          },
                        )
                      else
                        const SizedBox.shrink(),
                      ValueListenableBuilder(
                        valueListenable: dueDateNotifier,
                        builder: (context, dueDate, widget) {
                          if (dueDateNotifier.value.isEmpty) {
                            return TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Set due date'),
                              onPressed: () async {
                                final date = await CoreUtils.pickDate(context);
                                if (date != null) {
                                  dueDateNotifier.value =
                                      date.toIso8601String();
                                }
                              },
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                final date = await CoreUtils.pickDate(context);
                                if (date != null) {
                                  dueDateNotifier.value =
                                      date.toIso8601String();
                                }
                              },
                              child: SelectDateWidget(
                                onPressed: () {
                                  dueDateNotifier.value = '';
                                },
                                selectedDate:
                                    dueDateNotifier.value.toDueDateString(),
                              ),
                            );
                          }
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: typeNotifier,
                        builder: (context, type, widget) {
                          return TextButton.icon(
                            icon: const Icon(Icons.av_timer_sharp),
                            label: Text(
                              typeNotifier.value
                                  ? Strings.public
                                  : Strings.private,
                            ),
                            onPressed: () {
                              typeNotifier.value = !typeNotifier.value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}