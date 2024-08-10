
part of '../../import.dart';

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
