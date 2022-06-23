import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/resources/strings.dart';

class QrBloc extends ChangeNotifier {
  bool isDisposed = false;
  String userId = '';
  String userName = '';
  String userProfileUrl = NETWORK_PROFILE_PLACEHOLDER;

  AuthenticationModel authenticationModel = AuthenticationModelImpl();
  QrBloc() {
    authenticationModel.getLoggedInUser().then((user) {
      userId = user.id ?? '';
      userName = user.userName ?? '';
      userProfileUrl = user.profilePictureUrl ?? '';
      safeNotifyListeners();
    });
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
