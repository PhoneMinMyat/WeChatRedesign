import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class GetEmailBloc extends ChangeNotifier {
  bool isDisposed = false;
  bool isLoading = false;
  UserVO? userVO;
  File? userProfileImage;

  String email = '';

  AuthenticationModel model = AuthenticationModelImpl();

  GetEmailBloc(UserVO? user, File? image) {
    userVO = user;
    userProfileImage = image;
  }

  Future<void> onTapOk() {
    _showLoading();
    userVO?.email = email;
   return model
        .registerNewUser(userVO ?? UserVO(), userProfileImage)
        .whenComplete(() => _hideLoading());
  }

  void onChangeEmail(String newEmail) {
    email = newEmail;
    safeNotifyListeners();
  }

  void _showLoading() {
    isLoading = true;
    safeNotifyListeners();
  }

  void _hideLoading() {
    isLoading = false;
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
