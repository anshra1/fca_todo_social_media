import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class SignOut extends FutureUseCaseWithoutParams<void> {
  SignOut({
    required this.authRepo,
  });

  final AuthRepo authRepo;

  @override
  ResultFuture<void> call() {
    return authRepo.signOut();
  }
}
