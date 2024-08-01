import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/src/auth/data/model/local_user_model.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _localUserModel;

  LocalUserModel? get user => _localUserModel;

  void initUser(LocalUserModel? localUserModel) {
    _localUserModel = localUserModel;
    notifyListeners();
  }

  set user(LocalUserModel? localUserModel) {
    if (_localUserModel != localUserModel) {
      _localUserModel = localUserModel;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
