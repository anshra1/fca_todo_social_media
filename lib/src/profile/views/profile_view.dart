import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/dialog/error_dialog.dart';
import 'package:flutter_learning_go_router/core/common/loading/loading_screen.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/import.dart';
import 'package:flutter_learning_go_router/src/profile/custom_hook/stream_custom_hook.dart';
import 'package:flutter_learning_go_router/src/profile/widgets/profile_app_bar.dart';
import 'package:flutter_learning_go_router/src/profile/widgets/user_view_widget.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulHookWidget {
  const ProfileView({super.key});

  static const routeName = '/profile-view';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    use(UserDataHook());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          LoadingScreen.instance().show(context: context);
        }

        if (state is AuthErrorState) {
          LoadingScreen.instance().hide();
          ErrorDialog(message: state.message);
        } else if (state is SignOutSucessState || state is DeleteAccountState) {
          LoadingScreen.instance().hide();
          context.go(PhoneNumberView.routeName);
        }
      },
      builder: (context, state) {
        return const SafeArea(
          child: Scaffold(
            appBar: ProfileAppBar(),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
