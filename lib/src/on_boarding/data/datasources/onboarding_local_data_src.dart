import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocaDataSrc {
  const OnboardingLocaDataSrc();

  Future<bool> checkIfUserIsFirstTimer();
  Future<void> cacheFirstTimer();
}

const String kFirstTimer = 'kFirstTimer';

class OnBoardingLocalDataSrcImpl implements OnboardingLocaDataSrc {
  const OnBoardingLocalDataSrcImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await prefs.setBool(kFirstTimer, false);
    } catch (e) {
      throw const CacheException(
        message: 'Cache Exception',
        statusCode: 501,
      );
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      return prefs.getBool(kFirstTimer) ?? true;
    } catch (e) {
      throw const CacheException(
        message: 'CheckIfUserIsFirstTimer Exception',
        statusCode: 501,
      );
    }
  }
}
