import 'dart:io';

import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<String> verifyThePhoneNumber({
    required String phoneNumber,
  });

  ResultFuture<bool> verifyTheOtp({
    required String verificationID,
    required String smsCode,
  });

  ResultFuture<void> resendOtp({
    required String phoneNumber,
  });

  ResultFuture<void> registerTheUser({
    required String name,
    required String fatherName,
    required String gender,
    required String dateOfBirth,
    required File profilePic,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  ResultFuture<void> deleteAccount();

  ResultFuture<void> signOut();
}
