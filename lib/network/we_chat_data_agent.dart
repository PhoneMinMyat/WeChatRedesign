import 'dart:io';

import 'package:wechat_redesign/data/vos/conversation_vo.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

abstract class WeChatDataAgent {
  Stream<List<MomentVO>> getMoments();
  Future<void> addNewMoment(MomentVO moment);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
  Future<String> uploadFileToFirebase(File uploadFile);

  //Authentication
  Future registerNewUser(UserVO newUser);
  Future<void> addNewUser(UserVO newUser);
  Future<void> logInUser(String email, String password);
  bool isLoggedIn();
  Future logOut();
  Future<UserVO> getLogInUser();
  Future<UserVO> getUserById(String userId);

  //Contacts
  Future addContact(UserVO sentUser, UserVO receivedUser);
  Stream<List<UserVO>> getContactList(String userId);

  //Messages
  Stream<List<ConversationVO>> getConversationList(String userId);
  Stream<List<MessageVO>> getMessageList(String userId, String receiverId);
  Future<void> sentMessage(MessageVO message);
  Future<void> deleteMessage(
      String userId, String receiverId, bool isDeleteForAllUsers);
  void getTestConverstaionList(String userId);

  //User
  Future<void> updateUserBioText(UserVO user);
}
