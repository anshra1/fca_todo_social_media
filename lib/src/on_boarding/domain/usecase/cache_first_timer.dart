import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/repo/on_boarding_repo.dart';

class CacheFirstTimer extends FutureUseCaseWithoutParams<void> {
  CacheFirstTimer({required OnBoardingRepo repo}) : _repo = repo;
  final OnBoardingRepo _repo;

  @override
  ResultFuture<void> call() => _repo.cacheFirstTimer();
}
