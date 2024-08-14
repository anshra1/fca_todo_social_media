part of '../import.dart';

class TodoManager extends ChangeNotifier {
  TodoManager() {
    _updateTodos();
    HiveBox.taskBox.listenable().addListener(_updateTodos);
  }

  List<Todo> list = [];
  List<Todo> importantTodos = [];
  List<Todo> completedTodos = [];
  List<Todo> publicTodos = [];
  List<Todo> plannedTodos = [];
  Map<String, int> folderLengths = {};

  void _updateTodos() {
    list = HiveBox.taskBox.values.toList();
    importantTodos =
        list.where((todo) => todo.isImportant && !todo.isCompleted).toList();
    completedTodos = list.where((todo) => todo.isCompleted).toList();
    publicTodos = list.where((todo) => todo.type == Strings.public).toList();
    plannedTodos =
        list.where((todo) => todo.dueTime.correctDateCheck()).toList();
    folderLengths = {};
    for (final todo in list) {
      folderLengths[todo.folderId] = (folderLengths[todo.folderId] ?? 0) + 1;
    }

    notifyListeners();
  }

  int get importantLength => importantTodos.length;
  int get completedTodoLength => completedTodos.length;
  int get allTodoLength => list.length;
  int get publicTodoLength => publicTodos.length;
  int get plannedTodoLength => plannedTodos.length;
  int folderTodoLength(String folderId) => folderLengths[folderId] ?? 0;

  @override
  void dispose() {
    HiveBox.taskBox.listenable().removeListener(_updateTodos);
    super.dispose();
  }

  static ValueListenable<Box<Todo>> get taskBoxListenable =>
      HiveBox.taskBox.listenable();

  static ValueListenable<Box<Setting>> get settingBoxListenable =>
      HiveBox.settingBox.listenable();

  static Iterable<Folder> get folderList => HiveBox.folderBox.values;

  static Iterable<Todo> get todoList => HiveBox.taskBox.values;

  static Folder? getFolder(String folderId) {
    return HiveBox.folderBox.get(folderId);
  }

  static Future<void> navigateToLastRoute(BuildContext context) async {
    final lastRoute = HiveBox.commonBox.get(Strings.lastPage)?.value
        as Map<dynamic, dynamic>?;

    (() {
      if (lastRoute != null &&
          lastRoute[Strings.lastPage].toString() != HomeClass.routeName) {
        context.pushReplacementNamed(
          lastRoute[Strings.lastPage] as String? ?? AllTodosView.routeName,
          extra: {
            Strings.folderName: lastRoute[Strings.folderName] as String?,
            Strings.folderId: lastRoute[Strings.folderId] as String?,
          },
        );
      } else {
        context.pushReplacementNamed(AllTodosView.routeName);
      }
    }).executeAfterFrame();
  }

  static void firstTimeLoad(BuildContext context) {
    var firstTimeLoad = (HiveBox.commonBox
            .get(Strings.firstTimeLoad, defaultValue: const Common(false)))
        ?.value as bool;

    if (!firstTimeLoad) {
      context.read<TodoCubit>().firstTimeLoad();
      HiveBox.commonBox.put(Strings.firstTimeLoad, const Common(true));
    }
  }

  static Setting getViewSelectedSetting(String title) {
    return HiveBox.settingBox.get(title) ?? Setting.defaultSetting();
  }

  static void addSetting(String title, Setting setting) {
    HiveBox.settingBox.put(title, setting);
  }

  static void updateViewSelectedSetting({
    required String title,
    String? color,
    SortCriteria? sortCriteria,
  }) {
    final currentSetting = HiveBox.settingBox.get(title) ??
        Setting(
          sortCriteria: SortCriteria.none,
          colorName: Colors.green.shade900.toHex(),
        );

    final newSetting = Setting(
      sortCriteria: sortCriteria ?? currentSetting.sortCriteria,
      colorName: color ?? currentSetting.colorName,
    );

    HiveBox.settingBox.put(title, newSetting);
  }
}
