part of '../../import.dart';

class BaseClass extends HookWidget {
  const BaseClass({
    required this.body,
    required this.title,
    required this.settingNotifier,
    this.isFloatingActionButton = true,
    this.folderId,
    this.type = false,
    this.showImportantSheetTile = true,
    this.isFolder = false,
    this.showCompletedTaskNotifier,
    this.deleteListFunction,
    this.renameListFunction,
    this.onShowCompletedTasksChanged,
    this.isSort = true,
    super.key,
  });

  final String title;
  final Widget body;
  final bool isFloatingActionButton;
  final String? folderId;
  final bool type;
  final bool showImportantSheetTile;
  final bool isFolder;
  final ValueNotifier<bool>? showCompletedTaskNotifier;
  final void Function()? renameListFunction;
  final void Function()? deleteListFunction;
  final VoidCallback? onShowCompletedTasksChanged;
  final bool isSort;
  final ValueNotifier<Setting> settingNotifier;

  @override
  Widget build(BuildContext context) {
    'life'.printFirst();
    final appLifecycleState = useAppLifecycleTodo();

    print('app in base class $appLifecycleState');

    return BlocListener<TodoCubit, TodoState>(
      listener: (context, state) {
        if (state is TodoError) {
          ErrorDialog(message: state.message).present(context);
        } else if (state is SyncCompleted) {
          CoreUtils.showSnackBar(context, 'Sync Completed');
        } else if (state is UpdateImportantCompletedState) {}
      },
      child: RefreshIndicator(
        onRefresh: () {
          context.read<TodoCubit>().sync();
          return Future<void>.value();
        },
        child: ValueListenableBuilder(
          valueListenable: settingNotifier,
          builder: (context, setting, _) {
            TodoManager.updateViewSelectedSetting(
              title: title,
              color: setting.colorName,
              sortCriteria: setting.sortCriteria,
            );
            final color = setting.colorName.toColor();
            return Scaffold(
              backgroundColor: color,
              floatingActionButton: isFloatingActionButton
                  ? HomeViewFloatingActionButton(
                      iconColor: color, folderId: folderId, type: type)
                  : null,
              appBar: HomeViewAppBar(
                title: title,
                appBarColor: color,
                onSortSelected: () async => BaseClassFunction.onSortSelected(
                  context: context,
                  title: title,
                  showImportantSheetTile: showImportantSheetTile,
                  settingNotifier: settingNotifier,
                ),
                onThemeChanged: () => BaseClassFunction.onThemeChanged(
                  context: context,
                  settingNotifier: settingNotifier,
                ),
                onShowCompletedTasksChanged: onShowCompletedTasksChanged,
                showCompletedTaskNotifier: showCompletedTaskNotifier,
                isFolder: isFolder,
                renameListFunction: renameListFunction,
                deleteListFunction: deleteListFunction,
                isSort: isSort,
              ),
              drawer: const HomeViewDrawer(),
              body: body,
            );
          },
        ),
      ),
    );
  }
}

sealed class BaseClassFunction {
  const BaseClassFunction();

  static Future<void> onSortSelected({
    required BuildContext context,
    required String title,
    required bool showImportantSheetTile,
    required ValueNotifier<Setting>? settingNotifier,
  }) async {
    final currentSetting = TodoManager.getViewSelectedSetting(title);

    final sortCriteriaSheetValue = await SortingBottomSheet.showSortOptionsSheet(
      showImportant: showImportantSheetTile,
      context: context,
      sortCriteria: currentSetting.sortCriteria,
    );

    if (sortCriteriaSheetValue != null) {
      TodoManager.updateViewSelectedSetting(
        title: title,
        sortCriteria: sortCriteriaSheetValue,
      );

      settingNotifier!.value = settingNotifier.value.copyWith(
        sortCriteria: sortCriteriaSheetValue,
      );
    }
  }

  static void onThemeChanged({
    required BuildContext context,
    required ValueNotifier<Setting> settingNotifier,
  }) {
    ColorPickerBottomSheet.showColorBottomSheet(
      context: context,
      colorNotifier: settingNotifier,
    );
  }
}
