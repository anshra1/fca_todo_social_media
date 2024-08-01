import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/cache_first_timer.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/check_if_user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer,
    required CacheFirstTimer cacheFirstTimer,
  })  : _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        _cacheFirstTimer = cacheFirstTimer,
        super(const OnBoardingInitialState());

  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;
  final CacheFirstTimer _cacheFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimerState());

    final result = await _cacheFirstTimer();

    result.fold(
      (failure) {
        emit(OnBoardingErrorState(message: failure.message));
      },
      (_) {
        emit(const UserCachedState());
      },
    );
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimerState());

    final result = await _checkIfUserIsFirstTimer();

    result.fold(
      (failure) {
        emit(OnBoardingErrorState(message: failure.message));
      },
      (status) {
        emit(OnBoardingStatusState(isFirstTimer: status));
      },
    );
  }
}
