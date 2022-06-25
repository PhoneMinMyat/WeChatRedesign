import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class ProfileBloc extends ChangeNotifier {
  bool isDisposed = false;
  UserVO? loggedInProfile;
  bool isAddNewBioPopUpShow = false;

  String addNewBioTitle = 'Add New Bio';
  String newBioButtonText = 'Add';
  String bioText = '';

  AuthenticationModel authenticationModel = AuthenticationModelImpl();
  WeChatModel weChatModel = WeChatModelImpl();

  ProfileBloc() {
    getLoggedInUser();
  }

  void getLoggedInUser() {
    authenticationModel.getLoggedInUser().then((user) {
      loggedInProfile = user;
      if (loggedInProfile?.bioText?.isNotEmpty ?? false) {
        addNewBioTitle = 'Edit Bio';
        newBioButtonText = 'Edit';
      }
      safeNotifyListeners();
    });
  }

  Future onTapLogOut() {
    return authenticationModel.logOut();
  }

  Future onTapBioAccept() {
    if (bioText.isNotEmpty) {
      return weChatModel.updateUserBio(bioText).then((value) {
        getLoggedInUser();
      }).whenComplete(() => hideBioPopUp());
    } else {
      return Future.error('error');
    }
  }

  void showBioPopUp() {
    isAddNewBioPopUpShow = true;
    safeNotifyListeners();
  }

  void hideBioPopUp() {
    isAddNewBioPopUpShow = false;
    safeNotifyListeners();
  }

  void onChangedBio(String newBio) {
    bioText = newBio;
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
