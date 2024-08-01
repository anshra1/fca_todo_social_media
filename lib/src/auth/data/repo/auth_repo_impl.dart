import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/error/failure.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_learning_go_router/src/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  AuthRepoImpl({
    required this.authRemoteDataSource,
  });

  final AuthRemoteDataSource authRemoteDataSource;

  @override
  ResultFuture<bool> verifyTheOtp({
    required String verificationID,
    required String smsCode,
  }) async {
    try {
      final result = await authRemoteDataSource.verifyTheOtp(
        verificationID: verificationID,
        smsCode: smsCode,
      );
      return Right(result);
    } on ServerException catch (e) {
      debugPrint('verifty the otp exception is thrown');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<String> verifyThePhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      final s = await authRemoteDataSource.verifyThePhoneNumber(
        phoneNumber: phoneNumber,
      );

      return Right(s);
    } on ServerException catch (e) {
      debugPrint('verify the phone exception is thrown');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<void> deleteAccount() async {
    try {
      await authRemoteDataSource.deleteAccount();
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('verifty the otp exception is thrown');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<void> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('verifty the otp exception is thrown');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await authRemoteDataSource.updateUser(action: action, userData: userData);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('update the user Error');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<void> resendOtp({required String phoneNumber}) async {
    try {
      await authRemoteDataSource.verifyThePhoneNumber(
        phoneNumber: phoneNumber,
      );
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('verifty the otp exception is thrown');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<void> registerTheUser({
    required String name,
    required String fatherName,
    required String gender,
    required String dateOfBirth,
    required File profilePic,
  }) async {
    try {
      await authRemoteDataSource.registerTheUser(
        name: name,
        fatherName: fatherName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        profilePic: profilePic,
      );
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('register the user problem');
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }
}
