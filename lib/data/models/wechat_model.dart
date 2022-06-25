import 'dart:io';

import 'package:wechat_redesign/data/vos/conversation_vo.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

abstract class WeChatModel {
  Stream<List<MomentVO>> getMoment();
  Future<void> addNewMoment(String description, File? file, bool isVideo);
  Future<void> editNewMoment(MomentVO moment, File? file);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
  Future<UserVO> getUserById(String userId);
  Future<void> addContact(String sentUserId, String receiveId);

  Future<void> updateUserBio(String newBioText);

  Stream<List<UserVO>> getContactList(String userId);

  //Contact
  Future<void> sentMessage(String message, File? file, bool isVideo, String receivedUserId);
  Stream<List<MessageVO>> getMessageList(String userId, String receivedUserId);
  Stream<List<ConversationVO>> getConversationList(String userId);
  Future<void> deleteMessage(String userId, String receiverId, bool isDeleteForAllUsers);
}
