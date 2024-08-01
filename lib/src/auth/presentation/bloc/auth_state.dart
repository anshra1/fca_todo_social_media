part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthErrorState extends AuthState {
  const AuthErrorState({
    required this.message,
  });

  final String message;
}

class AuthSuccessState extends AuthState {
  const AuthSuccessState({required this.userExist});

  final bool userExist;
}

class VerifyTheOtpState extends AuthState {
  const VerifyTheOtpState({required this.verificationId});
  final String verificationId;
}

class ResendOtpSendingState extends AuthState {
  const ResendOtpSendingState();
}

class ResendOtpSucessState extends AuthState {
  const ResendOtpSucessState();
}

class VerifyThePhoneNumberState extends AuthState {
  const VerifyThePhoneNumberState();
}

class SignOutSucessState extends AuthState {
  const SignOutSucessState();
}

class DeleteAccountState extends AuthState {
  const DeleteAccountState();
}

class RegisterTheUserState extends AuthState {
  const RegisterTheUserState();
}

class RegisterTheUserSucessState extends AuthState {
  const RegisterTheUserSucessState();
}

class UpdateUserSucessState extends AuthState {
  const UpdateUserSucessState();
}
