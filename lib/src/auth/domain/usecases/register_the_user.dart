import 'dart:io';
import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class RegisterTheUser
    extends FutureUseCaseWithParams<void, RegisterTheUserParams> {
  RegisterTheUser({required this.authRepo});

  final AuthRepo authRepo;

  @override
  ResultFuture<void> call(RegisterTheUserParams params) {
    return authRepo.registerTheUser(
      name: params.name,
      fatherName: params.fatherName,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      profilePic: params.profilePic,
    );
  }
}

class RegisterTheUserParams {
  RegisterTheUserParams(
    this.name,
    this.fatherName,
    this.gender,
    this.dateOfBirth,
    this.profilePic,
  );
  String name;
  String fatherName;
  String gender;
  String dateOfBirth;
  File profilePic;
}
