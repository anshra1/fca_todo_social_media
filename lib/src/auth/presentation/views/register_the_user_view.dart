part of '../import.dart';

class RegisterTheUserView extends HookWidget {
  const RegisterTheUserView({super.key});

  static const routeName = '/register-the-user';

  @override
  Widget build(BuildContext context) {
    final pickedImageFile = useValueNotifier<File?>(null);
    final name = useTextEditingController();
    final fatherName = useTextEditingController();
    final gender = useValueNotifier<Gender>(Gender.None);
    final dateOfBirth = useValueNotifier<String?>(null);
    final fatherNameFocusNode = useFocusNode();

    bool isButtonEnabled() =>
        pickedImageFile.value != null &&
        name.text.trim().isNotEmpty &&
        fatherName.text.trim().isNotEmpty &&
        dateOfBirth.value != null &&
        gender.value != Gender.None;

    final buttonState = useValueNotifier(isButtonEnabled());

    useEffect(
      () {
        pickedImageFile.addListener(() {
          buttonState.value = isButtonEnabled();
        });

        name.addListener(() {
          buttonState.value = isButtonEnabled();
        });

        fatherName.addListener(() {
          buttonState.value = isButtonEnabled();
        });

        gender.addListener(() {});

        dateOfBirth.addListener(() {
          buttonState.value = isButtonEnabled();
        });

        final listener =
            InternetConnectionUtils.startListeningInternetStatus(context);

        return () {
          pickedImageFile.removeListener(() {});
          name.removeListener(() {});
          fatherName.removeListener(() {});
          gender.removeListener(() {});
          listener.$1.cancel();
        };
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
        } else if (state is RegisterTheUserSucessState) {
          LoadingScreen.instance().hide();
          context.go(HomeClass.routeName);
        } else {
          LoadingScreen.instance().hide();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register The User'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              kGaps15,
              UserImage(pickedImageFile: pickedImageFile),
              kGaps20,
              EditTitleTextField(
                controller: name,
                titleText: 'Full Name',
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(fatherNameFocusNode);
                },
              ),
              kGaps20,
              EditTitleTextField(
                controller: fatherName,
                titleText: "Father's Name",
                focusNode: fatherNameFocusNode,
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              kGaps20,
              GenderButton(gender: gender),
              kGaps30,
              DateOfBirth(
                dateOfBirth: dateOfBirth,
              ),
              kGaps20,
              ListenableBuilder(
                listenable: buttonState,
                builder: (context, widget) {
                  return RoundedButton(
                    label: 'Summit',
                    onPressed: buttonState.value
                        ? () async {
                            LoadingScreen.instance().show(context: context);
                            FocusManager.instance.primaryFocus?.unfocus();

                            final haveInternet =
                                await InternetConnection().hasInternetAccess;

                            if (haveInternet &&
                                pickedImageFile.value != null &&
                                dateOfBirth.value != null) {
                              // ignore: use_build_context_synchronously
                              context.read<AuthBloc>().add(
                                    RegisterTheUserEvent(
                                      name: name.text.trim(),
                                      fatherName: fatherName.text.trim(),
                                      gender: gender.value.value,
                                      dateOfBirth: dateOfBirth.value!,
                                      profilePic: pickedImageFile.value!,
                                    ),
                                  );
                            } else {
                              LoadingScreen.instance().hide();
                            }
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
