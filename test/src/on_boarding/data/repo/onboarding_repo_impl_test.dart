import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/src/on_boarding/data/datasources/onboarding_local_data_src.dart';
import 'package:flutter_learning_go_router/src/on_boarding/data/repo/onboarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnboardingLocaDataSrc {}

void main() {
  late OnboardingLocaDataSrc onboardingLocaDataSrc;
  late OnboardingRepoImpl onboardingRepoImpl;

  setUp(
    () {
      onboardingLocaDataSrc = MockOnBoardingLocalDataSrc();
      onboardingRepoImpl = OnboardingRepoImpl(onboardingLocaDataSrc);
    },
  );

  const tCacheExpection = CacheException(message: 'message', statusCode: 404);

  group(
    'cacheFirstTimer',
    () {
      test(
        'should return Right(null) when call cacheFirstTimer',
        () async {
          when(() => onboardingLocaDataSrc.cacheFirstTimer())
              .thenAnswer((_) async => Future.value());

          final result = await onboardingRepoImpl.cacheFirstTimer();

          expect(result, const Right<dynamic, void>(null));

          verify(() => onboardingLocaDataSrc.cacheFirstTimer()).called(1);

          verifyNoMoreInteractions(onboardingLocaDataSrc);
        },
      );

      test(
        'shuld return Left(CacheExpection) when cacheFirstTimer call',
        () async {
          when(() => onboardingLocaDataSrc.cacheFirstTimer())
              .thenThrow(tCacheExpection);

          final result = await onboardingRepoImpl.cacheFirstTimer();

          expect(
            result,
            Left<Failure, dynamic>(CacheFailure.fromException(tCacheExpection)),
          );

          verify(() => onboardingLocaDataSrc.cacheFirstTimer()).called(1);

          verifyNoMoreInteractions(onboardingLocaDataSrc);
        },
      );
    },
  );

  group(
    'checkUserIsFirstTimer',
    () {
      test(
        'should return Right(true) when call checkIfUserIsFirstTimer',
        () async {
          when(() => onboardingLocaDataSrc.checkIfUserIsFirstTimer())
              .thenAnswer((_) async => false);

          final result = await onboardingRepoImpl.checkIfUserIsFirstTimer();

          expect(result, const Right<Object, bool>(false));

          verify(() => onboardingLocaDataSrc.checkIfUserIsFirstTimer())
              .called(1);
          verifyNoMoreInteractions(onboardingLocaDataSrc);
        },
      );

      test(
        'should throw Left(CacheFailure) when call checkIfUserIsFirstTimer',
        () async {
          when(() => onboardingLocaDataSrc.checkIfUserIsFirstTimer())
              .thenThrow(tCacheExpection);

          final result = await onboardingRepoImpl.checkIfUserIsFirstTimer();

          expect(
            result,
            Left<CacheFailure, bool>(
              CacheFailure.fromException(tCacheExpection),
            ),
          );

          verify(() => onboardingLocaDataSrc.checkIfUserIsFirstTimer())
              .called(1);

          verifyNoMoreInteractions(onboardingLocaDataSrc);
        },
      );
    },
  );
}
