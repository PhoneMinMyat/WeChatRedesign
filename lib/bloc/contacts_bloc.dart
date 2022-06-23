import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';

import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class AZItem extends ISuspensionBean {
  String tag;
  UserVO user;
  AZItem({
    required this.tag,
    required this.user,
  });

  @override
  String getSuspensionTag() {
    return tag;
  }
}

class ContactsBloc extends ChangeNotifier {
  bool isDisposed = false;
  List<UserVO>? contactList;
  List<AZItem>? azItems;

  WeChatModel model = WeChatModelImpl();
  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  ContactsBloc() {
    print('Reached Contach Bloc');
    authenticationModel.getLoggedInUser().then((loggedInUser) {
      model.getContactList(loggedInUser.id ?? '').listen((returnContactList) {
        contactList = returnContactList;

        if (contactList != null) {
          creatAzItems(contactList!);
        }

        safeNotifyListeners();
      });
    });
  }

  void creatAzItems(List<UserVO> userList) {
    azItems = userList
        .map((user) =>
            AZItem(tag: user.userName?[0].toUpperCase() ?? '', user: user))
        .toList();

    SuspensionUtil.sortListBySuspensionTag(azItems);
    SuspensionUtil.setShowSuspensionStatus(azItems);

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
