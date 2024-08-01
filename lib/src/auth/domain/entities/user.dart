import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/core/enum/gender.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.name,
    required this.fatherName,
    required this.gender,
    required this.dateOfBirth,
    required this.photoURL,
    required this.mobileNumber,
    required this.libraryCode,
    required this.uid,
  });

  factory LocalUser.empty() => LocalUser(
        name: '',
        fatherName: '',
        gender: Gender.Male.value,
        dateOfBirth: '',
        photoURL: '',
        mobileNumber: '',
        libraryCode: 0,
        uid: '',
      );

  final String uid;
  final String name;
  final String fatherName;
  final String gender;
  final String dateOfBirth;
  final String photoURL;
  final String mobileNumber;
  final int libraryCode;

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'User(name: $name, fatherName: $fatherName, gender: $gender, dateOfBirth: $dateOfBirth, photoURL: $photoURL, mobileNumber: $mobileNumber, libraryCode: $libraryCode)';

  @override
  List<Object?> get props => [
        name,
        fatherName,
        gender,
        dateOfBirth,
        photoURL,
        mobileNumber,
        libraryCode,
      ];
}
