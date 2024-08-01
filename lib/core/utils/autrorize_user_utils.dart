import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';

class AutorizeUserUtils {
  AutorizeUserUtils._();

  static Future<void> authorizeUser(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: '401',
      );
    }
  }
}
