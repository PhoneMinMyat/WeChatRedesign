import 'dart:io';

import 'package:wechat_redesign/data/vos/user_vo.dart';

abstract class AuthenticationModel {
  Future<void> registerNewUser(UserVO newUser, File? profileImage);
  Future<void> logInUser(String email, String password);
  bool isLoggedIn();
  Future<UserVO> getLoggedInUser();
  Future<void> logOut();
}
