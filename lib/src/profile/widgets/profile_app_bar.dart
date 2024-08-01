import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_learning_go_router/src/profile/views/edit_profile_view.dart';
import 'package:flutter_learning_go_router/src/profile/widgets/pop_up_item.dart';
import 'package:go_router/go_router.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(
        'User Profile',
        style: p24.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Edit Profile',
                  icon: Icon(Icons.edit_outlined),
                ),
                onTap: () {
                  context.push(EditProfileView.routeName);
                },
              ),
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Log Out',
                  icon: Icon(
                    Icons.logout_rounded,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(SignOutEvent());
                },
              ),
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Delete Account',
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(DeleteAccountEvent());
                },
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
