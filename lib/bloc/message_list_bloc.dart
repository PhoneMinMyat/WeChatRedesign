import 'package:flutter/cupertino.dart';

class MessageListBloc extends ChangeNotifier{
  bool isShowPopUp  = false;
  bool isDisposed = false;

  void changePopUpStatus(){
    isShowPopUp = !isShowPopUp;
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