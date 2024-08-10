
part of '../import.dart';
class DrawerHead extends StatelessWidget {
  const DrawerHead({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.currentUser?.name.toUpperCase() ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CacheImage(url: context.currentUser!.photoURL, radius: 30),
        kGaps10,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: p16.bold.copyWith(letterSpacing: .85)),
            2.gap,
            const Text('You are Offline'),
          ],
        ),
      ],
    );
  }
}
