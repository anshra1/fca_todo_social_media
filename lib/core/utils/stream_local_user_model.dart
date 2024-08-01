import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning_go_router/core/services/import.dart';
import 'package:flutter_learning_go_router/core/strings/firebase_strings.dart';
import 'package:flutter_learning_go_router/src/auth/data/model/local_user_model.dart';

class StreamUserDataUtis {
  StreamUserDataUtis._();

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
      .collection(FirebaseStrings.users)
      .doc(sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map(
        (doc) => LocalUserModel.fromMap(doc.data()!),
      );
}
