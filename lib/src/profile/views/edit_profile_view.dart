import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/dialog/alert_dialog_model.dart';
import 'package:flutter_learning_go_router/core/common/dialog/error_dialog.dart';
import 'package:flutter_learning_go_router/core/common/loading/loading_screen.dart';
import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_learning_go_router/src/profile/widgets/edit_form_field.dart';
import 'package:flutter_learning_go_router/src/profile/widgets/user_pick_profile_pic.dart';
import 'package:go_router/go_router.dart';

class EditProfileView extends HookWidget {
  const EditProfileView({super.key});

  static const routeName = '/edit-profile-view';

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser!;
    final fullNameController = useTextEditingController(text: user.name);

    final fatherNameController =
        useTextEditingController(text: user.fatherName);

    final genderController = useTextEditingController(text: user.gender);

    final dateOfBirthController =
        useTextEditingController(text: user.dateOfBirth);

    final profileValueNotifier = useValueNotifier<File?>(null);

    bool nothingChanged() =>
        user.name.trim() == fullNameController.text.trim() &&
        user.fatherName.trim() == fatherNameController.text.trim() &&
        user.gender.trim() == genderController.text.trim() &&
        user.dateOfBirth.trim() == dateOfBirthController.text.trim() &&
        profileValueNotifier.value == null;

    final nothing = useValueNotifier(nothingChanged());

    useEffect(
      () {
        fullNameController.addListener(() => nothing.value = nothingChanged());

        fatherNameController
            .addListener(() => nothing.value = nothingChanged());

        genderController.addListener(() => nothing.value = nothingChanged());

        dateOfBirthController
            .addListener(() => nothing.value = nothingChanged());

        profileValueNotifier
            .addListener(() => nothing.value = nothingChanged());

        return null;
      },
      [],
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          LoadingScreen.instance().hide();
          ErrorDialog(message: state.message).present(context);
        } else if (state is AuthLoadingState) {
          LoadingScreen.instance().show(context: context);
        } else if (state is UpdateUserSucessState) {
          LoadingScreen.instance().hide();
          CoreUtils.showSnackBar(context, 'User Profile Updated Successfully');
          context.pop();
        } else {
          LoadingScreen.instance().hide();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Edit Profile'),
          centerTitle: false,
          actions: [
            ValueListenableBuilder(
              valueListenable: nothing,
              builder: (BuildContext context, b, Widget? child) {
                return TextButton(
                  child: Text(
                    'Done',
                    style: p16.bold.copyWith(
                      color: nothing.value ? Colors.grey : Colors.blue.shade600,
                    ),
                  ),
                  onPressed: () {
                    if (nothingChanged()) {
                      context.pop();
                    }

                    final bloc = context.read<AuthBloc>();

                    if (user.name.trim() != fullNameController.text.trim()) {
                      bloc.add(
                        UpdateUserEvent(
                          userData: fullNameController.text.trim(),
                          action: UpdateUserAction.displyName,
                        ),
                      );
                    }

                    if (user.fatherName.trim() !=
                        fatherNameController.text.trim()) {
                      bloc.add(
                        UpdateUserEvent(
                          userData: fatherNameController.text.trim(),
                          action: UpdateUserAction.fatherName,
                        ),
                      );
                    }

                    if (user.gender.trim() != genderController.text.trim()) {
                      bloc.add(
                        UpdateUserEvent(
                          userData: genderController.text.trim(),
                          action: UpdateUserAction.dateOfBirth,
                        ),
                      );
                    }

                    if (user.dateOfBirth.trim() !=
                        dateOfBirthController.text.trim()) {
                      bloc.add(
                        UpdateUserEvent(
                          userData: dateOfBirthController.text.trim(),
                          action: UpdateUserAction.gender,
                        ),
                      );
                    }

                    if (profileValueNotifier.value != null) {
                      bloc.add(
                        UpdateUserEvent(
                          userData: profileValueNotifier.value,
                          action: UpdateUserAction.profilePic,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              UserProfilePicImage(pickedImageTo: profileValueNotifier),
              kGaps50,
              EditFormField(
                fullNameController: fullNameController,
                fatherNameController: fatherNameController,
                genderController: genderController,
                dateOfBirthController: dateOfBirthController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
