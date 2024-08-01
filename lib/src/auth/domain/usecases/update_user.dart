import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class UpdateUser extends FutureUseCaseWithParams<void, UpdateUserParams> {
  UpdateUser({required this.authRepo});

  final AuthRepo authRepo;

  @override
  ResultFuture<void> call(UpdateUserParams params) {
    return authRepo.updateUser(
      action: params.action,
      userData: params.userData,
    );
  }
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userData});

  const UpdateUserParams.empty()
      : this(action: UpdateUserAction.displyName, userData: '');

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<dynamic> get props => [action, userData];
}
