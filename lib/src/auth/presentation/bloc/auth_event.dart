part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class VerifyThePhoneNumberEvent extends AuthEvent {
  const VerifyThePhoneNumberEvent({required this.phoneNumber});
  final String phoneNumber;
}

class VerifyTheOtpEvent extends AuthEvent {
  const VerifyTheOtpEvent({
    required this.verificationID,
    required this.otp,
  });

  final String verificationID;
  final String otp;
}

class ResendOtpEvent extends AuthEvent {
  const ResendOtpEvent({
    required this.phoneNumber,
  });

  final String phoneNumber;
}

class SignOutEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  const UpdateUserEvent({
    required this.userData,
    required this.action,
  });
  final dynamic userData;
  final UpdateUserAction action;
}

class RegisterTheUserEvent extends AuthEvent {
  const RegisterTheUserEvent({
    required this.name,
    required this.fatherName,
    required this.gender,
    required this.dateOfBirth,
    required this.profilePic,
  });

  final String name;
  final String fatherName;
  final String gender;
  final String dateOfBirth;
  final File profilePic;
}
