import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/resources/strings.dart';

class ChatBloc extends ChangeNotifier {
  bool isDisposed = false;
  bool isAttachViewExpanded = false;
  bool isFileTypeVideo = false;
  List<String> videoFormatList = [
    'mp4',
    'mpeg4',
    'mov',
    'wmv',
    'avi',
  ];

  File? chosenFile;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  List<MessageVO>? messageList;

  String friendName = '';
  String friendId = '';
  String message = '';

  WeChatModel model = WeChatModelImpl();
  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  String fileUrlForShowDetail = '';
  bool isShowDetails = false;
  bool isLoading = false;

  ChatBloc(String friendId) {
    model.getUserById(friendId).then((userVO) {
      friendName = userVO.userName ?? '';
      this.friendId = friendId;
      safeNotifyListeners();
    });

    authenticationModel.getLoggedInUser().then((loggedInUser) {
      model
          .getMessageList(loggedInUser.id ?? '', friendId)
          .listen((messageList) {
        this.messageList = messageList
            .map((message) {
              MessageVO tempMessage = message;
              tempMessage.isUserMessage =
                  (message.sentUserId == loggedInUser.id);
              return tempMessage;
            })
            .toList()
            .reversed
            .toList();
        safeNotifyListeners();
      });
    });
  }

  void onTapImage(String fileUrl) {
    isShowDetails = true;
    fileUrlForShowDetail = fileUrl;
    safeNotifyListeners();
  }

  void closeDetails() {
    isShowDetails = false;
    fileUrlForShowDetail = NETWORK_PROFILE_PLACEHOLDER;
    safeNotifyListeners();
  }

  void onChangedMessage(String newMessage) {
    message = newMessage;
  }

  void onSubmitted(String newValue) {
    if (message.isNotEmpty || chosenFile != null) {
      _makeLoading();
      model
          .sentMessage(message, chosenFile, isFileTypeVideo, friendId)
          .then((value) {
        chosenFile = null;
        message = '';
        safeNotifyListeners();
      }).whenComplete(() => _cancelLoading());
    } else {
      print('Not Sent');
    }
  }

  void createVideoController() {
    if (chosenFile != null && isFileTypeVideo) {
      videoPlayerController = VideoPlayerController.file(chosenFile!);
    }
    if (videoPlayerController != null) {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoInitialize: true,
          aspectRatio: 16 / 9,
          autoPlay: false,
          looping: false);
    }
  }

  void onTapChoseImageFile(File choseFile, String extension) {
    chosenFile = choseFile;
    checkIsVideo(extension);
    safeNotifyListeners();
  }

  void onTapAdd() {
    isAttachViewExpanded = !isAttachViewExpanded;
    safeNotifyListeners();
  }

  void makeAtachmentViewExpanded() {
    isAttachViewExpanded = true;
    safeNotifyListeners();
  }

  void makeAtachmentViewShrink() {
    isAttachViewExpanded = false;
    safeNotifyListeners();
  }

  void checkIsVideo(String extension) {
    isFileTypeVideo = videoFormatList.contains(extension.toLowerCase());
    if (isFileTypeVideo) {
      createVideoController();
    }
  }

  void onTapDeleteChoseFile() {
    chosenFile = null;
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _makeLoading() {
    isLoading = true;
    safeNotifyListeners();
  }

  void _cancelLoading() {
    isLoading = false;
    safeNotifyListeners();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    isDisposed = true;
    super.dispose();
  }
}
