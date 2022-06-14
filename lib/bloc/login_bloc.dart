import 'package:flutter/foundation.dart';

class LogInBloc extends ChangeNotifier{
  bool isSignUp = false;

  bool isDisposed = false;
  

  void onTapSwitchLogIn(){
    isSignUp = !isSignUp;
    safeNotifyListeners();
  }

  void safeNotifyListeners(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}