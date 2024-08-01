import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/on_boarding/data/datasources/onboarding_local_data_src.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/repo/on_boarding_repo.dart';

class OnboardingRepoImpl implements OnBoardingRepo {
  OnboardingRepoImpl(this.localDataSrc);

  final OnboardingLocaDataSrc localDataSrc;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await localDataSrc.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(
        CacheFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final firstTimer = await localDataSrc.checkIfUserIsFirstTimer();
      return Right(firstTimer);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }
}
