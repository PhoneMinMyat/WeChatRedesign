import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';

class LogInBloc extends ChangeNotifier {
  bool isDisposed = false;
  bool isLoading = false;

  String email = '';
  String password = '';

  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  void onEmailChanged(newEmail) {
    email = newEmail;
  }

  void onPasswordChanged(newPW) {
    password = newPW;
  }

  Future onTapAccept() {
    _showLoading();
    return authenticationModel
        .logInUser(email, password)
        .whenComplete(() => _hideLoading());
  }

  void _showLoading() {
    isLoading = true;
    safeNotifyListeners();
  }

  void _hideLoading() {
    isLoading = false;
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
