import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/bottom_sheet_add_task.dart';

class HomeViewFloatingActionButton extends StatelessWidget {
  const HomeViewFloatingActionButton({
    this.iconColor,
    this.folderId,
    this.type = false,
    super.key,
  });

  static const routeName = 'homeViewFloatingActionButton';
  final String? folderId;
  final bool type;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: iconColor,
      onPressed: () {
        BottomSheetAddTask.showAddTaskBottomSheet(
          context,
          context.read<TodoCubit>(),
          folderId,
          type,
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
