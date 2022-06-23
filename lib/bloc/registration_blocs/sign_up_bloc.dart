import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class SignUpBloc extends ChangeNotifier {
  bool isDisposed = false;
  File? choseImageFile;
  String name = '';
  String dialNumber = '+95';
  String phoneNumber = '';
  String password = '';
  bool isCheckTermsAndCondition = false;
  bool isConfirmButtonAvailable = false;

  void onTapChoseImageFile(File choseImage) {
    choseImageFile = choseImage;
    safeNotifyListeners();
  }

  void onChangeName(newName) {
    name = newName;
    checkButtonAvailable();
  }

  void onChangeDialNumber(newDial) {
    dialNumber = newDial;
    checkButtonAvailable();
    safeNotifyListeners();
  }

  void onChangePhoneNumber(newNumber) {
    phoneNumber = newNumber;
    checkButtonAvailable();
  }

  void onChangePassword(newPW) {
    password = newPW;
    checkButtonAvailable();
  }

  void onTapTermsAndCondition(newValue) {
    isCheckTermsAndCondition = newValue;

    checkButtonAvailable();
    safeNotifyListeners();
  }

  Future<UserVO> onTapAcceptButton() {
    if (isConfirmButtonAvailable) {
      return craftUserVO();
    }else{
      return Future.error('Error');
    }
  }

  Future<UserVO> craftUserVO() {
    UserVO tempUserVO = UserVO(
        id: null,
        email: null,
        userName: name,
        password: password,
        phoneNumber: dialNumber + phoneNumber,
        profilePictureUrl: null);

    return Future.value(tempUserVO);
  }

  void checkButtonAvailable() {
    if (name.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        password.isNotEmpty &&
        isCheckTermsAndCondition) {
      isConfirmButtonAvailable = true;
    } else {
      isConfirmButtonAvailable = false;
    }
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
