import 'package:flutter/material.dart';

class HomeViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: const Text('User Profile'),
      leading: GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer,
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: const Icon(Icons.menu),
        ),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
