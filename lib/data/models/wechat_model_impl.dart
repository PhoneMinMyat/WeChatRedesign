import 'dart:io';

import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/vos/conversation_vo.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';
import 'package:wechat_redesign/network/we_chat_data_agent_impl.dart';

class WeChatModelImpl extends WeChatModel {
  static final WeChatModelImpl _singleton = WeChatModelImpl._internal();

  factory WeChatModelImpl() {
    return _singleton;
  }
  WeChatModelImpl._internal();

  WeChatDataAgent dataAgent = WeChatDataAgentImpl();
  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  @override
  Stream<List<MomentVO>> getMoment() {
    return dataAgent.getMoments();
  }

  @override
  Future<void> addNewMoment(String description, File? file, bool isVideo) {
    if (file != null) {
      return dataAgent.uploadFileToFirebase(file).then((fileUrl) {
        craftMomentVO(description, fileUrl, isVideo)
            .then((newMoment) => dataAgent.addNewMoment(newMoment));
      });
    } else {
      return craftMomentVO(description, '', false)
          .then((newMoment) => dataAgent.addNewMoment(newMoment));
    }
  }

  Future<MomentVO> craftMomentVO(
    String description,
    String fileUrl,
    bool isVideo,
  ) {
    var currentMilliSeconds = DateTime.now().millisecondsSinceEpoch;
    return authenticationModel.getLoggedInUser().then((user) {
      MomentVO tempMoment = MomentVO(
          id: currentMilliSeconds,
          description: description,
          postImageUrl: fileUrl,
          isFileTypeVideo: isVideo,
          profilePicUrl: user.profilePictureUrl,
          userName: user.userName,

          userId: user.id);

      return Future.value(tempMoment);
    });
  }

  @override
  Future<void> editNewMoment(MomentVO moment, File? file) {
    if (file != null) {
      return dataAgent.uploadFileToFirebase(file).then((fileUrl) {
        MomentVO tempPost = moment;
        tempPost.postImageUrl = fileUrl;
        dataAgent.addNewMoment(tempPost);
      });
    } else {
      return dataAgent.addNewMoment(moment);
    }
  }

  @override
  Future<void> deleteMoment(int momentId) {
    return dataAgent.deleteMoment(momentId);
  }

  @override
  Stream<MomentVO> getMomentById(int momentId) {
    return dataAgent.getMomentById(momentId);
  }

  //Contacts
  @override
  Future<void> addContact(String sentUserId, String receiveId) async {
    UserVO sentUser = await getUserById(sentUserId);
    UserVO receivedUser = await getUserById(receiveId);
    return dataAgent.addContact(sentUser, receivedUser);
  }

  @override
  Future<UserVO> getUserById(String userId) {
    return dataAgent.getUserById(userId);
  }

  @override
  Stream<List<UserVO>> getContactList(String userId) {
    return dataAgent.getContactList(userId);
  }

  @override
  Future<void> sentMessage(
      String message, File? file, bool isVideo, String receivedUserId) {
    if (file != null) {
      return dataAgent.uploadFileToFirebase(file).then((fileUrl) =>
          craftMessageVO(message, fileUrl, isVideo, receivedUserId)
              .then((messageVO) => dataAgent.sentMessage(messageVO)));
    } else {
      return craftMessageVO(message, '', isVideo, receivedUserId)
          .then((messageVO) => dataAgent.sentMessage(messageVO));
    }
  }

  Future<MessageVO> craftMessageVO(String message, String fileUrl, bool isVideo,
      String receivedUserId) async {
    var currentSeconds =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
    UserVO loggedInUser = await authenticationModel.getLoggedInUser();
    UserVO receivedUser = await getUserById(receivedUserId);
    MessageVO tempMessage = MessageVO(
        timestamp: int.parse(currentSeconds),
        fileUrl: fileUrl,
        isFileTypeVideo: isVideo,
        message: message,
        receivedUserId: receivedUserId,
        receivedUserProfileUrl: receivedUser.profilePictureUrl,
        receivedUserName: receivedUser.userName,
        sentUserId: loggedInUser.id,
        sentUserProfileUrl: loggedInUser.profilePictureUrl,
        sentUserName: loggedInUser.userName);

    return Future.value(tempMessage);
  }
  
  @override
  Stream<List<MessageVO>> getMessageList(String userId, String receivedUserId) {
    return dataAgent.getMessageList(userId, receivedUserId);
  }

  @override
  Stream<List<ConversationVO>> getConversationList(String userId) {
    return dataAgent.getConversationList(userId);
  }
  
  @override
  Future<void> deleteMessage(String userId, String receiverId, bool isDeleteForAllUsers) {
    return dataAgent.deleteMessage(userId, receiverId, isDeleteForAllUsers);
  }
  
  @override
  Future<void> updateUserBio(String newBioText) {
   return authenticationModel.getLoggedInUser().then((loggedInUser){
    UserVO tempUser = loggedInUser;
    tempUser.bioText = newBioText;
    dataAgent.updateUserBioText(tempUser);
   });
  }
 
}
