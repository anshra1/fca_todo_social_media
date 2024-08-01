import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/repo/on_boarding_repo.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingRepo extends Mock implements OnBoardingRepo {}

void main() {
  late OnBoardingRepo onBoardingRepo;
  late CacheFirstTimer cacheFirstTimer;

  setUp(
    () {
      onBoardingRepo = MockOnBoardingRepo();
      cacheFirstTimer = CacheFirstTimer(repo: onBoardingRepo);
    },
  );
  group(
    'cacheFirstTimer',
    () {
      test(
        'should call cacheFirstTime and return void',
        () async {
          when(() => onBoardingRepo.cacheFirstTimer())
              .thenAnswer((_) async => right(null));

          final result = await cacheFirstTimer.call();

          expect(result, const Right<dynamic, void>(null));

          verify(() => onBoardingRepo.cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(onBoardingRepo);
        },
      );
    },
  );
}
