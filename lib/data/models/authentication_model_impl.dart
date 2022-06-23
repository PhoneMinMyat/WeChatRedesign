import 'dart:io';

import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/fcm/fcm_service.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';
import 'package:wechat_redesign/network/we_chat_data_agent_impl.dart';
import 'package:wechat_redesign/resources/strings.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  final WeChatDataAgent _dataAgent = WeChatDataAgentImpl();

  @override
  Future<void> registerNewUser(UserVO newUser, File? profileImage) {
    if (profileImage != null) {
      return _dataAgent.uploadFileToFirebase(profileImage).then((downloadUrl) {
        newUser.profilePictureUrl = downloadUrl;
        addFCMTokenToUserVo(newUser)
            .then((value) => _dataAgent.registerNewUser(newUser));
      });
    } else {
      newUser.profilePictureUrl = NETWORK_PROFILE_PLACEHOLDER;
      return addFCMTokenToUserVo(newUser)
          .then((value) => _dataAgent.registerNewUser(newUser));
    }
  }

  Future<UserVO> addFCMTokenToUserVo(UserVO user) {
    return FCMService().getFcmToken().then((fcmToken) {
      UserVO tempUser = user;
      tempUser.fcmToken = fcmToken;
      return tempUser;
    });
  }

  @override
  Future<UserVO> getLoggedInUser() {
    return _dataAgent.getLogInUser();
  }

  @override
  bool isLoggedIn() {
    return _dataAgent.isLoggedIn();
  }

  @override
  Future<void> logInUser(String email, String password) {
    return _dataAgent.logInUser(email, password);
  }

  @override
  Future<void> logOut() {
    return _dataAgent.logOut();
  }
}
