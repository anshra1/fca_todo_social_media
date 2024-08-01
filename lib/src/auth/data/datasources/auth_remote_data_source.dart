import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_learning_go_router/core/enum/update_user_action.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';
import 'package:flutter_learning_go_router/core/hive/common.dart';
import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
import 'package:flutter_learning_go_router/core/services/import.dart';
import 'package:flutter_learning_go_router/core/strings/firebase_strings.dart';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/core/utils/autrorize_user_utils.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/auth/data/model/local_user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<String> verifyThePhoneNumber({
    required String phoneNumber,
  });

  Future<bool> verifyTheOtp({
    required String verificationID,
    required String smsCode,
  });

  Future<void> registerTheUser({
    required String name,
    required String fatherName,
    required String gender,
    required String dateOfBirth,
    required File profilePic,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  Future<void> deleteAccount();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore firestoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _firestoreClient = firestoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _firestoreClient;
  // ignore: unused_field
  final FirebaseStorage _dbClient;

  @override
  Future<String> verifyThePhoneNumber({
    required String phoneNumber,
  }) async {
    final completer = Completer<String>();
    try {
      await _authClient.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',

        timeout: const Duration(seconds: 35),

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authClient.signInWithCredential(credential);
        },
        //
        codeSent: (String verificationId, int? forceResendingToken) async {
          completer.complete(verificationId);
        },
        //
        verificationFailed: (FirebaseAuthException e) async {
          completer.completeError(e);
        },
        //
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return await completer.future;
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<bool> verifyTheOtp({
    required String verificationID,
    required String smsCode,
  }) async {
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: smsCode,
    );

    try {
      await _authClient.signInWithCredential(credentials);

      final userExist = await _firestoreClient
          .collection(FirebaseStrings.users)
          .doc(sl<FirebaseAuth>().currentUser?.uid)
          .get();

      if (userExist.exists) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> registerTheUser({
    required String name,
    required String fatherName,
    required String gender,
    required String dateOfBirth,
    required File profilePic,
  }) async {
    try {
      await AutorizeUserUtils.authorizeUser(_authClient);

      final user = _authClient.currentUser;

      if (user != null) {
        // get total document

        final aggregateQuerySnapshot = await _firestoreClient
            .collection(FirebaseStrings.users)
            .count()
            .get();

        final totalDocument = aggregateQuerySnapshot.count!;

        // storage

        final ref = _dbClient
            .ref()
            .child('profilePics/${_authClient.currentUser?.uid}');

        await ref.putFile(profilePic);
        final url = await ref.getDownloadURL();

        // auth data update

        await _authClient.currentUser?.updatePhotoURL(url);
        await _authClient.currentUser?.updateDisplayName(name);

        // check previous user data

        final userData = await _firestoreClient
            .collection(FirebaseStrings.users)
            .doc(user.uid)
            .get();

        if (userData.exists) return;

        await _setUserData(
          uid: user.uid,
          name: name,
          fatherName: fatherName,
          gender: gender,
          dateOfBirth: dateOfBirth,
          mobileNumber: user.phoneNumber.toString(),
          libraryCode: 1000 + totalDocument,
          photoURL: url,
        );

        await HiveBox.commonBox.put(Strings.uid, Common(user.uid));
        await HiveBox.commonBox.put(Strings.userName, Common(name));
        await HiveBox.commonBox.put(Strings.photoURl, Common(url));
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // _dbClient.ref('users/${_authClient.currentUser!.uid}').delete();

      await _firestoreClient
          .collection('users')
          .doc(_authClient.currentUser!.uid)
          .delete();
      await HiveBox.clear();
      return _authClient.currentUser!.delete();
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
      return Future.value();
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await AutorizeUserUtils.authorizeUser(_authClient);
      switch (action) {
        case UpdateUserAction.displyName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserdata({Strings.name: userData as String});

        case UpdateUserAction.profilePic:
          final ref = _dbClient.ref().child(
                '${FirebaseStrings.profilePics}/${_authClient.currentUser?.uid}',
              );
          // update the image in storage
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();

          await _authClient.currentUser?.updatePhotoURL(url);

          await _updateUserdata({Strings.photoURl: url});

        case UpdateUserAction.fatherName:
          await _updateUserdata({Strings.fatherName: userData as String});

        case UpdateUserAction.gender:
          await _updateUserdata({Strings.gender: userData as String});

        case UpdateUserAction.dateOfBirth:
          await _updateUserdata({Strings.dateOfBirth: userData as String});
      }
      return Future.value();
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  Future<void> _setUserData({
    required String uid,
    required String name,
    required String fatherName,
    required String gender,
    required String dateOfBirth,
    required String mobileNumber,
    required int libraryCode,
    required String photoURL,
  }) async {
    await _firestoreClient.collection(FirebaseStrings.users).doc(uid).set(
          LocalUserModel(
            name: name,
            fatherName: fatherName,
            gender: gender,
            dateOfBirth: dateOfBirth,
            photoURL: photoURL,
            mobileNumber: mobileNumber,
            libraryCode: libraryCode,
            uid: uid,
          ).toMap(),
        );
  }

  Future<void> _updateUserdata(DataMap map) async {
    await _firestoreClient
        .collection(FirebaseStrings.users)
        .doc(_authClient.currentUser!.uid)
        .update(map);
  }
}
