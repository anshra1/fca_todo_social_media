import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/src/on_boarding/data/datasources/onboarding_local_data_src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late OnBoardingLocalDataSrcImpl onBoardingLocalDataSrcImpl;
  late SharedPreferences prefs;

  setUp(
    () async {
      prefs = MockSharedPreferences();
      onBoardingLocalDataSrcImpl = OnBoardingLocalDataSrcImpl(prefs);
    },
  );
  group(
    'cacheFirstTimer',
    () {
      test(
        'when cacheFirstTimer call is sucessfully complete',
        () async {
          when(() => prefs.setBool(kFirstTimer, false))
              .thenAnswer((_) async => true);

          await onBoardingLocalDataSrcImpl.cacheFirstTimer();
          verify(() => prefs.setBool(kFirstTimer, false)).called(1);

          verifyNoMoreInteractions(prefs);
        },
      );

      test(
        'should throw a cache expection when there is error in storage',
        () async {
          when(() => prefs.setBool(kFirstTimer, false)).thenThrow(Exception());

          final result = onBoardingLocalDataSrcImpl.cacheFirstTimer;

          expect(result(), throwsA(isA<CacheException>()));

          verify(() => prefs.setBool(kFirstTimer, false)).called(1);

          verifyNoMoreInteractions(prefs);
        },
      );
    },
  );
  group(
    'checkIfUserIsFirstTimer',
    () {
      test(
        'should return false when checkIfUserIsFirstTimer call',
        () async {
          // arrange
          when(() => prefs.getBool(kFirstTimer)).thenReturn(false);

          // act
          final result =
              await onBoardingLocalDataSrcImpl.checkIfUserIsFirstTimer();

          // expect
          expect(result, false);
          verify(() => onBoardingLocalDataSrcImpl.checkIfUserIsFirstTimer())
              .called(1);
        },
      );

      test(
        // ignore: lines_longer_than_80_chars
        'should return true when checkIfUserIsFirstTimer is false when data is not availble',
        () async {
          when(() => prefs.getBool(kFirstTimer)).thenReturn(null);

          final result =
              await onBoardingLocalDataSrcImpl.checkIfUserIsFirstTimer();

          expect(result, true);

          verify(() => onBoardingLocalDataSrcImpl.checkIfUserIsFirstTimer())
              .called(1);

          verifyNoMoreInteractions(prefs);
        },
      );
    },
  );
}
