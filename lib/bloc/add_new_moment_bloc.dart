import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
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
  String profilePicUrl = NETWORK_PROFILE_PLACEHOLDER;
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

  final WeChatModel model = WeChatModelImpl();
  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  AddNewMomentBloc(MomentVO? editMoment) {
    if (editMoment == null) {
      prepopulateDataForAddMode();
    } else {
      isEditMode = true;
      prepopulateDataForEditMode(editMoment);
    }
  }

  Future<void> onTapPost() {
    if (momentDescription.isEmpty && choseFile == null) {
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
    momentVO?.isFileTypeVideo = isFileTypeVideo;
    if (choseFile == null) {
      momentVO?.postImageUrl = '';
      momentVO?.isFileTypeVideo = false;
    }
    if (momentVO != null) {
      return model.editNewMoment(momentVO!, choseFile);
    } else {
      return Future.error('error');
    }
  }

  void onImageChosen(File choseFile, String extension) async {
    this.choseFile = choseFile;
    checkIsVideo(extension);
    safeNotifyListeners();
  }

  void onTapDeleteImage() async {
    choseFile = null;
    fileUrl = null;
    isFileTypeVideo = null;

    safeNotifyListeners();
  }

  void checkIsVideo(String extension) {
    isFileTypeVideo = videoFormatList.contains(extension.toLowerCase());
    print('Check Video ====> $isFileTypeVideo');
  }

  void prepopulateDataForAddMode() {
    authenticationModel.getLoggedInUser().then((user) {
      userName = user.userName ?? '';
      profilePicUrl = user.profilePictureUrl ?? '';
      safeNotifyListeners();
    });
  }

  void prepopulateDataForEditMode(MomentVO editMoment) {
    // model.getMomentById(momentId).listen((moment) {
    //   userName = moment.userName ?? '';
    //   profilePicUrl = moment.profilePicUrl ?? '';
    //   momentDescription = moment.description ?? '';
    //   fileUrl = moment.postImageUrl ?? '';
    //   isFileTypeVideo = moment.isFileTypeVideo;
    //   momentVO = moment;
    //   print('Edited ====> moment ${momentVO.toString()}');
    //   safeNotifyListeners();
    // });

    userName = editMoment.userName ?? '';
    profilePicUrl = editMoment.profilePicUrl ?? '';
    momentDescription = editMoment.description ?? '';
    fileUrl = editMoment.postImageUrl ?? '';
    isFileTypeVideo = editMoment.isFileTypeVideo;
    momentVO = editMoment;
    safeNotifyListeners();
  }

  void onTextChanged(newText) {
    momentDescription = newText;
  }

  void onFocusTextField(){
    isExpanded = false;
    safeNotifyListeners();
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
    super.dispose();
  }
}
