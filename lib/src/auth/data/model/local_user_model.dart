import 'package:flutter_learning_go_router/core/enum/gender.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.name,
    required super.fatherName,
    required super.gender,
    required super.dateOfBirth,
    required super.photoURL,
    required super.mobileNumber,
    required super.libraryCode,
    required super.uid,
  });

  factory LocalUserModel.empty() => LocalUserModel(
        name: 'Empty',
        fatherName: '',
        gender: Gender.Male.value,
        dateOfBirth: '',
        photoURL: '',
        mobileNumber: '',
        libraryCode: 0,
        uid: '',
      );

  factory LocalUserModel.fromMap(Map<String, dynamic> map) {
    return LocalUserModel(
      name: (map[Strings.name] ?? '') as String,
      fatherName: (map[Strings.fatherName] ?? '') as String,
      gender: (map[Strings.gender] ?? '') as String,
      dateOfBirth: (map[Strings.dateOfBirth] ?? '') as String,
      photoURL: (map[Strings.photoURl] ?? '') as String,
      mobileNumber: (map[Strings.mobileNumber] ?? '') as String,
      libraryCode: (map[Strings.libraryCode] ?? 0) as int,
      uid: (map[Strings.uid] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Strings.name: name,
      Strings.fatherName: fatherName,
      Strings.gender: gender,
      Strings.dateOfBirth: dateOfBirth,
      Strings.photoURl: photoURL,
      Strings.mobileNumber: mobileNumber,
      Strings.libraryCode: libraryCode,
      Strings.uid: uid,
    };
  }

  LocalUserModel copyWith({
    String? name,
    String? fatherName,
    String? gender,
    String? dateOfBirth,
    String? photoURL,
    String? mobileNumber,
    int? libraryCode,
    String? uid,
  }) {
    return LocalUserModel(
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      photoURL: photoURL ?? this.photoURL,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      libraryCode: libraryCode ?? this.libraryCode,
      uid: uid ?? this.uid,
    );
  }
}
