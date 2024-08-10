

part of '../../import.dart';

class HomeViewAppBar extends HookWidget implements PreferredSizeWidget {
  const HomeViewAppBar({
    required this.title,
    required this.appBarColor,
    this.onSortSelected,
    this.onThemeChanged,
    this.onShowCompletedTasksChanged,
    this.isFolder = false,
    this.renameListFunction,
    this.deleteListFunction,
    this.showCompletedTaskNotifier,
    this.isSort = false,
    this.extraIMenuItems = const [],
    super.key,
  });

  final String title;
  final Color appBarColor;
  final VoidCallback? onSortSelected;
  final VoidCallback? onThemeChanged;
  final List<PopupMenuEntry<String>> extraIMenuItems;
  final VoidCallback? onShowCompletedTasksChanged;
  final ValueNotifier<bool>? showCompletedTaskNotifier;
  final bool isFolder;
  final VoidCallback? renameListFunction;
  final VoidCallback? deleteListFunction;
  final bool isSort;

  @override
  Widget build(BuildContext context) {
    final showCompletedTask = useListenable(showCompletedTaskNotifier);
    return BlocProvider<TodoCubit>.value(
      value: sl<TodoCubit>(),
      child: AppBar(
        elevation: 11,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: Text(
          title,
          style: p26.white.medium.copyWith(letterSpacing: .8),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (isFolder)
                PopupMenuItem<String>(
                  value: 'Rename list',
                  onTap: renameListFunction,
                  child: _buildMenuItem(Icons.delete, 'Rename list'),
                ),
              if (isSort)
                PopupMenuItem<String>(
                  value: 'Sort by',
                  onTap: onSortSelected,
                  child: _buildMenuItem(Icons.star_border, 'Sort By'),
                ),
              PopupMenuItem<String>(
                value: 'change_theme',
                onTap: onThemeChanged,
                child: _buildMenuItem(Icons.color_lens, 'Change Theme'),
              ),
              PopupMenuItem<String>(
                value: 'Add Shortcut to HomeScreen',
                onTap: onThemeChanged,
                child: _buildMenuItem(
                  Icons.color_lens,
                  'Add Shortcut to HomeScreen',
                ),
              ),
              if (title == 'Important') ...[
                PopupMenuItem<String>(
                  value: 'Show Completed Tasks',
                  onTap: deleteListFunction,
                  child: _buildMenuItem(
                    Icons.tapas_sharp,
                    showCompletedTask!.value
                        ? 'Hide Completed Tasks'
                        : 'Show Completed Tasks',
                  ),
                ),
              ],
              PopupMenuItem<String>(
                value: 'Send a Copy',
                onTap: onThemeChanged,
                child: _buildMenuItem(Icons.color_lens, 'Send a Copy'),
              ),
              PopupMenuItem<String>(
                value: 'Print List',
                onTap: onThemeChanged,
                child: _buildMenuItem(Icons.color_lens, 'Print List'),
              ),
              if (isFolder && title != Strings.tasks)
                PopupMenuItem<String>(
                  value: 'Delete list',
                  onTap: deleteListFunction,
                  child: _buildMenuItem(Icons.delete, 'Delete list'),
                ),
              ...extraIMenuItems,
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildMenuItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(width: 10),
        Text(
          text,
          style: p16.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}
