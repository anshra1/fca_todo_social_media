import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
import 'package:flutter_learning_go_router/src/home_view/presentation/widgets/bottom_sheet_add_task.dart';

class HomeViewFloatingActionButton extends StatelessWidget {
  const HomeViewFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green.shade800,
      onPressed: () {
        BottomSheetAddTask.showAddTaskBottomSheet(
          context,
          context.read<TodoCubit>(),
          null,
          false,
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
