import 'dart:io';

import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';
import 'package:wechat_redesign/network/we_chat_data_agent_impl.dart';
import 'package:wechat_redesign/resources/strings.dart';

class WeChatModelImpl extends WeChatModel {
  static final WeChatModelImpl _singleton = WeChatModelImpl._internal();

  factory WeChatModelImpl() {
    return _singleton;
  }
  WeChatModelImpl._internal();

  WeChatDataAgent dataAgent = WeChatDataAgentImpl();

  @override
  Stream<List<MomentVO>> getMoment() {
    return dataAgent.getMoments();
  }

  @override
  Future<void> addNewMoment(String description, File? file, bool isVideo) {
    if (file != null) {
      return dataAgent.uploadFileToFirebase(file).then((fileUrl) {
        craftMomentVO(description, fileUrl, isVideo).then((newMoment) => dataAgent.addNewMoment(newMoment));
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
    MomentVO tempMoment = MomentVO(
        id: currentMilliSeconds,
        description: description,
        postImageUrl: fileUrl,
        isFileTypeVideo: isVideo,
        profilePicUrl: tempProfileLink,
        userName: 'Phone Min Myat');
    return Future.value(tempMoment);
  }

  @override
  Future<void> editNewMoment(MomentVO moment, File? file, bool isVideo) {
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
}
