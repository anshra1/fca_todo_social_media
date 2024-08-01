import 'package:dartz/dartz.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/repo/on_boarding_repo.dart';
import 'package:flutter_learning_go_router/src/on_boarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingRepo extends Mock implements OnBoardingRepo {}

void main() {
  late OnBoardingRepo onBoardingRepo;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  setUp(
    () {
      onBoardingRepo = MockOnBoardingRepo();
      checkIfUserIsFirstTimer = CheckIfUserIsFirstTimer(repo: onBoardingRepo);
    },
  );

  group(
    '',
    () {
      test(
        '',
        () async {
          //when(()=> ).thenAnswer((_) async => );
        },
      );
    },
  );
  group(
    'CheckIfUserIsFirstTimer',
    () {
      test(
        'should call checkIfuserIsFirstTimer and return true ',
        () async {
          when(() => onBoardingRepo.checkIfUserIsFirstTimer())
              .thenAnswer((_) async => const Right(true));

          // act
          final result = await checkIfUserIsFirstTimer.call();

          expect(result, const Right<dynamic, bool>(true));

          verify(() => onBoardingRepo.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(onBoardingRepo);
        },
      );
    },
  );
}
