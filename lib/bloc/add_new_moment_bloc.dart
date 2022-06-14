import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/resources/strings.dart';

class AddNewMomentBloc extends ChangeNotifier {
  bool isEditMode = false;
  bool isLoading = false;
  bool isDisposed = false;
  bool isEmptyDescriptionError = false;
  bool isExpanded = true;
  String profilePicUrl = '';
  String userName = '';
  String momentDescription = '';
  List<String> videoFormatList = [
    'mp4',
    'mpeg4',
    'mov',
    'wmv',
    'avi',
  ];

  File? choseFile;
  String? fileUrl;
  bool? isFileTypeVideo;
  MomentVO? momentVO;
  FlickManager? flickManager;

  final WeChatModel model = WeChatModelImpl();

  AddNewMomentBloc(int? editMomentId) {
    if (editMomentId == null) {
      prepopulateDataForAddMode();
    } else {
      isEditMode = true;
      prepopulateDataForEditMode(editMomentId);
    }
  }

  Future<void> onTapPost() {
    if (momentDescription.isEmpty) {
      isEmptyDescriptionError = true;
      safeNotifyListeners();
      return Future.error('error');
    } else {
      isLoading = true;
      isEmptyDescriptionError = false;
      safeNotifyListeners();
      if (isEditMode) {
        return editMoment().then((value) {
          isLoading = false;
          safeNotifyListeners();
        });
      } else {
        return addNewPost().then((value) {
          isLoading = false;
          safeNotifyListeners();
        });
      }
    }
  }

  Future<void> addNewPost() {
    return model.addNewMoment(
        momentDescription, choseFile, isFileTypeVideo ?? false);
  }

  Future<void> editMoment() {
    momentVO?.description = momentDescription;
    if (fileUrl == null) {
      momentVO?.postImageUrl = '';
    }
    if (momentVO != null) {
      return model.editNewMoment(
          momentVO!, choseFile, isFileTypeVideo ?? false);
    } else {
      return Future.error('error');
    }
  }

  void onImageChosen(File choseFile, String extension) async {
    await flickManager?.flickControlManager?.autoPause();
    this.choseFile = choseFile;
    checkIsVideo(extension);

    craftFlickManager();
    safeNotifyListeners();
  }

  void onTapDeleteImage() async {
    await flickManager?.flickControlManager?.autoPause();
    choseFile = null;
    fileUrl = null;
    isFileTypeVideo = null;

    safeNotifyListeners();
  }

  void checkIsVideo(String extension) {
    isFileTypeVideo = videoFormatList.contains(extension.toLowerCase());
  }

  void prepopulateDataForAddMode() {
    userName = 'Phone Min Myat';
    profilePicUrl = tempProfileLink;
    safeNotifyListeners();
  }

  void prepopulateDataForEditMode(int momentId) {
    model.getMomentById(momentId).listen((moment) {
      userName = moment.userName ?? '';
      profilePicUrl = moment.profilePicUrl ?? '';
      momentDescription = moment.description ?? '';
      fileUrl = moment.postImageUrl ?? '';
      isFileTypeVideo = moment.isFileTypeVideo ?? false;
      momentVO = moment;
      craftFlickManager();
      safeNotifyListeners();
    });
  }

  void craftFlickManager() {
    if (isFileTypeVideo ?? false) {
      flickManager = FlickManager(
          videoPlayerController: (fileUrl == null || (fileUrl?.isEmpty ?? true))
              ? VideoPlayerController.file(choseFile ?? File(''))
              : VideoPlayerController.network(fileUrl ?? ''),
          autoPlay: false);
    }
  }

  void onTextChanged(newText) {
    momentDescription = newText;
  }

  void onTapExpanded() {
    isExpanded = !isExpanded;
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
    flickManager?.dispose();
    super.dispose();
  }
}
