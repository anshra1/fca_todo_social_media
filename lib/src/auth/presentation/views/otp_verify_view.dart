part of '../import.dart';

class OtpVerifyView extends StatefulWidget {
  const OtpVerifyView({
    required this.verificationID,
    required this.phoneNumber,
    super.key,
  });

  final String? verificationID;
  final String? phoneNumber;

  static const routeName = '/otp-verify-view';

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  final secondsRemaining = ValueNotifier<int>(30);
  final formKey = GlobalKey<FormState>();
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        setState(() {});
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    context.read<AuthBloc>().add(
          ResendOtpEvent(phoneNumber: widget.phoneNumber!),
        );
    secondsRemaining.value = 30;
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    secondsRemaining.dispose();
    super.dispose();
  }

  bool showingDialog = false;

  @override
  Widget build(BuildContext context) {
// 1 read command Dash useustate vs useValueNotifier
// 2 write about useValueNotifier
// 3 useValueListenable(valueListenable)
// 4 write about useState

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (showingDialog == true) {
          context.pop();
          showingDialog = false;
        }

        if (state is AuthLoadingState) {
          showingDialog = true;
          CoreUtils.showLoadingDialog(context);
        }

        if (state is AuthErrorState) {
          showingDialog = false;
          ErrorDialog(message: state.message);
        } else if (state is AuthSuccessState) {
          showingDialog = true;
          if (state.userExist) {
            context.go(HomeClass.routeName);
          } else {
            context.go(RegisterTheUserView.routeName);
          }
        } else if (state is ResendOtpSucessState) {
          CoreUtils.showSnackBar(context, 'Resend Otp is sucessful');
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: GestureDetector(
                onTap: () => context.go(PhoneNumberView.routeName),
                child: const Icon(Icons.arrow_back),
              ),
              title: Text(
                'Verify',
                style: p18.bold,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter the otp we've sent to",
                        style: p16.medium,
                      ),
                      kGaps10,
                      Row(
                        children: [
                          Text(
                            widget.phoneNumber ?? '1234567890',
                            style: p18.bold,
                          ),
                          kGaps10,
                          const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          kGaps10,
                          RichLinkText(
                            label: 'Edit',
                            onPressed: () => context.go(
                              PhoneNumberView.routeName,
                            ),
                          ),
                        ],
                      ),
                      kGaps30,
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: context.theme.primaryColor,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          context.read<AuthBloc>().add(
                                VerifyTheOtpEvent(
                                  verificationID: widget.verificationID ?? '',
                                  otp: verificationCode,
                                ),
                              );
                        },
                      ),
                      kGaps35,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Didn't receive the code?",
                            style: p16.copyWith(color: Colors.black87),
                          ),
                          kGaps20,
                          if (state is ResendOtpSendingState)
                            const Baseline(
                              baseline: 15,
                              baselineType: TextBaseline.alphabetic,
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else ...[
                            if (secondsRemaining.value == 0)
                              RichLinkText(
                                label: 'Resend Otp',
                                onPressed: () {
                                  resendOtp();
                                  setState(() {});
                                },
                              )
                            else
                              ListenableBuilder(
                                listenable: secondsRemaining,
                                builder: (context, widget) {
                                  return Text(
                                    '00:${secondsRemaining.value.timer}',
                                    style: p16.copyWith(color: Colors.black87),
                                  );
                                },
                              ),
                          ],
                        ],
                      ),
                    ],
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
