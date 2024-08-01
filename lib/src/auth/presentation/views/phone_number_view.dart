part of '../import.dart';

class PhoneNumberView extends HookWidget {
  const PhoneNumberView({super.key});

  static const routeName = '/phone-number-view';

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final showingDialog = useValueNotifier<bool>(false);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (showingDialog.value == true) {
          context.pop();
          showingDialog.value = false;
        }

        if (state is AuthErrorState) {
          showingDialog.value = false;
          ErrorDialog(message: state.message).present(context);
        } else if (state is AuthLoadingState) {
          showingDialog.value = true;
          CoreUtils.showLoadingDialog(context);
        } else if (state is VerifyTheOtpState) {
          context.go(
            OtpVerifyView.routeName,
            extra: {
              Strings.verificationId: state.verificationId,
              Strings.phoneNumber: controller.text.trim(),
            },
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(75),
                      Text(
                        'Get Started With \nToDo List',
                        style: p25.thick,
                      ),
                      kGaps25,
                      const Text(
                        'Enter your mobile Number to login or signup',
                        style: p15,
                      ),
                      kGaps30,
                      IField(
                        controller: controller,
                        isPrefix: true,
                        onlyNumbers: true,
                        keyboardType: TextInputType.datetime,
                        maxLength: 10,
                        prefixWidget: Text(
                          '+91',
                          style: p17.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (
                        BuildContext context,
                        TextEditingValue value,
                        Widget? child,
                      ) {
                        return RoundedButton(
                          label: 'Continue',
                          onPressed: controller.text.length == 10
                              ? () {
                                  context.read<AuthBloc>().add(
                                        VerifyThePhoneNumberEvent(
                                          phoneNumber: controller.text.trim(),
                                        ),
                                      );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
