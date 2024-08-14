part of '../import.dart';

class HomeClass extends StatefulHookWidget {
  const HomeClass({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeClass> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeClass> {
  @override
  void initState() {
    super.initState();
    'enter init state'.printFirst();

    context.read<TodoCubit>().startListening();
    context.read<TodoCubit>().sync();
    context.read<TodoCubit>().getErrors();
    TodoManager.firstTimeLoad(context);
    TodoManager.navigateToLastRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    'enter home class'.printFirst();
    useLocalUserModelStreamHook();
    return const SizedBox.shrink();
  }
}
