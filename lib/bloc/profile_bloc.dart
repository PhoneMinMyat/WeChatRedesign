 import 'package:flutter/foundation.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class ProfileBloc extends ChangeNotifier{

bool isDisposed = false;
UserVO? loggedInProfile ;

AuthenticationModel authenticationModel = AuthenticationModelImpl();

ProfileBloc(){
  authenticationModel.getLoggedInUser().then((user) {
    loggedInProfile = user;
    safeNotifyListeners();
  });
}

Future onTapLogOut(){
  return authenticationModel.logOut();
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