import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/delete_account.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/register_the_user.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/resend_otp.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/sign_out.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/verify_the_otp.dart';
import 'package:flutter_learning_go_router/src/auth/domain/usecases/verify_the_phone_number.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignOut signOut,
    required DeleteAccount deleteAccount,
    required UpdateUser updateUser,
    required VerifyThePhoneNumber verifyThePhoneNumber,
    required VerifyTheOtp verifyTheOtp,
    required ResendOtp resendOtp,
    required RegisterTheUser registerTheUser,
  })  : _verifyThePhoneNumber = verifyThePhoneNumber,
        _verifyTheOtp = verifyTheOtp,
        _registerTheUser = registerTheUser,
        _deleteAccount = deleteAccount,
        _signOut = signOut,
        _updateUser = updateUser,
        _resendOtp = resendOtp,
        super(const AuthInitialState()) {
    on<AuthEvent>((event, emit) {
      // emit(const AuthLoadingState());
    });

    on<VerifyThePhoneNumberEvent>(_verifyThePhoneNumberHandler);
    on<VerifyTheOtpEvent>(_verifyTheOtpHandler);
    on<SignOutEvent>(_signOutHandler);
    on<DeleteAccountEvent>(_deleteAccountHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<ResendOtpEvent>(_resendOtpHandler);
    on<RegisterTheUserEvent>(_registerTheUserHandler);
  }

  final VerifyThePhoneNumber _verifyThePhoneNumber;
  final VerifyTheOtp _verifyTheOtp;
  final SignOut _signOut;
  final DeleteAccount _deleteAccount;
  final UpdateUser _updateUser;
  final ResendOtp _resendOtp;
  final RegisterTheUser _registerTheUser;

  Future<void> _registerTheUserHandler(
    RegisterTheUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _registerTheUser(
      RegisterTheUserParams(
        event.name,
        event.fatherName,
        event.gender,
        event.dateOfBirth,
        event.profilePic,
      ),
    );

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (_) => emit(const RegisterTheUserSucessState()),
    );
  }

  Future<void> _verifyThePhoneNumberHandler(
    VerifyThePhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await _verifyThePhoneNumber(event.phoneNumber);

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (id) => emit(VerifyTheOtpState(verificationId: id)),
    );
  }

  Future<void> _verifyTheOtpHandler(
    VerifyTheOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await _verifyTheOtp(
      VerifyTheOtpParams(
        verificationID: event.verificationID,
        smsCode: event.otp,
      ),
    );

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (userExist) => emit(AuthSuccessState(userExist: userExist)),
    );
  }

  Future<void> _resendOtpHandler(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const ResendOtpSendingState());
    final result = await _resendOtp(event.phoneNumber);

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (_) => emit(const ResendOtpSucessState()),
    );
  }

  Future<void> _signOutHandler(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await _signOut();

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (_) => emit(const SignOutSucessState()),
    );
  }

  Future<void> _deleteAccountHandler(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await _deleteAccount();

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (_) => emit(const DeleteAccountState()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (error) => emit(AuthErrorState(message: error.errorMessage)),
      (_) => emit(const UpdateUserSucessState()),
    );
  }
}
