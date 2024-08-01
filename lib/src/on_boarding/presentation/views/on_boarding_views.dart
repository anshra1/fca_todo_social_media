import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/dialog/error_dialog.dart';
import 'package:flutter_learning_go_router/core/common/views/loading_view.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/import.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/entites/page_content.dart';
import 'package:flutter_learning_go_router/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:go_router/go_router.dart';

class OnBoardingViews extends HookWidget {
  const OnBoardingViews({super.key});

  static const routeName = '/onboarding-view';

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
        return null;
      },
      [],
    );

    return BlocConsumer<OnBoardingCubit, OnBoardingState>(
      listener: (context, state) {
        if (state is OnBoardingStatusState && !state.isFirstTimer) {
          context.go(PhoneNumberView.routeName);
        } else if (state is UserCachedState) {
          context.go(PhoneNumberView.routeName);
        } else if (state is OnBoardingErrorState) {
          ErrorDialog(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is CachingFirstTimerState &&
            state is CheckingIfUserIsFirstTimerState) {
          return const LoadingView();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  const PageContent.first().name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
                Image.network(const PageContent.first().image),
                ElevatedButton(
                  onPressed: () {
                    context.read<OnBoardingCubit>().cacheFirstTimer();
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
