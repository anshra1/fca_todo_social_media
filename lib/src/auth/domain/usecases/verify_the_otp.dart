import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class VerifyTheOtp extends FutureUseCaseWithParams<bool, VerifyTheOtpParams> {
  VerifyTheOtp({
    required this.authRepo,
  });

  final AuthRepo authRepo;

  @override
  ResultFuture<bool> call(VerifyTheOtpParams params) {
    return authRepo.verifyTheOtp(
      verificationID: params.verificationID,
      smsCode: params.smsCode,
    );
  }
}

class VerifyTheOtpParams {
  VerifyTheOtpParams({
    required this.verificationID,
    required this.smsCode,
  });
  final String verificationID;
  final String smsCode;
}
