part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

final class OnBoardingInitialState extends OnBoardingState {
  const OnBoardingInitialState();
}

class CachingFirstTimerState extends OnBoardingState {
  const CachingFirstTimerState();
}

class UserCachedState extends OnBoardingState {
  const UserCachedState();
}

class CheckingIfUserIsFirstTimerState extends OnBoardingState {
  const CheckingIfUserIsFirstTimerState();
}

class OnBoardingStatusState extends OnBoardingState {
  const OnBoardingStatusState({
    required this.isFirstTimer,
  });

  final bool isFirstTimer;

  @override
  List<bool> get props => [isFirstTimer];
}

class OnBoardingErrorState extends OnBoardingState {
  const OnBoardingErrorState({required this.message});

  final String message;

  @override
  List<String> get props => [message];
}
