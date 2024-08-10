

part of '../import.dart';

class HomeClass extends StatefulHookWidget {
  const HomeClass({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeClass> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeClass> {
  late SyncManager _syncManager;

  @override
  void initState() {
    super.initState();

    var firstTimeLoad = (HiveBox.commonBox
            .get(Strings.firstTimeLoad, defaultValue: const Common(false)))
        ?.value as bool;

    if (!firstTimeLoad) {
      context.read<TodoCubit>().firstTimeLoad();
      HiveBox.commonBox.put(Strings.firstTimeLoad, const Common(true));
    }

    _syncManager = SyncManager(context);
    _syncManager.startListening();
    _navigateToLastRoute();
  }

  void clear() async {
    await HiveBox.clear();
  }

  Future<void> _navigateToLastRoute() async {
    final lastRoute = HiveBox.commonBox.get(Strings.lastPage)?.value
        as Map<dynamic, dynamic>?;

    (() {
    //  LoadingScreen.instance().show(context: context);
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

    // if (lastRoute != null &&
    //     lastRoute[Strings.lastPage].toString() != HomeClass.routeName) {
    //   (() {
    //     context.pushReplacementNamed(
    //       lastRoute[Strings.lastPage] as String? ?? AllTodosView.routeName,
    //       extra: {
    //         Strings.folderName: lastRoute[Strings.folderName] as String?,
    //         Strings.folderId: lastRoute[Strings.folderId] as String?,
    //       },
    //     );
    //   }).executeAfterFrame();
    // } else {
    //   (() {
    //     context.pushReplacementNamed(AllTodosView.routeName);
    //   }).executeAfterFrame();
    // }
  }

  @override
  void dispose() {
    //  _syncManager.dispose();
   // LoadingScreen.instance().hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    useLocalUserModelStreamHook();
    final appLifecycleState = useAppLifecycleState();

    if (appLifecycleState == AppLifecycleState.resumed) {
      //'app resume'.printFirst();
      //  _syncManager.startListening();
    } else if (appLifecycleState == AppLifecycleState.detached) {
      'app detach'.printFirst();
      _syncManager.dispose();
    } else if (appLifecycleState == AppLifecycleState.inactive) {
      'app inative'.printFirst();
      _syncManager.dispose();
    }

    return const SizedBox.shrink();
  }
}
