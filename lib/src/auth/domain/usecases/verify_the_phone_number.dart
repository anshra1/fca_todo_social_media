import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class VerifyThePhoneNumber extends FutureUseCaseWithParams<void, String> {
  VerifyThePhoneNumber({required this.authRepo});

  final AuthRepo authRepo;

  @override
  ResultFuture<String> call(String params) {
    return authRepo.verifyThePhoneNumber(phoneNumber: params);
  }
}
