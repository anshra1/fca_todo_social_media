

part of '../../import.dart';

final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

class HomeViewDrawer extends HookWidget {
  const HomeViewDrawer({super.key});

  static const routeName = 'home-view-drawer';

  @override
  Widget build(BuildContext context) {
    final height = context.height * .89;
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer(
          builder: (BuildContext context, value, Widget? child) {
            return Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Column(
                children: [
                  const DrawerHead(),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: getDrawerTopListItems(context).length,
                            (context, index) {
                              return getDrawerTopListItems(context)[index];
                            },
                          ),
                        ),
                        const DrawerFolderView(),
                      ],
                    ),
                  ),
                  NewListTile(
                    onPressed: () {
                      context.pushNamed(AddFolderDialog.routeName);
                      //context.pushNamed(FolderView.routeName);
                      //  showModalBottomSheet<void>(
                      //   context: AppRouter
                      //       .mainMenuNavigatorKey.currentState!.context,
                      //   isScrollControlled: true,
                      //   isDismissible: false,
                      //   backgroundColor: Colors.transparent,
                      //   builder: (BuildContext context) {
                      //     return BlocProvider.value(
                      //       value: sl<TodoCubit>(),
                      //       child: Padding(
                      //         padding: EdgeInsets.only(
                      //             bottom:
                      //                 MediaQuery.of(context).viewInsets.bottom +
                      //                     20 // 20 is the gap
                      //             ),
                      //         child: SingleChildScrollView(
                      //           child: Center(
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 Container(
                      //                   width: context.width *
                      //                       0.9, // Adjust width as needed
                      //                   margin: const EdgeInsets.symmetric(
                      //                       vertical: 10),
                      //                   child: const AddFolderDialog(),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                  ),
                  kGaps5,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
//  Strings.folderName: folder.folderName,
//                  Strings.folderId: folder.folderId,

List<Widget> getDrawerTopListItems(BuildContext context) {
  final todoManager = Provider.of<TodoManager>(context);
  return [
    DrawerTile(
      icon: const Icon(
        Icons.wb_sunny_outlined,
        size: 22,
        color: Colors.pink,
      ),
      title: 'My Day',
      onTap: () {},
      listLength: 11,
    ),
    DrawerTile(
      icon: const Icon(Icons.star_border, size: 22, color: Colors.pink),
      title: 'Important',
      onTap: () {
        LastNaviagtions.navigateTo(context, ImportantTodos.routeName);
      },
      listLength: todoManager.importantLength,
    ),
    DrawerTile(
      icon: const Icon(Icons.calendar_month, size: 22, color: Colors.green),
      title: 'Planned',
      onTap: () {
        LastNaviagtions.navigateTo(context, PlannedView.routeName);
      },
      listLength: todoManager.plannedTodoLength,
    ),
    DrawerTile(
      icon: Icon(Icons.all_inclusive, size: 22, color: Colors.red.shade500),
      title: 'All',
      onTap: () {
        LastNaviagtions.navigateTo(context, AllTodosView.routeName);
      },
      listLength: todoManager.allTodoLength,
    ),
    DrawerTile(
      icon: Icon(
        Icons.check_circle_outlined,
        size: 22,
        color: Colors.red.shade500,
      ),
      title: 'Completed',
      onTap: () {
        LastNaviagtions.navigateTo(context, CompletedTodoView.routeName);
      },
      listLength: todoManager.completedTodoLength,
    ),
    DrawerTile(
      icon: Icon(
        Icons.check_circle_outlined,
        size: 22,
        color: Colors.red.shade500,
      ),
      title: 'Public',
      onTap: () {
        LastNaviagtions.navigateTo(context, PublicTodos.routeName);
      },
      listLength: todoManager.publicTodoLength,
    ),
    DrawerTile(
      icon: Icon(Icons.home_outlined, size: 22, color: Colors.green.shade600),
      title: 'Tasks',
      onTap: () {
        LastNaviagtions.navigateTo(
          context,
          FolderView.routeName,
          folderId: Strings.tasksId,
          foldername: Strings.tasks,
        );
      },
      listLength: todoManager.folderTodoLength(Strings.tasksId),
    ),
    const Divider(color: Colors.grey, thickness: .3),
  ];
}
