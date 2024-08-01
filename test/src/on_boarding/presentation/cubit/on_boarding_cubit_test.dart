import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/cache_first_timer.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:flutter_learning_go_router/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late OnBoardingCubit cubit;
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  setUp(
    () {
      cacheFirstTimer = MockCacheFirstTimer();
      checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
      cubit = OnBoardingCubit(
        checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
        cacheFirstTimer: cacheFirstTimer,
      );
    },
  );

  group(
    'cacheFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [cachingFirstTimerState,UserCached] when sucess',
        build: () {
          when(() => cacheFirstTimer())
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (bloc) => cubit.cacheFirstTimer(),
        expect: () => const <OnBoardingState>[
          CachingFirstTimerState(),
          UserCachedState(),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        // ignore: lines_longer_than_80_chars
        'should emit [CachingFirstTimerState,OnBoardingErrorState] when unsucess',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
            (_) async => const Left<Failure, dynamic>(
              CacheFailure(message: 'message', statusCode: 505),
            ),
          );
          return cubit;
        },
        act: (bloc) => cubit.cacheFirstTimer(),
        expect: () => const <OnBoardingState>[
          CachingFirstTimerState(),
          OnBoardingErrorState(message: 'message'),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    },
  );

  group(
    'CheckIfUserIsFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CheckingIfUserIsFirstTimerState,OnBoardingStatusState]',
        build: () {
          when(() => checkIfUserIsFirstTimer())
              .thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (bloc) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const <OnBoardingState>[
          CheckingIfUserIsFirstTimerState(),
          OnBoardingStatusState(isFirstTimer: false),
        ],
        verify: (_) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        // ignore: lines_longer_than_80_chars
        'should emit [CheckingIfUserIsFirstTimerState , Error state] when unsucess',
        build: () {
          when(() => checkIfUserIsFirstTimer()).thenAnswer(
            (_) async => const Left(CacheFailure(message: '', statusCode: 505)),
          );
          return cubit;
        },
        act: (bloc) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const <OnBoardingState>[
          CheckingIfUserIsFirstTimerState(),
          OnBoardingErrorState(message: ''),
        ],
        verify: (_) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );
    },
  );
}
